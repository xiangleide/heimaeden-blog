---
name: new-draft-zh
description: Generates Chinese first-draft (初稿) for HeimaEden blog posts with mandatory front matter (lint_allow), alliance placeholders, screenshot annotations, and §0 community search task. Strict step-by-step tone, no first-person. Use when user says "写一篇新文章" / "起个草稿" / "出初稿" / TCM stage 2 trigger.
---

# new-draft-zh

HeimaEden 中文初稿生成器（TCM 阶段 2）。**只生成结构 + 标注位 + 占位**，不写正文事实。事实由用户实操阶段（阶段 3）填入。

## 触发场景

- 用户说："写一篇新文章" / "起个草稿" / "出初稿"
- TCM 阶段 1（topic-pick）完成后自动触发
- topic-pool.md 状态为「推荐中」时触发

## 不要做的事

- ❌ **不写正文事实**——初稿只列骨架，事实由用户实操阶段填入
- ❌ **不写 first-person**——CLAUDE.md §3.8 rule 1 写死「AI 不写 first-person 经验」。所有句子用 step-by-step 操作清单语气
- ❌ **不写"[zh-final]"或英文版**——那是阶段 4 / 阶段 7
- ❌ **不跳 §0 搜索任务**——CLAUDE.md §3.8 + article-writing-workflow §1.4 强制必做
- ❌ **不在文件路径里用中文**——CLAUDE.md §3.6 kebab-case

## 工作流（7 步）

### 1. 确认选题 + 路径

输入：
- 选题（topic-pick skill 推荐 or 用户提供）
- 目标分类（如 `static-site`、`ai-agent`、`remote-payment`）

输出：
- 文件路径：`content/posts/<category>/<slug>/index.md`（Page Bundle 模式）
  - 或老格式：`content/posts/<category>/<slug>.md`（兼容历史 post）
- `<category>` = front matter `categories[0]` 的 lowercase-hyphenated 形式
- `<slug>` = kebab-case，无中文，无大写，无 curly apostrophes

### 2. front matter（**lint_allow 必须**）

```toml
+++
title = "<中文标题>"
description = "<中文 SEO 描述，≤ 160 字符>"
date = <PAST_ISO_TIMESTAMP>      # 必须是过去时间（CLAUDE.md §3.1）
draft = false
tags = ["<tag1>", "<tag2>"]
categories = ["<Category>"]

showToc = true
TocOpen = true

[cover]
    image = "<category>/<slug>/cover.jpg"   # 占位，等 cover prompt 阶段补真实文件
    alt = "<alt 文本占位>"

# Draft exemption per docs/article-writing-workflow.md §附 G (D6 新增)
# 原因：本文件是 [draft] 状态的中文初稿，TCM 阶段 7 英文版 commit 前必须移除此行
lint_allow = ["cjk-body"]
+++
```

**lint_allow**（CLAUDE.md §3.2）——中文初稿用，英文版 commit 前必删。

### 3. 章节骨架（**只结构，无正文**）

#### 3.0 文章类型判定（先选 prompt，再套骨架）

**反 AI-farm 硬规矩**：每篇文章必须先判定类型，从 `docs/writing-prompts.md` 5 种 prompt（A 纯排障 / B 方案对比 / C 踩坑叙事 / D 原理深挖 / E 方法论 retrospective）中选 1 种。**不允许 5 篇文章同结构**（触发 Scaled Content 识别信号）。详见 `docs/writing-prompts.md` §一速查表。

判定时机：在套章节骨架模板之前。判定依据 = 文章主要服务哪种读者需求。

按 article-writing-workflow §1.1 + §5.2 推荐结构 + `docs/writing-prompts.md`（5 种 prompt 库）：

```markdown
## 引言：<问题定义，100 词>

<留空，等用户实操后填>

---

## 前置条件

- <环境 / 工具 / 账号要求 1>
- <环境 / 工具 / 账号要求 2>
- <环境 / 工具 / 账号要求 3>

---

## 步骤 0：踩坑搜索（实操前必做）

**任务**：动手前先搜一轮社区踩坑，为实操做心理预期

**搜索关键词模板**：
- `{技术} not working` / `{技术} trap` / `{技术} reddit`
- `{技术} github issue` / `{技术} stackoverflow`
- `{技术} + {关联关键词}`

**来源白名单**：
- Reddit（r/Hugo, r/CloudFlare, r/webdev, r/China_Developer）
- GitHub Issues（主题仓库 + 工具仓库）
- Cloudflare Community
- Hugo Discourse

**输出**：3-5 条最常见的踩坑 + 来源链接

**为什么**：
1. 实操时对可能的坑有心理预期
2. 实操顺利时 → 这些坑进入"已知问题附录"
3. 实操遇到坑时 → 已有搜索上下文，节省调试时间

---

## 步骤 1：<动作 1>

<留空，等用户实操后填>

📸 **截图标注位**（步骤 1）：
- **位置**：<具体页面 / 设置项 / 区域>
- **脱敏要求**：<打码邮箱 / 隐藏 4 字段 / 高亮目标区域>
- **文件命名**：`step-1-<描述>.png`
- **放哪**：Page Bundle 同目录（如 `content/posts/<category>/<slug>/step-1.png`）

> 📎 **【联盟-占位 platform】** 待第二版确定
> 推荐用语模板（按 README §五-3 双向互惠）：
> "I use {platform} for my own {use case}. If you sign up via my link,
> you get {benefit}, and I earn a small commission at no extra cost to you."
> 链接变量：`{{ ref "data/affiliates.toml#platform" }}`（Phase 5 启用时填真值）

---

## 步骤 N：<最后一步>

<留空，等用户实操后填>

📸 **截图标注位**（步骤 N）：
- **位置**：...
- **脱敏要求**：...
- **文件命名**：`step-N-<描述>.png`

---

## 已知问题与社区报告

<基于 §0 搜索结果填充，等用户实操后决定走策略 A 还是 B>

---

## 结论

<留空，等用户实操后填>

---

## 附录 A：<可选附录>

<留空>
```

### 4. §0 搜索任务（已嵌入骨架）

§0 已在骨架内——这是 article-writing-workflow §1.4 的硬约束。AI 写出后由用户在实操前完成。

### 5. 联盟占位（适合的文章）

按 article-writing-workflow §1.3：
- ✅ 选型对比（如 VPS 横评）
- ✅ 个人使用体验（如 "Why I switched to Hetzner"）
- ❌ 故障排错（不道德）
- ❌ 官方 API 文档翻译（不专业）

骨架里已在每个适合的步骤嵌入 `📎 联盟-占位 platform` 标记。

### 6. 截图标注位（每步）

按 article-writing-workflow §1.2 格式：

```markdown
📸 **截图标注位**（步骤 N）：
- **位置**：<具体页面 / 设置项 / 区域>
- **脱敏要求**：<打码邮箱 / 隐藏 4 字段 / 高亮目标区域>
- **文件命名**：`step-N-<描述>.png`（kebab-case + 数字前缀）
- **放哪**：Page Bundle 同目录
```

### 7. commit 边界

- commit message 前缀：**[draft] <topic>**
- 不自动 push（CLAUDE.md §6 HOLD 规则）
- 推荐 commit 内容：仅 1 个 .md（Page Bundle 的 index.md）

```bash
git add content/posts/<category>/<slug>/index.md
git commit -m "[draft] <topic> — 中文初稿骨架 + lint_allow"
```

## 硬约束引用

- **CLAUDE.md §3.1**：front matter 必填字段、date 必须过去
- **CLAUDE.md §3.2**：lint_allow token 用法
- **CLAUDE.md §3.6**：kebab-case 文件名
- **CLAUDE.md §3.8 rule 1**：初稿不写 first-person
- **CLAUDE.md §3.8 rule 4**：联盟占位初稿阶段就标
- **docs/article-writing-workflow.md §1.1-1.5**：初稿完整规范
- **docs/article-writing-workflow.md §附 D**：commit 边界总览

## 失败兜底

| 场景 | 处理 |
|---|---|
| 用户直接要 first-person 风格 | 拒绝——CLAUDE.md §3.8 rule 1 写死 |
| 没有 topic 输入 | 引导回 topic-pick skill（TCM 阶段 1） |
| 选题不适合联盟但要求加 | 拒绝——故障排错类不联盟（不道德） |
| lint_allow 忘记加 | 立即报错——CLAUDE.md §3.2 lint 会卡 |
| 用户跳过 §0 搜索直接要正文 | 拒绝——§1.4 写死 §0 必做 |