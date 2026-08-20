---
name: commit-with-prefix
description: Analyzes git diff for HeimaEden blog changes, suggests the correct commit prefix from CLAUDE.md §3.4, runs 4 pre-commit gates (verify-image-paths + verify-cross-refs + lint-post.sh + hugo --gc), composes the commit message, holds push per §6. Use when user says "commit" / "提交" / "git commit" / "commit 一下" / "stage 一下".
---

# commit-with-prefix

HeimaEden 提交流水线编排：分析 diff → 推荐 prefix → 串行跑 4 个 pre-commit gate → 精确 `git add` → 写 commit message → HOLD push 等用户 ack。

## 触发场景

- 用户说："commit 一下" / "提交" / "git commit" / "stage 一下"
- 用户说："[draft] <topic>" / "[zh-final] <topic>" / "[polish] <topic>" / "[asset] ..." / "[fix] ..." / "[correction] ..." / "[docs] ..."
- TCM 阶段 2/4/5/7 完成后（自动建议而非用户主动说）

## 不要做的事

- ❌ **不要 `git add -A` / `git add .`**——会带进 `docs/think-issue.md`（个人草稿区）、`.env`、临时文件。**始终 `git add <specific files>`**
- ❌ **不要自动 push**——CLAUDE.md §6 写死"git push 永远等用户 ack"
- ❌ **不要 amend 之前的 commit**——CLAUDE.md §6「CRITICAL: Always create NEW commits」
- ❌ **不要 `--no-verify` 跳过 hook**

## 工作流（8 步）

### 1. 分析改动（git status + git diff --stat）

```bash
git status --short
git diff --cached --stat   # 如果已有 staged
git diff --stat            # 全部 unstaged
```

输出按文件类型分桶：
- `.md` in `content/posts/` → 文章
- `.md` in `docs/` → 文档/封面 prompt
- `.jpg/.png/.webp` in `assets/images/` → 截图资产
- `.sh` in `scripts/` → 脚本
- `CLAUDE.md` / `README.md` / `Content-Agent-TCM.md` → 顶层规则文件
- `topic-pool.md` → 题目池

### 2. 推荐 prefix（按 CLAUDE.md §3.4）

| diff 主导内容 | 推荐 prefix | 例 |
|---|---|---|
| 中文初稿（阶段 2） | `[draft]` | `[draft] ai-agent-claude-code-cli` |
| 中文定稿（阶段 4） | `[zh-final]` | `[zh-final] ai-agent-claude-code-cli` |
| 英文最终版（阶段 7） | （**无前缀**） | `How to Set Up Claude Code CLI for...` |
| 修复 bug / typo / lint 失败 | `[fix]` | `[fix] a3-frontmatter-toml-syntax` |
| 补 cover / screenshot 资产 | `[asset]` | `[asset] a1-hugo-cf-pages-cover` |
| 改 front matter / 段落润色（无事实增删） | `[polish]` | `[polish] a2-cta-section-clarity` |
| 内容事实性更正（如版本号/配置名错） | `[correction]` | `[correction] a3-PayPal-PII` |
| 仅改 docs/、CLAUDE.md、SOP | `[docs]` | `[docs] article-writing-workflow-附G` |
| 跨多类（无法归一） | **拆 commit**，每个一类一个 | — |

### 3. 跑 4 个 pre-commit gate（**任一失败则 stop，不 commit**）

**并行**调用：

```bash
# Gate A：图片路径 + 1440px + alt CJK
.claude/skills/verify-image-paths/SKILL.md   # 由 skill 自触发

# Gate B：cross-reference 锚点有效
.claude/skills/verify-cross-refs/SKILL.md    # 由 skill 自触发

# Gate C：lint 通过（如果改了 .md）
./scripts/lint-post.sh content/posts/<path>.md   # 必须 0/0

# Gate D：hugo build 0 errors（CLAUDE.md §5 pre-action #3）
hugo --gc 2>&1 | tee /tmp/hugo-build.log
# 必须 0 errors；warning 可接受但需报告
```

**Gate A 失败示例**：
- 图片不在 `assets/images/<category>/<article-slug>/` → **必须先 mv，不能 commit**
- 图片 >1440px → 必须先跑 `optimize-image.sh`
- alt 文本含 CJK → 必须改英文

**Gate B 失败示例**：
- `§步骤 9` 但文档只到 §步骤 5 → 必须删 ref 或加章节
- phantom conclusion（"X 可无缝切换到 Y"）无锚点 → 必须改占位语

**Gate C 失败示例**：
- TOML 写成 YAML 风格 → 必须改 `:` 为 `=`
- 正文含 CJK 但没有 `lint_allow = ["cjk-body"]` → 必须改英文
- date 是未来时间 → 必须改过去时间（CLAUDE.md §3.1）

**Gate D 失败示例**：
- front matter TOML 错 → hugo 报 `unmarshal failed`
- 引用不存在的 shortcode → hugo 报 `template not found`
- 跨文章 ref 路径错 → hugo 报 `ref .* not found`
- 图片未在 `assets/images/` → render-image.html hook warning

**Gate D 触发条件**：
- ✅ 必须：所有改了 `.md` 的 commit
- ✅ 必须：所有改了 `layouts/` / `hugo.toml` 的 commit
- ⏸ 可跳过：纯 `.md` 文档类（`docs/`、`CLAUDE.md`、`.claude/skills/`）——除非改了 SOP 影响 lint 脚本
- ⏸ 可跳过：纯 `.sh` / 脚本类——但建议仍跑一次防止副带影响

### 4. E 方案判断（备份到临时分支）

**触发条件**（任一）：
- 改动跨 ≥3 个不相关文件
- 包含 doc 文件 + content 文件 + asset 文件
- 用户说："先 commit 备份一下" / "存个档"

```bash
git checkout -b temp/commit-<topic>-<yyyymmdd>
git add <files> && git commit -m "[backup] <topic> snapshot"
git checkout <original-branch>
git merge temp/commit-<topic>-<yyyymmdd>   # 如果只是要本地保留
```

如果用户只想本地留档、main 不要这个 commit，**只留在临时分支、不 merge**。

### 5. 精确 `git add`（**永远不用 `-A`**）

```bash
# 列出具体文件（来自 git status），逐个 add
git add content/posts/ai-agent/claude-code-cli-setup-indie-blog.md
git add assets/images/ai-agent/claude-code-cli-setup-indie-blog/step-1.png
# 不要：
# git add .                  ← 会带进 docs/think-issue.md
# git add -A                 ← 同上 + 可能 .env
```

**确认 staged 内容**：

```bash
git diff --cached --stat     # 再次确认范围
```

### 6. 写 commit message

格式：`<prefix> <topic>`（英文无前缀时 = title-case title）

```bash
git commit -m "$(cat <<'EOF'
[zh-final] ai-agent-claude-code-cli-setup-indie-blog

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

**Co-Authored-By 行永远在最后**（per CLAUDE.md git policy）。

### 7. 验证 commit 成功

```bash
git log -1 --stat            # 看 commit 内容
git status                   # 应该 clean
```

### 8. HOLD push（**永远不要 push**）

报告给用户：

```
✓ Commit landed: <hash> <prefix> <topic>
✓ Files staged: <count>
✓ Pre-commit gates: image-paths ✓ / cross-refs ✓ / lint ✓ / build ✓
⏸ Push: HOLD (per CLAUDE.md §6 — 等你 ack)
```

## 失败兜底

| 场景 | 处理 |
|---|---|
| Gate 失败 | **不要 commit**。报告哪个 gate 失败 + 哪条规则违反 + 推荐修复 |
| 用户 amend 之前的 commit | **拒绝**（CLAUDE.md §6 写死） |
| 用户 push --force | **拒绝并警告**（CLAUDE.md §4 forbidden patterns） |
| pre-commit hook 失败 | **不要 `--no-verify`**（CLAUDE.md §4） |
| 用户说"先 push 试试" | **拒绝**，必须先 ack 才能 push |

## 硬约束引用

- **CLAUDE.md §3.4**：prefix 列表来源
- **CLAUDE.md §3.8**：commit 边界 + 阶段对应
- **CLAUDE.md §4 forbidden**：amend / -A / --no-verify / push --force
- **CLAUDE.md §5 pre-action #3**：跑 `hugo --gc` 验证 0 errors
- **CLAUDE.md §6 destructive**：永远等 ack
- **docs/article-writing-workflow.md §附 D**：commit 边界总览