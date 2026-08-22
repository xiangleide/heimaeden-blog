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

阶段速览：
1. **选题**（AI 推荐 + 用户确认）→ 3 个候选 + 各自理由
2. **初稿**（AI 写中文 step-by-step）→ 标注位 + §0 搜索任务
3. **实操**（用户执行）→ 真实命令 + 错误日志 + 截图
4. **反馈**（用户整理 markdown）→ 卡住点 + 报错 + 补充事实
5. **截图**（用户提供）→ 按标注位补真实截图 + redact
6. **第二版**（AI 整合中文定稿）→ 合并初稿 + 实操反馈 + 截图
7. **翻译**（AI 字面对应）→ 地道英语 + SEO 结构
8. **提交**（AI commit + hold push）→ 用户 ack 后 push

📸 **截图标注位**（§1）：
- **位置**：6 阶段流程图（建议用 Mermaid / draw.io 画）
- **脱敏要求**：无
- **文件命名**：`pipeline-overview.png`
- **放哪**：Page Bundle 同目录

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

<留空，描述 D4 引入 AI 的踩坑>

关键事实锚点：
- commit `4b8a8ea`：AI 代笔 1787 词英文 troubleshooting 长文
- 包含虚构 first-person：「I went through this debugging marathon」/「Trap 1: build cache bleed — after that one-line change, I have not seen a leak in six weeks」
- commit `bc9a369`：用户撤销
- 教训 → `docs/article-writing-workflow.md` §附 E「D4 教训」

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

<留空，明确 AI 协助 vs 人工把控的边界>

预期内容（待用户实操确认）：
- AI 协助产出：初稿结构 / 翻译 / cross-ref 验证 / mock-reader 报告结构化 / 文档归档
- 人工把控产出：所有 first-person 实操经验 / 截图选择 / 截图脱敏 / commit push ack
- 决策权归属：选题（用户拍板）/ commit push（用户 ack）/ Y1/Y2 延后（用户拍板）

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