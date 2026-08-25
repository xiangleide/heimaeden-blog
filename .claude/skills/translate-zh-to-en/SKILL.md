---
name: translate-zh-to-en
description: Translates [zh-final] Chinese final draft into English final version. Strict CLAUDE.md §3.8 rule 5 + 6 — verbatim correspondence (one-to-one paragraph mapping), no fact addition/removal, preserve Chinese colloquial tone. Always runs verify-cross-refs as post-translation check, removes lint_allow. Use when user says "翻译" / "出英文版" / "translate" / TCM stage 7 trigger.
---

# translate-zh-to-en

HeimaEden 英文翻译生成器（TCM 阶段 7）。**核心职责**：把 [zh-final] 中文定稿逐段翻译成英文，**字面对应 + 不增删事实 + 保留中文口语化真实感**。

## 触发场景

- 用户说："翻译" / "出英文版" / "translate to English"
- TCM 阶段 6（用户 ack 推 push）前触发
- Task #5 [zh-final] 中文定稿 + 用户确认完成后自动触发

## 不要做的事

- ❌ **增删任何事实**——CLAUDE.md §3.8 rule 5 写死「AI 不增删任何事实」
- ❌ **改写用户原话**——包括中文口语化表达的真实感（CLAUDE.md §3.8 rule 5）
- ❌ **合并 / 拆分段落**——1 中文段 → 1 英文段（严格对应）
- ❌ **"润色"中文为地道英文**——保留中文版写作时的语气，**包括**口语化不完美的地方
- ❌ **添加无锚点 cross-reference**——CLAUDE.md §3.8 rule 6
- ❌ **保留 `lint_allow`**——这是英文版，必须移除
- ❌ **翻译技术名词、代码块、文件路径、commit message**——保持原样（CLAUDE.md §3.9 技术名词规则）

## 工作流（6 步）

### 1. 读 [zh-final] 中文定稿

```bash
# 输入文件
content/posts/<category>/<slug>/index.md
```

**全文通读**，确认：
- 所有事实、数字、引用、链接已就位
- lint_allow 已声明（CLAUDE.md §3.2 中文版必加）
- 章节结构稳定（不再重构，那是阶段 4 的事）

如果事实不全 / 章节仍要重构 → 暂停，回到 zh-final-refactor。

### 2. 逐段字面对应（**核心约束**）

**映射规则**：

| 中文版结构 | 英文版结构 | 一致性要求 |
|---|---|---|
| ## 引言 | ## 引言（译为 Introduction）| 1:1 |
| ## 步骤 1 | ## 步骤 1（译为 Step 1 或保持中文 step）| 1:1 |
| ### A.1 子章节 | ### A.1 子章节 | 1:1 |
| 引用块 > 📎 | 引用块（按需翻译） | 1:1 |
| 代码块 ```bash | 代码块 ```bash | **不翻译** |
| 文件路径 `~/...` | 文件路径 `~/...` | **不翻译** |
| commit message | commit message | **不翻译** |

**段落粒度**：以中文 markdown 的自然段（换行分隔）为最小单位。1 中文段 → 1 英文段。**不合并、不拆分**。

**保留语气**：
- "我曾经遇到的问题" → "The problem I encountered"（保留 first-person）
- "当时我配置时" → "When I was configuring..."（保留口语化时态）
- "卡了半小时" → "stuck for half an hour"（保留时间感）

**不要做**：
- ❌ 改"我曾经遇到的问题"为 "Common issues users encounter"（去人格化）
- ❌ 改"我试了 X，Y 报错"为 "After testing X, Y throws an error"（抹掉主观语气）
- ❌ 合并"我卡了半小时"和"我试了 X"为一个段落

### 3. 地道英语表达（**有限度**）

保留中文原文结构的前提下，让英文读起来自然：

**技术名词 + 极客黑话保留**（CLAUDE.md §3.9）：
- ✅ `sounds like a breeze`、`save your sanity`、`blazing-fast`（A1 已示范）
- ✅ `debugging marathon`（D4 教训里出现过的极客黑话，可保留）
- ✅ `silent killer`、`catastrophic errors`

**翻译习惯**：
- 中文"踩坑" → "trap" / "pitfall"（视上下文）
- 中文"血泪教训" → "hard-won lesson" / "battle scar"（视上下文）
- 中文"前置条件" → "Prerequisites"
- 中文"步骤" → "Step" 或 "Steps"
- 中文"附录" → "Appendix"
- 中文"结论" → "Conclusion"

**不要做**：
- ❌ 套 SEO-spam 模板："ultimate guide"、"you won't believe"、"X tips to master Y"（CLAUDE.md §3.1 tone 写死）
- ❌ 添加中文版没有的过渡句（"Now that we've..."、"Let's dive into..."）
- ❌ 改用户原话的句式结构

### 4. SEO 优化（**仅 front matter**）

**title**：
- 中文 → 英文版本（不是逐字翻译，是 SEO 友好的英文表达）
- ≤ 60 字符（英文按字符数）

**description**：
- 中文 → 英文版本
- ≤ 160 字符
- 含 1-2 个目标关键词

**tags**：
- 中文 tags → 对应英文 tags（如 ["Hugo", "Cloudflare Pages"]，不保留 ["雨果"]）

**cover.alt**：
- 中文 alt → 英文 alt（CLAUDE.md §3.2 写死 alt 文本无 CJK）

**body 不做 SEO 改动**——只翻译。

### 5. 跑验证（**任一失败不 commit**）

```bash
# V1：lint（英文 + TOML）
./scripts/lint-post.sh content/posts/<category>/<slug>/index.md
# 期望 0/0 + 无 CJK warning

# V2：cross-reference 锚点（防止翻译时 §X 引用写错）
# 调用 verify-cross-refs skill

# V3：build
hugo --gc
# 必须 0 errors
```

**V1 关键检查**：确认 `lint_allow = ["cjk-body"]` 已从 front matter 移除（CLAUDE.md §3.2），否则 lint 绕过 CJK 检查。

### 6. commit 边界

- commit message 前缀：**无**（最终版）
- 不自动 push（CLAUDE.md §6）

```bash
git add content/posts/<category>/<slug>/index.md
# 如果 cover 在本 commit 落地（应已在阶段 4 / 5 落地，但可补）
# git add assets/images/<category>/<slug>/cover.jpg

git commit -m "<English title here>

<可选：1-3 行简述本 commit 做了什么>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

## 反模式（CLAUDE.md §3.8 rule 5+6 + D4 教训）

- ❌ **AI 编造 first-person**："I went through this debugging marathon..."（D4 4b8a8ea 教训）
- ❌ **"优化"中文语气**：把用户原话"卡了半小时"改成"extensive debugging session"
- ❌ **合并段落**：把 5 个中文段合并成 2 个英文段（破坏 1:1 对应）
- ❌ **添加中文版没有的内容**："Additionally, ..."、"Furthermore, ..."、"It's worth noting that..."
- ❌ **保留 lint_allow**：忘了删 → 英文版绕过 CJK 检查（违规）
- ❌ **翻译 commit message / 代码注释**——保持英文原样
- ❌ **添加 phantom conclusion**："AdSense 收款可直接复用 PayPal 通道"（D5 教训）

## 硬约束引用

- **CLAUDE.md §3.1 tone**：factual + first-person-conversational，no SEO-spam
- **CLAUDE.md §3.2**：lint_allow 仅中文版用，英文版必删
- **CLAUDE.md §3.8 rule 5**：翻译不增删、不改写
- **CLAUDE.md §3.8 rule 6**：cross-reference 锚点
- **CLAUDE.md §3.9**：技术名词 + 代码块 + 文件路径不翻译
- **CLAUDE.md §6**：HOLD push 等 ack
- **docs/article-writing-workflow.md §7**：翻译阶段硬边界

## 失败兜底

| 场景 | 处理 |
|---|---|
| 中间发现事实不全 | 暂停，回到 zh-final-refactor 补事实 |
| lint_allow 仍在 | 立即移除并重跑 lint |
| 段落数对不上 | 立即修正，1:1 对应是硬约束 |
| verify-cross-refs 失败 | 按报告修正 §X 引用 |
| hugo --gc 失败 | 检查 shortcode / ref 路径 / TOML 语法 |
| 用户说"翻译得不自然" | 保留中文原话语气是硬约束——解释给用户 §3.8 rule 5 |