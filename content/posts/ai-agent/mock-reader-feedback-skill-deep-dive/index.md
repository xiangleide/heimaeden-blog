+++
title = "How I Built a 5-Persona Mock Reader Skill (with Claude Code)"
description = "5-persona mock reader feedback skill for Claude Code. 7-step workflow + YAML schema + 6 anti-patterns. Real hugo-pitfalls + TCO math."
date = 2026-08-30T00:00:00Z
draft = true
tags = ["Claude Code", "AI Agent", "Editorial Workflow", "LLM-as-Judge", "Persona Prompt", "Claude Code Pipeline"]
categories = ["AI-Agent"]

# Hugo series (per CLAUDE.md §3.4 + PaperMod taxonomy convention) — cluster with A2 claude-code-editorial-pipeline.
# Series landing: content/posts/ai-agent/_index.md + ai-agent category page.
series = ["AI Agent"]

showToc = true
TocOpen = true

[cover]
    # D21 M2 阶段: AI-generated cover (Variant V1 5-persona 镜头) — 替换阶段 4 占位 cover.jpg。
    # Path format: resources path = images/<category>/<article-slug>/<file>, 前缀 images/ + 去掉 assets/ (PaperMod cover.html line 22 absURL fallback).
    image = "images/ai-agent/mock-reader-feedback-skill-deep-dive/cover.png"
    alt = "Flat-vector technical illustration: a central green index.md document surrounded by 5 persona-colored viewer lenses (P1 red direct_technical, P2 orange editor-grade, P3 purple one-liner, P4 gray silent, P5 gold comparison-matrix). Top-left shows a faded ghost smiley with 5 stars crossed out in red, labeled LLM default positive bias. A bright green arrow loops from the ghost back to the central document, labeled mock-reader-feedback/v1."

# E 档 (方法论 retrospective) — per docs/writing-prompts.md §六：commit hash + 撤销事件 + 决策点。
# 内容含 hugo-pitfalls / claude-code-cli-setup / claude-code-editorial-pipeline 12 份反馈 commit 锚点，
# 反 pattern 对应 §0 5 条社区坑 + 1 条 baseline 对照，5 决策点 vs mock-reader 选择。
prompt_type = "E"

# Draft exemption per CLAUDE.md §3.2 + docs/article-writing-workflow.md §1 (D6 新增 lint_allow 用法)
# 原因：本文件是 [draft] 状态的中文初稿，TCM 阶段 7 英文版 commit 前必须移除此行
lint_allow = ["cjk-body"]
+++

> **TL;DR**：mock-reader-feedback skill 是一个 Claude Code 子命令，**用 5 个预设 persona（P1-P5）跑虚拟读者试读**，输出 YAML 反馈报告到 `docs/feedback/<article>-<persona>.md`。本文拆解它：5 个 persona 如何构造、7 步工作流怎么跑、YAML schema 怎么严格遵守、以及 5 条已踩的反 pattern。
>
> **作者注**：本 skill 是我 2026-08 月对 3 篇文章（hugo-cloudflare-pages-pitfalls / claude-code-cli-setup-indie-blog / [claude-code-editorial-pipeline]({{< ref "posts/ai-agent/claude-code-editorial-pipeline" >}})）跑完 12 份反馈报告后沉淀的。所有引用的报告、脚本、persona 文件都在仓库里可查。

---

## FAQ（先回答常见问题）

**Q: mock-reader-feedback 是什么？**
A: 一个 Claude Code 子命令 skill，用 5 个预设 persona（P1-P5）跑虚拟读者试读，输出 YAML 反馈报告到 `docs/feedback/<slug>-P{id}.md`。

**Q: 和直接问 LLM 审稿有什么区别？**
A: 直接问 LLM（无 persona prompt）= 默认 positive bias（5⭐ 全赞，per §附录0 第 2 条社区坑）。skill 强制显式 `feedback_style` + `rating < 5` 硬约束，把 LLM 从「通用正面反馈」拉回具体段落级 critique。

**Q: 什么时候该跑？**
A: [zh-final] / [en-final] 阶段后，commit-with-prefix 之前。默认 P5（最挑剔）+ P1（验证可实操）；翻译后加 P3（验证海外读者接受度）。

---

## 步骤 0：踩坑搜索（实操前必做）

**任务**：动手前先扫一遍社区对 LLM-as-judge / persona prompt 的常见批评，避免重复踩坑。

**5 条社区坑（按相关度）**：

1. **LLM surface-level 偏差**：[PersonaEval arXiv 2508.18076](https://arxiv.org/html/2508.18076v2) — Gemini-2.5-pro 仅 68.8% 准确率判定 persona 角色扮演质量（人类 90.8%），LLM 关注表面语言而非会话意图。
2. **5⭐ 全赞是 LLM 默认行为**：[Field Guide to AI](https://fieldguidetoai.com/scam-watch/fake-ai-reviews) — ChatGPT 评论比人类**系统性更正面**，必须显式 prompt 禁止 5⭐。
3. **Likert 天花板效应**：[Moonlight ceiling](https://www.themoonlight.io/fr/review/the-signal-is-the-ceiling-measurement-limits-of-llm-predicted-experience-ratings-from-open-ended-survey-text) — 所有模型**系统性 under-predict** 评分（positive-only 86% agreement vs negative-only 44%）。
4. **persona 刻板印象**：[Irish Examiner](https://irishexaminer.com/opinion/commentanalysis/arid-41184352.html) — "business traveller" 等 persona prompt 产出 stereotype。
5. **AI 缺 lizard brain**：[softwaredoug.com](https://softwaredoug.com/blog/2025/11/02/llm-judges-arent-the-shortcut-you-think) — LLM 缺人类 engagement 直觉，最后 10-20% 的分歧包含最有意义的 edge cases。

**为什么先搜这 5 条**：mock-reader-feedback 本质就是 LLM-as-judge。不知道偏差，反馈报告就是噪声。

## 引言

**问题**：TCM SOP 阶段 4（[zh-final]）写到「用户确认 → 触发翻译阶段」。但「用户确认」如果只是 AI 自查，问题就是 AI 自己审自己的稿子——**Scaled Content Abuse 识别信号之一**。

**解法**：用 5 个预设 persona 跑「虚拟读者试读」，每个 persona 有不同背景 + 反馈风格，强迫 AI **站在非自己立场看文章**。反馈落到 YAML 报告，让用户（真人）做最终判断。

**本文覆盖**：
- §2 前置条件 + 5 类触发场景
- §3 7 步工作流（核心骨架）
- §4 5 persona 方案对比（核心 — B 档灵魂）
- §5 YAML schema 拆解 + 真实报告节选
- §6 5 条反 pattern（对应 §0 5 条社区坑）
- §7 依赖 + v1-v2 演进路径
- §8 总结 + 3 个后置动作

**不覆盖**：mock-reader-feedback 跟真人 reader / 自己审稿的 ROI 对比（这是另一篇文章的事）。

---

## 步骤 1：装前置条件

### 1.0 3 项前置检查

```bash
claude --version            # ≥ 1.0
ls -ld ~/.claude/skills/    # 当前用户可写（macOS sandbox 可能限制）
python3 --version           # ≥ 3.8（Pillow 兼容）
```

### 1.1 三个必备文件

```bash
docs/mock-reader-personas.md    # 5 persona prompt 模板（230 行）
docs/persona-data.json          # MVP=MOCK 数据 / V1.1+=real data（203 行）
.claude/skills/mock-reader-feedback/SKILL.md   # 本文拆解对象
```

**首次跑必做**：`mkdir -p docs/feedback && echo 'initialized'` — skill 默认输出目录不存在会 fail。

### 1.2 一个 data fetcher 脚本

```bash
scripts/fetch-persona-data.sh   # 验证 cache 状态 / 可选 --live
```

### 1.3 一篇 ≥500 词的目标文章

`content/posts/<category>/<article-slug>/index.md`（已 [zh-final] 或 [en-final] 都可）

### 1.4 自检

```bash
# 验证 cache JSON 合法
python3 -c "import json; json.load(open('docs/persona-data.json'))"

# 验证 5 persona 完整
count=$(grep -c "^## P[1-5]" docs/mock-reader-personas.md)
if [ "$count" -ne 5 ]; then echo "persona 数量异常 ($count)，请检查 docs/mock-reader-personas.md"; exit 1; fi
```

📸 **截图标注位**（步骤 1）：
- **位置**：`docs/mock-reader-personas.md` P1 段落截图
- **脱敏要求**：不需要（仓库内公开文件）
- **文件命名**：`step-1-personas-p1-section.png`
- **放哪**：`content/posts/ai-agent/mock-reader-feedback-skill-deep-dive/step-1-personas-p1-section.png`

![P1 persona template from docs/mock-reader-personas.md: strong Chinese mainland dev, deployment-focused reader with direct technical feedback style and specific traps to avoid](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-1-personas-p1-section.png)

---

## 步骤 2：触发 skill

**5 类 trigger phrases**（任一即可）：

| 短语 | 场景 |
|---|---|
| 「模拟读者反馈」| 中文 trigger，最常用 |
| 「mock reader feedback」| 英文 trigger |
| 「P1 反馈」| 显式指定 persona |
| 「试读一下」| 口语化 trigger |
| 「pretend to be a reader」| 英文口语 |

**完整命令示例**：

```
# 默认（推荐 P5 选型决策者，反馈最挑剔）
"对 hugo-cloudflare-pages-pitfalls 跑 mock reader feedback"

# 显式指定 P1（强华陆 dev，部署优先）
"对 claude-code-editorial-pipeline 跑 P1 反馈"

# 多 persona 对比（V2 功能）
"对 hugo-pitfalls 跑 P1 vs P3 对比"
```

**未触发？** 检查 `.claude/skills/mock-reader-feedback/SKILL.md` 是否在 Claude Code skill discovery path。运行 `/skills` 列出已加载 skill — 若未出现 mock-reader-feedback，检查文件路径 + 重启 Claude Code。

---

## 步骤 3：选 persona + 加载数据

### 3.1 选 persona（默认 P5）

```yaml
P1: 强华陆 dev（部署优先 + EACCES 排错 + 国内网络踩坑）
P2: 内容创作者（文笔 / SEO / 标题党反 sense）
P3: 西方 indie hacker（30 秒决策 / ROI / 选型表）
P4: AI 怀疑者（LLM-as-judge 警惕 / 营销反感）
P5: 选型决策者（默认 · TCO / 退出成本 / 对比矩阵）
```

**默认 P5**：P5 反馈质量最高，**强迫发现真正问题**（per `mock-reader-feedback` SKILL.md §2）。用户没指定 → 永远 P5。

### 3.2 加载数据（默认 cache / 显式 --live）

```bash
# 默认（推荐）— 直接读 cache，不消耗 API quota
./scripts/fetch-persona-data.sh

# --live 模式（用户主动要求刷新）
./scripts/fetch-persona-data.sh --live --source=gsc
```

**GSC 接入前**：`docs/persona-data.json` 里 `data_source` 全是 `"[MOCK]"`。prompt 必须显式 `[MOCK]` 标签，**不假装真实地理数据**。

📸 **截图标注位**（步骤 3）：
- **位置**：`docs/persona-data.json` P1 块 geo_distribution 字段
- **脱敏要求**：不需要（[MOCK] 数据）
- **文件命名**：`step-3-persona-data-p1-mock.png`
- **放哪**：同上 Page Bundle

![P1 geo_distribution mock data from docs/persona-data.json showing CN 85 percent, HK TW 5 percent each, SG 3 percent, OTHER 2 percent — labeled MOCK to avoid fabricating real geographic distribution](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-3-persona-data-p1-mock.png)

---

## 步骤 4：构造 persona prompt（3 块拼接）

```text
你是 HeimaEden 博客 <P1-P5 人格标签>。背景：<docs/mock-reader-personas.md 中 P1-P5 描述>。

实时数据（来自 docs/persona-data.json 中的 <persona-id>）：
- 地理分布：<geo_distribution>
- 设备分布：<device_split>
- 典型搜索词：<top_search_queries>
- 优先阅读：<top_pages_visited>
- 社区活跃：<community_signals>

阅读场景：<primary_intent>（如 deploy-fixing / selection-decision）

你的反馈风格：<feedback_style>（如 direct_technical / reddit-grade / one-liner）

阅读 [文章标题] 后，按下面的 YAML schema 输出反馈。
```

**3 条硬规矩**：

1. **必须显式标注 feedback_style**——避免 P3 写成长文（one-liner）或 P4 写评论（silent）。如果不写 feedback_style，LLM 默认走「通用正面反馈」→ 触发 §0 第 2 条社区坑（5⭐ 全赞）。
2. **数据是 [MOCK] 时显式标注**——避免假装真实地理数据（per §0 第 1 条 LLM surface-level 偏差）。
3. **不读 front matter**——只读 body，避免 prompt 浪费 token 在 metadata 上。

---

## 步骤 5：运行 persona + 输出 YAML schema（严格）

**完整 YAML schema**（必须严格遵守，front matter 12 字段 + body 4 段）：

```yaml
---
schema: mock-reader-feedback/v1
persona_id: P1
persona_label: 强华陆 dev
article_slug: hugo-cloudflare-pages-pitfalls
article_path: content/posts/static-site/hugo-cloudflare-pages-pitfalls.md
article_category: static-site
read_at: 2026-08-20T22:45:00Z
data_source: MOCK | GSC | CF | REDDIT | PLAUSIBLE
intent: deploy-fixing
feedback_style: direct_technical
rating: 1-5
verdict: stay | skim | bounce
---

<!-- 上面 YAML block + 完整 persona 思考过程 + 关键 quote + 修复建议 -->

key_points:
  - …（3-5 条，正面 + 负面）
friction_points:
  - paragraph: "§3 第四段"
    issue: "报错例子没有完整堆栈"
    suggested_fix: "补 stack trace 头部 5 行"
quote_feedback: |
  "如果我是搜索这个报错进来，我希望在 3 屏内看到 root cause。"
session_signals:
  - 估算停留时长
  - 估算是否收藏
  - 估算是否订阅
```

**字段说明**：

| 字段 | 必填 | 默认值 | 说明 |
|---|---|---|---|
| `schema` | ✅ | — | 固定 `mock-reader-feedback/v1`，schema 演进做版本判断 |
| `persona_id` | ✅ | — | P1-P5 之一，触发 persona prompt 选择 |
| `persona_label` | ✅ | — | 人设中文标签，方便人眼核对（避免 P1/P5 串号） |
| `article_slug` | ✅ | — | 目标文章 slug，用于输出文件名 |
| `article_path` | ⚪ optional | `<slug>.md` 推断 | 完整路径，方便脚本直读 |
| `article_category` | ⚪ optional | front matter 推断 | 分类冗余，避免每次解析 front matter |
| `feedback_style` | ⚪ optional | `long-form-rss`（P5 默认） | 显式标注 — 防止 §6 反 pattern #2（"让 P3 写长篇评论"）|
| `read_at` | ⚪ optional | 当前 ISO timestamp | 反馈生成时间 |
| `data_source` | ⚪ optional | `MOCK` | MOCK / GSC / CF / REDDIT / PLAUSIBLE 之一 |
| `intent` | ⚪ optional | `selection-decision` | 匹配 persona 的 primary_intent |
| `rating` | ✅ | — | 1-5 整数，**强制 < 5**（5⭐ = persona 失真）|
| `verdict` | ✅ | — | `stay` / `skim` / `bounce` 之一 |

**§5.1 缺字段失败模式**（vendor-grade robustness）：

| 字段缺失 | 行为 |
|---|---|
| `schema` / `persona_id` | 报错并退出 |
| `persona_label` | 警告但仍跑（人眼核对用）|
| `feedback_style` | 警告 + 退化 `long-form-rss`（避免 §6 #2）|
| `article_slug` | 警告但不退出（默认路径兜底）|

**真实报告 body 节选**（`docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md`，front matter 12 字段严格按上表填写）：

```yaml
key_points:
  - "实测 7 个坑 + 真实复现 — 不像 AI 农场"
  - "ERR_TOO_MANY_REDIRECTS 修复段命令可直接复制"
  - "封面用的是 Unsplash 概念图，§7 才出现真实截图 — 顺序有点违和"
friction_points:
  - paragraph: "§3 ERR_TOO_MANY_REDIRECTS"
    issue: "截图前少了 PII 脱敏命令的实际调用"
    suggested_fix: "在 §3.4 后补 pip3 install --user Pillow + 红框坐标示例"
  - paragraph: "§6 Pros & Cons 表格"
    issue: "Hetzner 列价格是 2024 数据，2026 已涨价"
    suggested_fix: "加 [已停办] 标注或更新到 2026 实测价"
quote_feedback: |
  "如果我是搜 ERR_TOO_MANY_REDIRECTS 进来的，标题已有命中词。
  但读到 §3 之前要点 3 屏 Intro — 建议 Intro 砍到 200 词。"
session_signals:
  - 估算停留 6 分钟（读完 §3 + §6）
  - 估算收藏：是（修复段可直接复制）
  - 估算订阅：否（未到 P1 关注的「国内网络踩坑」部分）
```

📸 **截图标注位**（步骤 5）：
- **位置**：`docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md` YAML 头部
- **脱敏要求**：不需要（已经是公开仓库内文件）
- **文件命名**：`step-5-real-report-hugo-pitfalls-p1.png`
- **放哪**：同上 Page Bundle

![Real P1 mock-reader feedback YAML front matter from docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md with 12 fields including schema mock-reader-feedback/v1, persona_label, article_path, feedback_style, rating 4, verdict stay](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-5-real-report-hugo-pitfalls-p1.png)

---

## 步骤 6：写到 docs/feedback/

```bash
# V1 默认：先放 docs/feedback/，**不自动 commit**
docs/feedback/<article-slug>-<persona-id>.md

# V1 文件结构（YAML inside markdown body, not TOML front matter）
---
schema: mock-reader-feedback/v1
persona_id: P1
article_slug: <article-slug>
read_at: 2026-08-20T22:30:00Z
intent: deploy-fixing
data_source: MOCK
rating: 4
verdict: stay
---

<!-- 上面 YAML block + 完整 persona 思考过程 + 关键 quote + 修复建议 -->
```

**不要 commit**（默认）——GIT 用户主动 `git add -f` 才入仓库（per .gitignore）。这条规矩防止「每次跑 mock-reader 都污染 git log」。

**何时 commit 反规则**：≥ 3 份反馈交叉验证 ≥ 2 persona 提到同一 friction → 该 friction 是真问题，commit 反馈作为改文章依据（per §6 #6 baseline 对照）。

---

## 步骤 7：自检（5 条硬检查 + 1 条多样性检查）

| 检查 | 期望 |
|---|---|
| ✅ 5 个 key_points 至少 1 负面？ | 是（避免 §0 第 2 条 5⭐ 社区坑）|
| ✅ friction_points 至少 1 条具体段落？ | 是（避免泛泛「加更多例子」）|
| ✅ rating < 5？ | 是（5⭐ = persona 失真，反 pattern §6.1）|
| ✅ YAML 严格遵循 schema？ | 是（CI/CD 友好，结构化反馈）|
| ✅ 写到了 docs/feedback/？ | 是（不污染 content/posts/）|
| ✅ 多样性自检（D12 SOP）| 跑 `grep -h '^prompt_type' content/posts/**/*.md | tail -5`；≥ 4 篇同类型 → 反馈里加「Scaled Content 风险」|

---

## 5 persona 方案对比（核心 — B 档灵魂）

| persona | 反馈风格 | 典型命中 | 反 pattern |
|---|---|---|---|
| **P1** 强华陆 dev | `direct_technical` | 部署步骤细节 / EACCES 排错 / 国内网络 | 写得太长不像 dev 直白 |
| **P2** 内容创作者 | `editor-grade` | 文笔 / SEO / 标题党反 sense | 反馈里塞 testimonial |
| **P3** 西方 indie hacker | `one-liner` | 30 秒决策 / ROI / 选型表 | 写成 500 字技术评论 |
| **P4** AI 怀疑者 | `silent` | LLM-as-judge 警惕 / 营销腔反感 | 写出 AI 农场味 |
| **P5** 选型决策者 | `comparison-matrix` | TCO 量化 / 退出成本 / 对比表 | 默认全赞 + 0 friction |

**选型建议**（按场景）：

- **写完 [draft] 第一次审稿** → 跑 P5（默认）+ P1（验证可实操）
- **翻译后 [en-final]** → 加 P3（验证海外读者接受度）
- **AI 农场味怀疑** → 加 P4（反向校验）
- **Money Hook 类文章** → 必跑 P2（SEO / 标题党）

---

## 反 pattern（6 条已踩坑）

对应 §0 5 条社区坑 + 1 条「跑 skill 之前 vs 之后」对照。**反 pattern #1 是 LLM 默认行为而非 skill 自身问题** — 真实「失败 demo」截图难做（LLM 已内置批判），改为引用 §0 社区坑作反面证据。

| # | 反 pattern | 触发场景 | 修正 |
|---|---|---|---|
| 1 | 反馈写得「完美无缺」—— 5⭐ + 0 friction | LLM 默认 positive bias（§0 第 2 条 [Field Guide to AI](https://fieldguidetoai.com/scam-watch/fake-ai-reviews)）| prompt 加「rating 必 < 5 + friction 至少 1 条」 + 显式 feedback_style |
| 2 | 让 P3 写「长篇技术评论」 | P3 是 one-liner 人格，不显式 feedback_style 就 stereotype | system prompt 第 3 块显式 `your feedback style: one-liner` |
| 3 | 反馈里用 testimonial 营销腔 | "Would highly recommend..." 触发 §0 第 5 条 AI 农场味 | system prompt 加「forbid testimonial tone」 |
| 4 | 反馈报告 commit 进 content/posts/ | 污染文章目录 + git log | 默认 docs/feedback/，用户 `git add -f` 才入仓库 |
| 5 | 改动原文后没存档 persona 反馈 | 无法回溯「为什么改」 | 任何 [zh-final] commit 必关联 docs/feedback/ ≥ 1 份 |
| 6 | 不调 skill 直接让 LLM 评文章 | 跳 step 1-7，14 字裸 prompt 触发 §0 第 1 条偏差 | **始终通过 `.claude/skills/.../SKILL.md` 调用**；baseline 见下方 |

**baseline 失败案例**（不跑 skill · 14 字裸 prompt）：`Prompt: "请评价这篇文章"` → `Output: "这是一篇很棒的文章，结构清晰，内容丰富，值得推荐。5/5。"` — 没 persona / feedback_style / rating 约束 → LLM 走 default positive bias（§附录0 第 2 条：5⭐ + 0 friction）。**对比下方截图 4/5 + 完整 friction + Path to 5/5，差异 = skill 核心价值。**

📸 **成功对照截图**（跑 skill 后的标准输出）：
- **位置**：用户实际跑 `mock-reader-feedback` skill 的 terminal 输出（针对 hugo-cloudflare-pages-pitfalls）
- **特征**：`Impression: 4/5` + Highlights 4-5 条（含 Trap 1-5 段落锚定）+ **Deductions 4-5 条**（具体段落问题）+ Contrast compliance（TOML/lint 检查）+ Path to 5/5 改进建议
- **意义**：证明 skill 的核心价值 = **强制约束 LLM 默认 positive bias** — 没 skill 跑出来是营销腔 5⭐，有 skill 跑出来是 4/5 + 完整 friction + 段落锚定改进建议
- **脱敏要求**：不需要（terminal 内容不含 PII）
- **文件命名**：`skill-working-baseline.png`
- **放哪**：同上 Page Bundle

![Mock-reader-feedback skill baseline output for hugo-cloudflare-pages-pitfalls: rating 4 out of 5 with structured Highlights covering traps 1-5 plus detailed Deductions pointing to specific paragraphs and a Path to 5/5 improvement list — the value of the skill is forcing LLM away from default positive bias toward substantive critique](/images/ai-agent/mock-reader-feedback-skill-deep-dive/skill-working-baseline.png)

---

## 依赖 + v1-v2 演进路径

### 依赖

```bash
docs/mock-reader-personas.md    # 5 persona prompt 模板
docs/persona-data.json          # MOCK → real data 演进中
scripts/fetch-persona-data.sh   # cache validator + optional --live fetcher
```

**fallback 表**（cache + live 4 组合）：cache hit → 用 cache（默认）；miss+OK → fetch live；miss+fail → 报错 + 退化 P5 + 显式 `[MOCK]`；quota exceeded → 退 cache + stderr 警告。

### v1-v2 演进（已计划，未实现）

| 版本 | 计划 | 触发条件 |
|---|---|---|
| v1.1 | GSC live 接入（OAuth service account） | GCP project + service account JSON 配置完成 |
| v1.2 | CF Analytics（访问 + 设备 + referrer） | Cloudflare API token 配置 |
| v1.3 | Reddit / HN / GitHub 公开 API | rate limit 配额 + 内容审查 SOP |
| v1.4 | Plausible / Umami 博客原生 | 自托管 Plausible 实例 OR 付费 Umami 订阅 |
| **v2** | multi-persona 对比 + 自动 highlight friction points | `--multi` flag + Markdown diff 渲染 |

---

## 总结 + 后置动作

**3 个后置动作 trigger**：

1. 「提交反馈」→ 用 commit-with-prefix skill，prefix=`[docs]`，scope `feedback`
2. 「基于反馈改文章」→ 走 zh-final-refactor skill（TCM 阶段 4）
3. 「再跑 P1/P3 对比」→ 重复本文 §3-§7，输出对比表

**主要 takeaways**：

- LLM-as-judge **永远需要显式 feedback_style**——不写 = 默认「通用正面反馈」→ 5⭐ 全赞
- `[MOCK]` 数据必须显式标注——LLM 倾向 surface-level，不标就假装真实
- 跑 mock-reader **不是 AI 自查，是 AI 站在非自己立场看文章**——真人最终判断
- 反馈报告默认不 commit——避免 git log 污染

### TCO 估算（决策前必看）

| 维度 | 数值 |
|---|---|
| 单篇 token | 500 词 × 5 personas × ~3K ≈ **15K tokens/article** |
| API 成本 | Claude Sonnet $3/M ≈ **$0.045/draft** |
| Setup | 30 分钟一次性（4 配置文件 + 1 skill + 1 fetcher）|
| Payback | ~3 drafts（按人工审稿 $15/hr）|
| 退出成本 | **接近 0** — 产物是 plain YAML in markdown，可 git 追踪 / 迁移 ChatGPT / 训练自有模型，**无 vendor lock-in** |

> **📎 【联盟预留位】**：无（自身工具，per CLAUDE.md §3.4）

---

*起草：D21 2026-08-30 · 路径 `content/posts/ai-agent/mock-reader-feedback-skill-deep-dive/index.md`*
*触发：X1 `docs/archive/think-x1-claude-code-pipeline.md` §6 Y1 候选（用户 D21 决策 P1 方案）*
*档位：E（方法论 retrospective，per docs/writing-prompts.md §六 — 含 commit hash + 12 份反馈 + 决策点；非 B 档横评）*
*配套 commit：`[draft] mock-reader-feedback-skill-deep-dive + topic-pool.md Y1 同步` + `[asset] 4 screenshots 入库`*