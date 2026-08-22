+++
title = "How I Built a Solo Tech Blog Pipeline with Claude Code Skills"
description = "Solo developer's 11-day log of building a Claude Code Skills editorial pipeline — 6 hours to 2 hours per post, 4 iterations, what worked."
date = 2026-08-22T01:30:00Z
draft = false
tags = ["Claude Code", "editorial pipeline", "indie blogger", "content automation", "workflow"]
categories = ["AI-Agent"]

showToc = true
TocOpen = true

[cover]
    image = "ai-agent/claude-code-editorial-pipeline/cover.jpg"
    alt = "Editorial pipeline workflow diagram showing six stages from topic-pick to publish"

# Draft exemption per CLAUDE.md §3.2 (lint_allow token)
# 移除时机：TCM 阶段 7 英文版 commit 前必须删除此行（CLAUDE.md §3.2 硬约束）
lint_allow = ["cjk-body"]
+++

## 引言（150 词）：11 天、6 次主迭代、从 6 小时到 2 小时/篇

<留空，等用户实操后填>

> **本节事实基线**（已锚定，无需重写）：
> - 项目启动日 = 2026-08-11 (D0)
> - 当前日期 = 2026-08-22 (D11)
> - 实际发文数 = 3 篇长文（A1 / A2 / A3）
> - 演进史来源 = `README.md §6` + `CLAUDE.md §3.8` 教训条目 + `docs/think-x1-claude-code-pipeline.md`

---

## §1 现状：当前 6 阶段 TCM SOP（每阶段 50 字简述）

<留空，每阶段 50 字简述>

阶段速览（对齐 Content-Agent-TCM.md 的 6 阶段）：
1. **阶段一：选题拦截与商业埋点确认**（AI 联网搜索 + 推荐 3 候选 → 用户选 1）
2. **阶段二：本地文件创建与中文初稿注入**（AI 全自动写盘 .md + draft 提交 + hold push）
3. **阶段三：真机实操与 Agent 实时 Debug**（用户跑命令 + Agent 结对修本地配置）
4. **阶段四：第二版中文美化**（AI 整合踩坑经验 + 实操反馈 + 截图）
5. **阶段五：英文翻译与合规清洗**（AI 字面对应 + 地道英语 + SEO 结构）
6. **阶段六：本地编译与人工最终审核**（hugo --gc + 浏览器视觉 + git push）

![Six-stage editorial pipeline (draw.io). Stage 1 Topic Pick + Money Hook, AI web search recommends 3 candidates, user picks 1. Stage 2 Local File + Chinese Draft, AI writes .md, draft commit, hold push. Stage 3 Hands-on Operation + Agent Debug, user runs commands, agent pairs to fix local config. Stage 4 Second-pass Chinese Polish, AI integrates debugging + feedback + screenshots, zh-final commit. Stage 5 English Translation + Cleanup, AI word-for-word + idiomatic English + SEO, remove lint_allow. Stage 6 Local Build + Manual Review, hugo --gc, browser visual, git push on user ack. Loops from Stage 6 back to Stage 1 labeled 'commit'.](/images/ai-agent/claude-code-editorial-pipeline/pipeline-overview.png)

---

## §2 演进史（核心章节）：4 个迭代节点

### §2.1 D0-D3：纯人工时代，Stack Overflow 排错

<留空，描述 D0-D3 阶段的人工时代状态>

关键事实锚点：
- D0 = 2026-08-11 域名抢注
- D3 = 2026-08-13 Hugo + Cloudflare Pages 流水线 + 首篇长文上线
- 当时每篇文章耗时 = ~6 小时（查文档 + 试错 + 写 + 截图 + 翻译）

📸 **截图标注位**（§2.1 D0-D3）：
- **位置**：Hugo Cloudflare Pages 后台截图（D3.5 之前的版本）
- **脱敏要求**：移除 dev-internal 标识
- **文件命名**：`d3-manual-era-hugo-cf.png`
- **放哪**：Page Bundle 同目录

### §2.2 D4：第一次引入 AI + commit bc9a369 撤销事件

#### 2.2.1 起因

D4 上午，我决定用 AI 代笔 A 系列第一篇英文长文（1787 词 troubleshooting）。任务交接给 AI 时，我给的不是「我的真实实操笔记」，而是**主题关键词 + 期望字数 + 一句文案框架**。

AI 输出一篇 1787 词英文 troubleshooting 长文，commit `4b8a8ea`（2026-08-15 22:00:49 +0800）：

```
D4: B1 long-form #1 — Cloudflare Pages Preview Branches guide
... 10 H2 sections ... 3 trap write-ups sourced from real config drift I hit ...
```

注意 commit message 末尾的 "I hit" 字样——**AI 已经污染了对自己工作的描述**，这是 self-contamination 现象，不只是正文。

<留空 first-person 实操段：你当时把任务交给 AI 的真实考量是什么？比如「我以为单篇代笔不算 production output」「我默认 AI 会比照我之前三篇的 style」「我当天赶时间想冲 K 个数」等 — 用你原话，不超过 100 字>

#### 2.2.2 published 后自检触发

晚间文章已经上线 Cloudflare Pages。我开始重读自己刚发的文章...

<留空 first-person 实操段：你重读时哪一句 first-person 让你意识到不对劲？具体哪一句你查了 git history / Hugo 历史 / 自己 memory 才发现不存在？— 用你原话，不超过 150 字>

#### 2.2.3 撤销

我立刻执行 `git revert 4b8a8ea` → commit `bc9a369`（2026-08-15 22:03:43 +0800）：

```
Revert "D4: B1 long-form #1 — Cloudflare Pages Preview Branches guide"
This reverts commit 4b8a8ea9858a55637c9f0388badfcc832fa4b40b.
```

<留空 first-person 实操段：你 revert 时的心情（警觉？失望？理性的"下次怎么防"？）— 用你原话，不超过 80 字>

#### 2.2.4 当晚不补 SOP，冷处理一夜

当晚我没动 `CLAUDE.md` — 先退出 Claude 会话冷处理一夜。

<留空 first-person 实操段：你当时为何选择「先睡觉明天再补」而不是「当场补 rule 1」？— 用你原话，不超过 100 字>

#### 2.2.5 D5 下午：系统化 6 条 rule

D5 2026-08-16（次日）下午，我系统化 6 条 rule 进 `CLAUDE.md §3.8`：以 D4 撤销事件为 lessons-learned 锚点，逐条梳「AI 写 first-person / 选题 context / 截图真实 / affiliate 初稿标 / 翻译字面对应 / cross-ref 锚点」6 条铁律。同日补 `docs/article-writing-workflow.md §附 E`「D4 教训」作为详细案例。

#### 2.2.6 自检三问（呼应 §5.4）

D4 事件能及时 revert，是因为三个客观条件同时满足：

1. ✅ 我代笔时转交的是「题材 + 文案框架」，**不是真实 first-person 经验** —— 我没给素材，所以 AI 必须编造（这是我能 audit 出错原因的前提）
2. ✅ 我能在 git history 上 audit 4b8a8ea 是否真有来源
3. ✅ AI 输出是 intermediate commit，可 revert 撤销 —— D4 的"侥幸"全在于这点

如果任一条件不满足（比如 AI 直接 push 到 main，比如我在私有仓库），revert 时间会大幅拉长。**D4 教训的核心**：把 AI 输出圈在 intermediate commit 内、让我拥有 revert 权限，是这条人工边界成立的物理前提。

📸 **截图标注位**（§2.2 D4）：
- **位置**：bc9a369 commit diff（git log -p）
- **脱敏要求**：无 PII
- **文件命名**：`d4-revert-commit-diff.png`
- **放哪**：Page Bundle 同目录

### §2.3 D5：双篇并行 + lint_allow 临时方案

<留空，描述 D5 三件套 commit>

关键事实锚点：
- `800d460` D5 infra: cover.html + render-link.html + img responsive CSS
- `a5bb839` D5 content: A2/A3 long-form polish
- `b751bdb` Translate A2 + A3 to English (final)
- 11 处 HTML 注释内 CJK 保留（D5 决策，待 lint-post.sh 后续改进）
- 阶段性结果 = 双篇英文版上线，原始中文版入 git 历史

📸 **截图标注位**（§2.3 D5）：
- **位置**：3 commit 序列的 git log graph
- **脱敏要求**：无
- **文件命名**：`d5-three-commit-graph.png`
- **放哪**：Page Bundle 同目录

### §2.4 D10：mock-reader-feedback skill 引入（commit 7d2cdee）

<留空，描述 D10 mock-reader 实战>

关键事实锚点：
- `7d2cdee` mock-reader-feedback skill MVP + GSC wiring
- `ee25372` archive 4 mock-reader reports（P1/P3/P5 + P1-vs-P3）
- `8dedff0` add 3 P5-driven backlog entries (S10-S12)
- 4 份报告归档：`docs/feedback/claude-code-cli-setup-indie-blog-{P1,P3,P5,P1-vs-P3}.md`
- 关键发现：定位漂移 / dev-internal marker / 首屏错位

📸 **截图标注位**（§2.4 D10）：
- **位置**：4 份 mock-reader 报告文件列表（`ls docs/feedback/`）
- **脱敏要求**：无
- **文件命名**：`d10-mock-reader-reports.png`
- **放哪**：Page Bundle 同目录

---

## §3 当前已知问题：3-5 个痛点

<留空，列出当前 SOP 未解决的痛点>

预期痛点方向（待用户实操确认）：
- 翻译 commit 无前缀 → git log 难以快速识别
- commit message 长度爆炸 → 多文件改动时 body 过长
- lint_allow 历史 11 errors 仍未根治 → lint-post.sh 未豁免 HTML 注释内 CJK
- mock-reader P3 一致反馈「标题农场味」→ 标题措辞需要持续打磨
- Y1/Y2 系列单篇延后决策 → 集群首发速度受拖累

---

## §4 未来 6 个月方向：2-3 个待调整

<留空，列出未来调整方向>

预期方向（待用户实操确认）：
- CLAUDE.md §3 / docs SOP 同步：D5 新增硬约束（cover.html / render-link / 翻译无前缀 / dev server baseURL）+ D10 mock-reader SOP 入档
- lint-post.sh 增强：豁免 HTML 注释内 CJK / 增加 cross-ref 验证
- 主题迁移：PaperMod → Hugo Modules（CLAUDE.md §6 已禁用改 `themes/PaperMod/`）

---

## §5 方法论边界：AI 做什么 / 我做什么

一句话口诀：**AI 是助理，不是替身**。

凡是带 first-person 实操经验、对外可见身份信息、最终发布决策的内容，由我把关；凡是「过程性、可 revert、可校验」的中间产物，由 AI 起草。这是 D4 撤销事件之后沉淀下来的 ratchet，不可降级。

### 5.1 人工把控（4 项，硬约束）

1. **first-person 实操经验**：所有「我...」句子必须本人写。AI 起草可生成 step-by-step 框架，但不替我杜撰主观经历。（依据：D4 撤销事件，详见 §2.2 + CLAUDE.md §3.8 rule 1）
2. **截图选择**：哪张截图进正文由本人挑。AI 可以建议「这里需要图」，具体哪一帧由我看实图决定。
3. **截图脱敏**：含账户 / 邮箱 / ID / 卡尾的截图，必须经 `./scripts/redact-image.sh` 处理。本人是脱敏决策者，AI 只识别候选坐标（CLAUDE.md §3.3.4）并不替你拍板。
4. **commit push ack**：任何 `git push` 都等本人 `git log -1 --stat` 亲自看完再 ack。AI 永远 hold push（CLAUDE.md §6）。

### 5.2 决策权归属（3 项拍板事项）

| 决策 | 谁拍板 | 原因 |
|---|---|---|
| 选题（topic-pool 推荐哪个） | 用户 | narrative 终点是人，不是流量 |
| commit push ack | 用户（必 ack） | 公开 CDN 不可 recall |
| Y1/Y2 标题延后 | 用户 | 集群首发节奏服从 X1 完成状态 |

### 5.3 AI 协助产出（默认 OK，但需审计）

- 初稿结构（step-by-step 框架 + 标注位 + §0 搜索任务）
- 英文翻译（字面对应，不增删事实 — CLAUDE.md §3.8 rule 5）
- cross-reference 锚点验证（避免 phantom conclusion — CLAUDE.md §3.8 rule 6）
- mock-reader 报告结构化（mock-reader 不是真读者，可以 AI 跑，但是 audit walk）
- 文档归档（think-*.md / topic-pool.md 等结构化记忆）

### 5.4 灰色地带的回归测试

遇 AI 输出不确定该归 5.1 还是 5.3 时，问三个问题：

1. 这条内容出错，**我愿不愿公开负责？**
2. 这条内容能不能通过**第三方读者**（非 mock-reader）反向验证？
3. AI 输出能不能**无损回退**？

任一答否 → 落 5.1 人工把控。本人随时可一行 chat 暂停全流程，AI 不会绕过本人 commit push。这一条没有"对话结束自动执行"的免 ack 例外。

---

## §6 结语 + 系列预告（指向 Y1 / Y2）

<留空，预告后续系列文章>

预期内容：
- X1 = 编辑流水线框架（本文）
- Y1 候选：mock-reader-feedback deep dive（具体 skill 实现）
- Y2 候选：pre-commit gates / redact-image PII 流程
- Y1/Y2 标题延后决策（待 X1 完成）

---

## §附 A：步骤 0 踩坑搜索（实操前必做）

**任务**：动手前先搜一轮社区踩坑，为实操做心理预期

**搜索关键词模板**：
- `Claude Code editorial workflow` / `Claude Code content pipeline` / `Claude Code blog automation`
- `Claude Code skills` / `Claude Code custom commands` / `Claude Code MCP server`
- `Claude Code + Hugo` / `Claude Code + markdown workflow`
- `solo blogger AI workflow` / `indie hacker AI pipeline`

**来源白名单**：
- Reddit（r/ClaudeAI, r/IndieHackers, r/sideproject, r/China_Developer）
- GitHub Issues（anthropics/claude-code + cline + continue + aider）
- Hacker News（搜「Claude Code workflow」/「AI content pipeline」）
- Anthropic 官方文档（docs.claude.com）

**输出**：3-5 条最常见的踩坑 + 来源链接

**为什么**：
1. 实操时对可能的坑有心理预期
2. 实操顺利时 → 这些坑进入「已知问题附录」
3. 实操遇到坑时 → 已有搜索上下文，节省调试时间