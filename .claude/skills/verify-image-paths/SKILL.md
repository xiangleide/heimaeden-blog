---
name: verify-image-paths
description: Pre-commit gate that verifies every image reference in a HeimaEden .md post resolves to a file under assets/images/, is ≤1440px wide, and has English-only alt text. Catches broken render-image.html references before commit. Use as a gate before commit-with-prefix, or standalone when user says "verify images" / "check image paths".
---

# verify-image-paths

Pre-commit gate：验证文章里所有图片引用合规（路径 + 尺寸 + alt）。**有 warning 就不算 commit 干净**。

## 触发场景

- `commit-with-prefix` skill 串行调用（Gate A）
- 用户说："verify images" / "check image paths" / "image audit"
- TCM 阶段 5（英文翻译 + lint）之前自动调用
- 新截图加入 `assets/images/` 后立即验证

## 检查项（4 条硬约束）

### A. 路径必须落在 `assets/images/<category>/<article-slug>/`

**扫描对象**：
1. Markdown body 里的 `![alt](/path)` 引用
2. Front matter 的 `[cover].image`

**正确格式**（CLAUDE.md §3.3.1）：
```
![alt](/images/<category>/<article-slug>/<purpose>.png)
```

**错误格式 → 报错**：
- `/images/foo.png`（缺 `<category>/<article-slug>/`）
- `/static/images/foo.png`（**禁止**含 `static/` 前缀——这是 OG card 专用目录）
- `assets/images/foo.png`（**必须**以 `/images/` 开头，去掉 `assets/`）
- 绝对路径如 `https://...`（应先用 `assets/images/` 本地化）

### B. 文件实际存在

对每个 `/images/...` 引用，检查：
- `assets/<去前缀 images>/<路径>` 文件存在
- 例：`![](/images/ai-agent/foo/step-1.png)` → 检查 `assets/images/ai-agent/foo/step-1.png`

如果文件不存在 → **render-image.html hook 会 warning**，**视为错误**。

### C. 宽度 ≤1440px

对每个存在的图片，跑：
```bash
sips -g pixelWidth <path>
```

**期望**：≤ 1440。**违规** → 必须先跑 `./scripts/optimize-image.sh`。

### D. alt 文本无 CJK + 非空

对每个 `![alt](/path)`：
- `alt` 不能为空
- `alt` 不能含 CJK 字符（per CLAUDE.md §3.2 lint 规则）

CJK 检测 regex（perl）：
```
[\x{4e00}-\x{9fff}\x{3400}-\x{4dbf}\x{3040}-\x{309f}\x{30a0}-\x{30ff}\x{ff00}-\x{ffef}]
```

## 工作流（4 步）

### 1. 收集所有引用

```bash
# Body 引用
grep -oE '!\[[^\]]*\]\(/images/[^)]+\)' content/posts/<category>/<slug>.md

# Front matter cover
grep -E '^\s*image\s*=\s*"' content/posts/<category>/<slug>.md
```

### 2. 路径合规检查

对每个 ref：
- 检查 `static/` 前缀 → ❌
- 检查 `/images/<category>/<article-slug>/` 结构 → ❌ if missing
- 检查 `<category>` 与 front matter `categories[0]` 一致 → ❌ if mismatch
- 检查 `<article-slug>` 与文件所在目录名一致 → ❌ if mismatch

### 3. 文件存在 + 尺寸检查

```bash
for ref in $(grep -oE '/images/[^)]+\.(png|jpg|jpeg|webp)' content/posts/<slug>.md); do
  asset_path="assets${ref}"   # /images → assets/images
  if [ ! -f "$asset_path" ]; then
    echo "❌ MISSING: $asset_path"
  else
    width=$(sips -g pixelWidth "$asset_path" | awk '/pixelWidth/{print $2}')
    if [ "$width" -gt 1440 ]; then
      echo "❌ OVERSIZED ($width px): $asset_path"
    else
      echo "✓ $asset_path (${width}px)"
    fi
  fi
done
```

### 4. alt 文本 CJK + 非空检查

```bash
grep -oE '!\[[^\]]*\]\(/images/' content/posts/<slug>.md | \
  perl -ne 'if (/!\[([^\]]*)\]/) { my $alt=$1; if ($alt eq "") { print "❌ EMPTY alt\n"; } elsif ($alt =~ /[\x{4e00}-\x{9fff}\x{3400}-\x{4dbf}\x{3040}-\x{309f}\x{30a0}-\x{30ff}\x{ff00}-\x{ffef}]/) { print "❌ CJK in alt: $alt\n"; } else { print "✓ $alt\n"; } }'
```

## 输出格式

```
=== verify-image-paths: content/posts/ai-agent/claude-code-cli-setup-indie-blog.md ===

Body references (4):
  ✓ /images/ai-agent/claude-code-cli-setup-indie-blog/prereq-node-version.png (1280px)
  ✓ /images/ai-agent/claude-code-cli-setup-indie-blog/step-0-community-search.png (1280px)
  ✓ /images/ai-agent/claude-code-cli-setup-indie-blog/step-1-npm-install.png (1280px)
  ✓ /images/ai-agent/claude-code-cli-setup-indie-blog/step-3-claudemd-summary.png (1280px)

Front matter cover (1):
  ✓ ai-agent/claude-code-cli-setup-indie-blog/cover.jpg (1440px)

Alt text audit (4):
  ✓ "Terminal output of node --version..."
  ✓ "Claude Code REPL response..."
  ✓ "Terminal showing successful npm install..."
  ✓ "GitHub Issues page..."

=== RESULT: PASS (4/4) ===
```

或失败时：
```
=== RESULT: FAIL (2 errors) ===

❌ /images/foo/step-1.png NOT FOUND (expected at assets/images/foo/step-1.png)
❌ Alt text CJK: "终端显示安装成功" (must be English)

Action required:
1. mv screenshot to assets/images/foo/step-1.png
2. Rewrite alt text in English
3. Re-run this skill
```

## 硬约束引用

- **CLAUDE.md §3.3**：图片路径 + alt + 来源白名单
- **CLAUDE.md §3.3.1**：存储布局 + 路径命名
- **CLAUDE.md §3.3.2**：1440px ceiling（不可逆）
- **CLAUDE.md §3.3.3**：render-image.html hook warning = 错误
- **CLAUDE.md §3.2**：body + alt 文本无 CJK

## 失败兜底

| 场景 | 处理 |
|---|---|
| 文件找不到 | 报告 expected path，让用户 mv 或重命名 |
| 文件 >1440px | 提示跑 `optimize-image.sh <path>` |
| alt 空 | 提示用户补 alt（不能空） |
| alt 含 CJK | 提示翻译成英文 |
| `static/` 前缀 | 提示：`static/images/` 仅 OG card 用（CLAUDE.md §3.3.1） |
| `<category>` 与 front matter `categories[0]` 不一致 | 报告 mismatch，让用户 mv 文件夹 |