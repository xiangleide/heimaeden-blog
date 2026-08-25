---
name: zh-final-refactor
description: Integrates [draft] + 用户实操反馈 + 真实截图 into [zh-final] Chinese final draft, with optional chapter refactoring. Strict classification per article-writing-workflow.md §5.1 — first-person only when user has hands-on fact basis. Use when user says "[zh-final] 一下" / "中文定稿" / "定稿" / TCM stage 4 trigger.
---

# zh-final-refactor

HeimaEden 中文定稿生成器（TCM 阶段 4）。**核心职责**：把初稿 + 用户实操反馈 + 真实截图三件套合并成第二版中文定稿，含可选章节重构。

## 触发场景

- 用户说："[zh-final] 一下" / "中文定稿" / "定稿" / "出第二版"
- TCM 阶段 3（用户实操 + 反馈 + 截图）完成后自动触发
- 用户口头反馈："这步不通" / "报错是 X" / "应该这样改"

## 不要做的事

- ❌ **AI 编造 first-person 经验**——CLAUDE.md §3.8 rule 5 + D4 教训（4b8a8ea 越界 commit）
- ❌ **"优化"用户原话**——保留中文口语化真实感（"我曾经遇到..." 这种是用户原话，不是 AI 该润色的）
- ❌ **添加无锚点 cross-reference**——CLAUDE.md §3.8 rule 6（"AdSense 收款可直接复用 PayPal 通道" 这种凭空结论）
- ❌ **删 `lint_allow = ["cjk-body"]`**——仍是中文版，保留 token
- ❌ **删/改 `prompt_type`**——`docs/writing-prompts.md` §七强制字段（结构多样性追踪），定稿必须保留；若初稿缺失，定稿阶段必须补上（判定算法见 `new-draft-zh/SKILL.md` §3.0）
- ❌ **跳到英文翻译**——那是阶段 7

## 工作流（6 步）

### 1. 收集三件套

```bash
# A. 初稿路径
content/posts/<category>/<slug>/index.md

# B. 用户实操反馈 markdown
# 通常用户在对话里提供，或写到 ~/Downloads/<topic>-feedback.md
# 必含：哪些步骤顺利、哪些卡住、报错 / 时间戳 / 真实截图路径

# C. 真实截图（已脱敏并移到 assets/images/）
# 由 redact-image skill 处理
assets/images/<category>/<slug>/step-*.png
```

如果三件套缺任何一件 → 暂停，让用户补齐。

### 2. 措辞分类（**关键**：按 article-writing-workflow §5.1）

| 内容来源 | 措辞模板 | 资格 |
|---|---|---|
| 用户 first-hand | "我配置时遇到..." / "我试了 X，Y 报错" | ✅ **仅当**有用户实操事实支撑 |
| 他人 reported 坑 | "Per Cloudflare Community #1234..." / "Users on Reddit report..." | ✅ 来源透明 |
| 官方文档引用 | "Per Hugo documentation..." / "According to Cloudflare docs..." | ✅ 来源透明 |
| §0 搜索结果 | "搜索发现 GitHub Issue #N 有类似报告..." | ✅ 来源透明 |
| AI 编造 | "I learned this the hard way..." / "After 6 weeks of debugging..." | ❌ **严禁** |

**判定规则**：
- 含"我"且能映射到用户反馈 markdown 里具体一步 → 用户 first-hand → ✅
- 含"我"但用户反馈里找不到 → AI 编造 → ❌ 改客观描述
- 含"Per X..." → 来源透明 → ✅
- 结论性陈述（"X 工作流可无缝切换到 Y"）无锚点 → phantom conclusion → 改占位语

### 3. 合并到第二版骨架

按 article-writing-workflow §5.2 推荐结构整合：

1. **引言**（100 词）：本文解决什么问题（基于 §0 搜索 + 用户实操）
2. **前置条件**：环境 / 工具 / 账号要求
3. **步骤 1-N**：主线操作（合并初稿步骤 + 实操反馈 + 真实截图）
4. **已知问题与社区报告**：基于 §0 搜索结果（策略 A 或 B 取决于搜索深度）
5. **结论**

骨架套用但内容来自三件套——**不发明新事实**。

### 4. 章节重构（可选，按用户反馈）

**触发条件**：用户说"重构章节" / "步骤顺序乱了" / "前置条件应该放到主线"。

重构模式：
- 合并相似步骤（如 §步骤 3 + §步骤 4 → §步骤 3：xxx（含两子步骤））
- 拆分过长步骤（> 5 个子步骤 → 拆为 §步骤 3 + §步骤 4）
- 调整层级（主线 vs 附录）
- 删冗余（前置条件如果已在引言提过 → 删）
- 加决策树（如果用户实操遇到分支 → 加 ⚠️ 决策点）

**重构后必跑 verify-cross-refs**——重排后 §X 引用可能失效。

### 5. 更新 front matter

```toml
+++
title = "<优化后的标题，保留中文>"   # 可基于 SEO 调整
description = "<优化后的 SEO 描述，≤ 160 字符>"
date = <原 date 或更新>               # 仍在过去
draft = false
tags = ["<优化>"]
categories = ["<Category>"]

showToc = true
TocOpen = true

[cover]
    image = "<category>/<slug>/cover.jpg"   # 此时 cover 应已落地
    alt = "<cover alt 文本>"

# Draft exemption per docs/article-writing-workflow.md §附 G (D6 新增)
# 原因：本文件仍是中文版（[zh-final]），阶段 7 英文版 commit 前必须移除
lint_allow = ["cjk-body"]
+++
```

**lint_allow**（CLAUDE.md §3.2）——[zh-final] 仍是中文，必保留。

### 6. 跑验证（**任一失败不 commit**）

```bash
# V1：lint（中文 + TOML + front matter）
./scripts/lint-post.sh content/posts/<category>/<slug>/index.md

# V2：cross-reference 锚点（CLAUDE.md §3.8 rule 6）
# 调用 verify-cross-refs skill

# V3：build（CLAUDE.md §5 pre-action #3）
hugo --gc
# 必须 0 errors
```

### 7. commit 边界

- commit message 前缀：**[zh-final] <topic>**
- 不自动 push（CLAUDE.md §6）
- 推荐 commit 内容：1 个 .md + 截图资产（如果有新增）

```bash
git add content/posts/<category>/<slug>/index.md
git add assets/images/<category>/<slug>/<新增截图>.png  # 如果有
git commit -m "[zh-final] <topic> — 中文定稿 + 实操反馈整合"
```

## 反模式（CLAUDE.md §3.8 + article-writing-workflow §5）

- ❌ **AI 编造 first-person**："我 went through debugging marathon..." 而无用户实操
- ❌ **润色用户原话**：用户说"我卡在 X 那步半小时" → 改"我花了大量时间调试 X"（改写）
- ❌ **添加 cross-reference 凭空结论**："AdSense 收款可直接复用 PayPal 通道"（D5 教训）
- ❌ **删 lint_allow**：忘了删 → lint 会卡；提前删 → lint 会扫到 CJK
- ❌ **章节重构后没跑 verify-cross-refs**：§步骤 9 引用失效

## 硬约束引用

- **CLAUDE.md §3.8 rule 1**：初稿不写 first-person（这里是定稿，可以写，但要用户实操支撑）
- **CLAUDE.md §3.8 rule 5**：不改写用户原话
- **CLAUDE.md §3.8 rule 6**：cross-reference 锚点
- **CLAUDE.md §3.2**：lint_allow 用法
- **docs/article-writing-workflow.md §5.1**：措辞分类表
- **docs/article-writing-workflow.md §5.2**：第二版结构
- **docs/article-writing-workflow.md §附 D**：commit 边界总览

## 失败兜底

| 场景 | 处理 |
|---|---|
| 用户反馈 markdown 缺失 | 暂停，要求用户补反馈（不能凭空编实操） |
| 真实截图未脱敏 | 暂停，要求先跑 redact-image skill |
| 出现"我 learned this the hard way"且无锚点 | 立即改客观描述或加占位语 |
| 章节重构后 §X 引用失效 | 跑 verify-cross-refs，按报告修正 |
| lint_allow 忘记加 | 立即报错，提示 CLAUDE.md §3.2 |