---
name: verify-cross-refs
description: Pre-commit gate that verifies every §-style cross-reference in a HeimaEden .md post points to an actual heading (##, ###, ####). Catches "phantom §步骤 9" type drift. Also flags cross-reference facts that lack anchor basis per CLAUDE.md §3.8 rule 6. Use as a gate before commit-with-prefix, or standalone when user says "verify cross-refs" / "check references".
---

# verify-cross-refs

Pre-commit gate：验证文章里所有 `§`-style 锚点指向实际 heading，并标记无锚点 cross-reference 凭空结论（CLAUDE.md §3.8 rule 6）。

## 触发场景

- `commit-with-prefix` skill 串行调用（Gate B）
- 用户说："verify cross-refs" / "check references" / "检查锚点"
- 文章重构 / 章节重排后立即验证
- OCM 阶段 4（[zh-final] 中文定稿）完成后

## 检查项（2 类）

### A. 锚点引用必须指向存在的 heading

**扫描模式**（正文里）：
```
§步骤 X        # X 是数字
§附录 X.Y      # X.Y 是数字编号
§常见错误
§优缺点
§优缺点表格
§组合对比
§最后贴士
§结论
§前置条件
§引言
§主线
```

**检查**：每个 `§<name>` ref 必须匹配 `^## <name>` 或 `^### <name>` 的实际 heading。

### B. 跨文章 / 跨工具 cross-reference 必须有锚点（§3.8 rule 6）

**触发场景**：正文出现：
- "AdSense 收款可直接复用 PayPal 通道"
- "详见 XXX 文章"
- "前面提过"
- "如前文所述"

**判定**：必须能在以下任一锚点直接验证：
- (a) 用户本会话口述
- (b) `CLAUDE.md` / `README.md` / `docs/*.md` 已有记录
- **无锚点 → 必须用占位语**（如 "详见 XXX 文章" / "[待确认：YYY]"），**绝不写结论句**

## 工作流（5 步）

### 1. 提取所有 `§` 引用

```bash
grep -oE '§[一-龥]+' content/posts/<category>/<slug>.md | sort -u
```

匹配中文章节名（CJK Unicode range）。

### 2. 提取所有 heading

```bash
grep -E '^##+ ' content/posts/<category>/<slug>.md | awk '{print $2, $3, ...}' | sort -u
```

提取 `## <name>` / `### <name>` 的实际标题文本。

### 3. 配对：ref → heading

对每个 `§<name>` ref，搜索实际 heading：

```
$ref §步骤 1     → 寻找 `## 步骤 1` / `### 步骤 1` 等
$ref §附录 A.1   → 寻找 `## 附录 A` 下的 `### A.1` 或 `### A.1：xxx`
$ref §常见错误   → 寻找 `## 常见错误`
```

**不匹配 → 报告 invalid ref**。

### 4. 跨文章 cross-reference 锚点检查

对每个结论句（"AdSense 收款可直接复用 PayPal 通道" 这类）：
- 搜 `README.md`、`CLAUDE.md`、`docs/*.md` 有没有相关记录
- 搜本会话历史有没有用户口述
- **无锚点 → 报告 phantom conclusion**（per §3.8 rule 6 严重违规）

### 5. 输出

```
=== verify-cross-refs: content/posts/ai-agent/claude-code-cli-setup-indie-blog.md ===

§-references found (12):
  ✓ §步骤 1              → "## 步骤 1：让 Claude 读..."
  ✓ §步骤 2              → "## 步骤 2：验证..."
  ✓ §步骤 3              → "## 步骤 3：保存会话..."
  ✓ §常见错误            → "## 常见错误与修复"
  ✓ §优缺点              → "## 一人博客的 CLI 优先..."
  ✓ §组合对比            → "## 单家 Claude vs..."
  ✓ §最后贴士            → "## 最后贴士"
  ✓ §结论                → "## 结论"
  ✓ §附录 A              → "## 附录 A：..."
  ✓ §附录 A.1            → "### A.1：动键盘前..."
  ✓ §附录 A.2            → "### A.2：通过 npm..."
  ✓ §附录 A.3            → "### A.3：进入博客..."

Phantom refs: 0
Cross-document facts needing anchors: 0

=== RESULT: PASS (12/12) ===
```

或失败时：
```
=== RESULT: FAIL (3 errors) ===

❌ §步骤 9 NOT FOUND (only §步骤 1-3 + §附录 A.1-A.3 exist)
❌ §附录 A.4 NOT FOUND (附录 A only has A.1-A.3)
❌ Phantom conclusion at line 287: "AdSense 收款可直接复用 PayPal 通道"
   No anchor in CLAUDE.md / README.md / docs/*.md
   Per §3.8 rule 6 — MUST rewrite as placeholder or remove

Action required:
1. Either change §步骤 9 → §步骤 3, or add new section
2. Either change §附录 A.4 → §附录 A.3 or remove ref
3. Either remove phantom conclusion or add anchor basis
```

## 检测 phantom conclusion 的启发式

下列模式提示可能是无锚点 cross-reference（需人工确认）：

```bash
# "可直接复用" / "可以直接走" / "走同一通道" — 暗示事实性结论
grep -nE '可直接复用|可以直接走|走同一通道|无缝切换|自动同步' content/posts/<slug>.md

# "前面提过" / "如前文所述" / "前面说过"
grep -nE '前面提过|如前文所述|前面说过|之前说过|之前提到' content/posts/<slug>.md

# "详见 XXX 文章" — 占位语（合规）
grep -nE '详见|参见|参考' content/posts/<slug>.md

# 跨文章引用（合规但需核对）
grep -oE '\[\[.+?\]\]|\(.+?\.md\)' content/posts/<slug>.md
```

**判定**：
- 命中第一组 + 无锚点 → **phantom conclusion**（严重违规）
- 命中第二组 + 实际无前文 → **phantom conclusion**（严重违规）
- 命中第三组 → **合规占位语**（pass）
- 命中第四组 → 需手工核对链接是否指向真实文件

## 硬约束引用

- **CLAUDE.md §3.8 rule 6**：cross-reference 必须有显式锚点
- **CLAUDE.md §3.8 rule 5**：翻译阶段不改写、不增删事实
- **docs/article-writing-workflow.md §5.1**：他人 reported 坑、官方引用、AI 编造区分

## 失败兜底

| 场景 | 处理 |
|---|---|
| §X.Y 引用不匹配 | 报告 invalid ref，提示最近邻的可用 ref |
| Phantom conclusion 命中 | 报告原文 + 行号 + 推荐改写为占位语或加锚点 |
| 跨文章链接未指向真实文件 | 报告 broken link |
| `[[wikilink]]` 风格未识别 | 提示 Hugo shortcode 应为 `{{< ref "path" >}}`（CLAUDE.md §3.4） |