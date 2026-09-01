# HeimaEden 写作 Prompt 库（writing-prompts.md）

> **目的**：按文章结构变体选择对应 prompt 模板，避免所有文章"长得像"被 Google Scaled Content Abuse 识别为 AI 工厂内容。
>
> **触发决策**：D12（2026-08-25）扩展方案 —— `new-draft-zh` SOP 阶段 3（章节骨架）应先判定文章类型，再选 prompt，再套模板。
>
> **数据来源**：`docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 1（"页面数量短期暴增、结构措辞高度相似"是 Scaled Content 识别信号）+ 第一轮复核 §1 微调 1（"匀速本身就是信号"）。
>
> **前置 SOP**：`docs/article-writing-workflow.md` §5.2（推荐结构） + `docs/geo-writing-module.md`（GEO 5 段骨架）+ `docs/blog-writing-prompt.md`（已并入 Prompt A，下线）。

---

## 一、5 种 Prompt 类型速查

| 类型 | **字数 soft 建议（D24-B 调整）** | 适用文章 | HeimaEden 样本 | 关键反 AI-farm 指纹 |
|---|---|---|---|---|
| **A. 纯排障型** | ≤ **1200** 词 | 报错代码 + 配置调试 | S1-S9 / B1-2 | 原始 log 块 + 真实版本号 + 修复命令 |
| **B. 方案对比型** | ≤ **1800** 词 | 选型 / VPS / SaaS 横评 | S10 (Hugo vs Astro) / S11 (CF vs Vercel) | 实测数据表 + 真实月成本 + 1 票否决点 |
| **C. 踩坑叙事型** | ≤ **2200** 词 | 调试马拉松 / war story | 撤销事件类（D4 4b8a8ea 教训） | 时间锚 + 多次失败 + 关键顿悟 |
| **D. 原理深挖型** | ≤ **2500** 词 | 概念解释 / 架构原理 | 待写（Scaled Content 检测原理） | 类比 + 边界条件 + "推到极端会怎样" |
| **E. 方法论 retrospective** | ≤ **2500** 词 | "How I built X" workflow | X1 (claude-code pipeline) | commit hash + 撤销事件 + 决策点 |

> **全档通用 ceiling（D24-B 新增）**：≤ **3500** 词。任何 prompt_type 文章超过 3500 词 = 必须 trim 或拆分为多篇。超过本档 soft 建议但 ≤ 3500 = AI 自检**报告但不阻 commit**（用户决定是否 trim）。
>
> **D24-B 字数控制软化**：D24-B 决策把 D16 的 5-type 硬上限降级为 soft 建议（advisory，AI 自检报告不阻 commit），新增全档通用 ceiling 3500 词。**D24 起的 D16 例外备注同步退役**（基于"硬约束"前提，已不适用）。反 Scaled Content 主防线仍是 §七 结构多样性 + 指纹段 + 真实 log + 作者立场，字数只是辅助编辑纪律。

**判定时机**：`new-draft-zh` 阶段 3（章节骨架生成前）先回答 — 这篇文章主要服务哪种读者需求？对应 1 种 prompt（不要混搭超过 2 种）。

---

## 二、Prompt A — 纯排障型

**字数 soft 建议（D24-B）**：≤ **1200** 词（advisory）。甜区 1100-1200（含原始 log 块 + 修复命令）。**全档 ceiling 3500**：超本档建议时 AI 自检报告不阻 commit；超 3500 必须 trim 或拆分。

**角色**：资深技术作家，专为开发者写 SEO + GEO 友好的英文排错长文。

**任务**：基于用户提供的报错日志 + 运行环境 + 已验证解决方案 → 生成结构紧凑、高度实用、具备"人类实操痕迹"的英文排错长文。

**输入字段**：

```
1. 报错日志 / 问题描述: ...
2. 系统 / 软件环境版本: ...
3. 已验证的解决方案（命令/代码）: ...
4. 目标英文长尾关键词: ...
```

**输出结构**（严格按顺序）：

1. **Title**：清晰、搜索意图导向，含目标关键词 + 具体 Error Code/Message
2. **Meta Title**（≤ 60 chars）+ **Meta Description**（≤ 155 chars）
3. **TL;DR**（前两句话）：根因 + 极简修复（适配 Google AI Overview）
4. **Environment**：OS / 开发工具 / 精确版本号（无序列表）
5. **Error Log**：原始 log（代码块，**不删减不"美化"**）
6. **Root Cause**：1-2 句底层逻辑
7. **Step-by-step Fix**：可复制命令 + Markdown 注释
8. **Fingerprint Tip**：1 句踩坑警告 + 性能/优化小贴士（基于真实部署）

**反 AI-farm 硬规矩**：

- ❌ 禁止 AI 常见套话：`In today's digital world` / `delve into` / `in conclusion` / `furthermore` / `unleash the power of`
- ❌ 禁止"我 learned this the hard way"无锚点 first-person（CLAUDE.md §3.8 rule 1）
- ✅ 必须含原始 log 块（不被"整洁化"）
- ✅ 必须含精确版本号（不写"new version" / "latest"）
- ✅ 必须含 commit hash 或 issue 链接（若适用）

---

## 三、Prompt B — 方案对比型

**字数 soft 建议（D24-B）**：≤ **1800** 词（advisory）。甜区 1500-1800（含 6 列对比表 + 3-5 候选 per-section）。**全档 ceiling 3500**：超本档建议时 AI 自检报告不阻 commit；超 3500 必须 trim 或拆分。

**角色**：独立开发者顾问，给"已经用了一个月"的中级开发者写选型横评。

**任务**：基于候选清单 + 用户实际场景 → 生成带实测数据的英文选型长文，结尾给出明确推荐（含理由 + 适用边界）。

**输入字段**：

```
1. 候选清单（3-5 个产品/工具/服务）: ...
2. 对比维度（建议 4-6 个：价格 / 性能 / 锁定成本 / 支持 / 适用规模 / 学习曲线）: ...
3. 用户实际场景（含流量级 / 团队大小 / 关键痛点）: ...
4. 已实际跑过的服务（≥ 1 个，最好 ≥ 2 个）: ...
5. 1 票否决点（什么情况下不能选 X）: ...
```

**输出结构**：

1. **Title**：`Best {category} for {use case} in {year}`（避免 "Ultimate Guide" / "X Tips"）
- **Front matter**：Meta 含 `comparison` / `review` 类长尾词
- **TL;DR**：1 句推荐 + 1 句 1 票否决 + 1 句替代方案
- **Comparison Table**：6 列 × 5 行的紧凑对比（**实测数据，不靠理论**）
- **Per-Candidate Section**：每个候选 1 段，含「实际用过 X 个月」的体感 + 1 个具体场景下的优劣
- **Verdict**：明确推荐 + "如果你 X，改为 Y" 的分流建议
- **My Setup**：公开作者本人用的方案（build-in-public 信任资产）

**反 AI-farm 硬规矩**：

- ❌ 禁止"feature parity"纯描述（要含"用了 X 个月后的体感"）
- ❌ 禁止"all options are great, depends on your needs"和稀泥
- ❌ 禁止"reviews from 100+ users"等不可验证数据
- ✅ 必须含实测价格（带日期戳 — 价格会变）
- ✅ 必须含至少 1 个具体场景："在我的 5k UV/天 Hugo 站上"
- ✅ 必须含作者本人选择（不躲在"取决于"后面）

---

## 四、Prompt C — 踩坑叙事型

**字数 soft 建议（D24-B）**：≤ **2200** 词（advisory）。甜区 1800-2200（容得下 ≥3 段 Day-N 时间线 + The Break 段）。**全档 ceiling 3500**：超本档建议时 AI 自检报告不阻 commit；超 3500 必须 trim 或拆分。

**角色**：写过 50+ 排错文的工程师，把"调试马拉松"写成有节奏感的故事。

**任务**：把多日/多轮调试过程写成有时间线、有失败有顿悟的英文叙事文。

**输入字段**：

```
1. 报错症状（初始）: ...
2. 时间跨度（建议 ≥ 1 周）: ...
3. 失败的尝试（≥ 3 个，含每个失败的判断逻辑）: ...
4. 关键转折点（是什么让你意识到方向错了）: ...
5. 最终修复方案 + 为什么之前没想到: ...
6. 情绪锚点（≥ 1 个：放弃的边缘 / 巧合的成功 / 同事一句话点醒）: ...
```

**输出结构**：

1. **Title**：`Why {error} took me {N} days to fix`（避免 "Debugging X" 通用）
- **TL;DR**：1 句最终修复 + 1 句"真正问题不是 X 而是 Y"的反直觉结论
- **Day 1**: 第一天尝试（含失败的搜索词 + 读到的文档 + 试过的命令）
- **Day 2-N**: 每天一节，每节结尾有"还是没解决"或"接近了"
- **The Break**: 顿悟时刻（明确标出，含触发动作 — 偶然 / 阅读某段 / 同事一句话）
- **The Fix**: 真正修复（含为什么之前没想到）
- **Why I Missed It**: 复盘 — 思维陷阱 + 认知偏差 + 搜索词盲点
- **Lesson**: 1 句可迁移结论

**反 AI-farm 硬规矩**：

- ❌ 禁止"a common mistake is..."无具体场景的总结
- ❌ 禁止时间线完美（每天都有进展 — 真人调试有"两天没动"）
- ❌ 禁止"everything worked perfectly"happy ending（必须有至少 1 个"放弃的边缘"）
- ✅ 必须含真实时间锚点（D2 上午 / 周三深夜 / 咖啡店）
- ✅ 必须含至少 1 次自我怀疑：怀疑工具 / 怀疑自己 / 怀疑文档
- ✅ 必须含至少 1 次"看似无关"的线索（让读者体会 detective 感）

---

## 五、Prompt D — 原理深挖型

**字数 soft 建议（D24-B）**：≤ **2500** 词（advisory）。甜区 2000-2500（容得下 ≥3 边界条件 + 1 worked example）。**全档 ceiling 3500**：超本档建议时 AI 自检报告不阻 commit；超 3500 必须 trim 或拆分。

**角色**：能把 RFC 写成咖啡桌旁白话的高级工程师。

**任务**：把抽象技术概念（算法 / 协议 / 架构 / 决策机制）写成"看完能用 + 知道为什么"的中长文。

**输入字段**：

```
1. 概念名称: ...
2. 表层定义（官方 1 句话）: ...
3. 为什么重要（开发者什么时候需要关心）: ...
4. 类比物（生活中熟悉的东西）: ...
5. 边界条件（推到极端会怎样）: ...
6. worked example（一个具体场景下的计算/推演）: ...
```

**输出结构**：

1. **Title**：`{concept} explained: {non-obvious insight}`（避免 "{concept} 101" / "{concept} tutorial"）
- **TL;DR**：1 句直觉 + 1 句"最容易误解的点"
- **The Intuition**：用类比建立 mental model（"想象你在图书馆借书..."）
- **Formal Definition**：用类比物 + 公式 / 算法伪代码
- **Why It's Designed This Way**：设计动机 + 历史 + 替代方案为何被弃
- **Edge Cases**：至少 3 个边界（极端规模 / 异常输入 / 反直觉场景）
- **Worked Example**：从头推演 1 个真实案例（含每一步计算）
- **What I Wish I Knew Sooner**：1 句非显然洞察（作者本人刚学会时没想到的）

**反 AI-farm 硬规矩**：

- ❌ 禁止"let's dive into" / "without further ado"开场套话
- ❌ 禁止把官方文档原文翻译一遍（直接链文档）
- ❌ 禁止"as you can see from the diagram"无图配文
- ✅ 必须含至少 1 个非显然洞察（"大家都以为 X，其实 Y"）
- ✅ 必须含至少 3 个边界条件
- ✅ 必须含类比物（生活化，非技术类比）

---

## 六、Prompt E — 方法论 retrospective

**字数 soft 建议（D24-B）**：≤ **2500** 词（advisory）。甜区 2000-2500（容得下 ≥5 轮迭代段 + The Revert 段 + Decision Points 表）。**全档 ceiling 3500**：超本档建议时 AI 自检报告不阻 commit；超 3500 必须 trim 或拆分。

> **历史参照（D24-B）**：X1（`claude-code-editorial-pipeline`）原 D16 wc -w 估 4064 词超 E 档。精确测量 2225 词在 E soft ≤2500 合规范围，D24 例外备注退役。新文按 D24-B soft + 3500 ceiling 双层约束运行。

**角色**：在公开日记里写 build-in-public 的工程师，X1 类文章专用。

**任务**：把"我如何一步步搭出某个工作流"的过程写成有 commit hash、有撤销、有决策点的英文方法论长文。

**输入字段**：

```
1. 原始问题（X 天/周前遇到）: ...
2. 试过的方案 A / B / C（失败或不够好）: ...
3. 最终方案（Y = A + B + C 改进版）: ...
4. 关键决策点（≥ 3 个，含为什么选 A 而不是 B）: ...
5. 撤销事件（≥ 1 次，含 commit hash + 为什么撤回）: ...
6. 实测基线（X 小时/篇 → Y 小时/篇）: ...
7. 沉淀的约束/规则（≥ 3 条）: ...
```

**输出结构**：

1. **Title**：`How I {verb} my {workflow} from {X} to {Y} in {N} days`（X1 范式）
- **TL;DR**：1 句最终方案 + 1 句耗时对比 + 1 句"关键不是 X 而是 Y"
- **Setup**：N 天前的问题 + 当时的耗时基线
- **Iteration 1 → N**：每轮迭代 1 段（version 1 / version 2 / ...）
- **The Revert**：撤销事件（明确标出，含 commit hash — `4b8a8ea` → `bc9a369` 类）
- **Decision Points**：表格 — 候选 / 选 / 触发条件 / 预期代价
- **What Stuck**：沉淀的约束（numbered list，含每条触发场景）
- **What I'd Do Differently**：诚实复盘 — 至少 1 条"重做会改的地方"

**反 AI-farm 硬规矩**：

- ❌ 禁止"journey of discovery"等励志套话
- ❌ 禁止每轮迭代都"great progress"（中间必有"放弃边缘"或"绕弯路"）
- ❌ 禁止隐瞒撤销事件（必须展示 commit 失败 / 回退）
- ✅ 必须含 ≥ 1 个 commit hash（`git show --stat <hash> | head -3` 输出）
- ✅ 必须含实测耗时对比（X hours → Y hours per task）
- ✅ 必须含至少 1 条 self-criticism（不是 humble brag）

---

## 七、反 AI-farm 共性原则（5 种 prompt 通用）

不论选哪种 prompt，以下红线适用于所有 HeimaEden 文章：

- ✅ **每篇必含 ≥ 1 段"指纹段"** — 真实 first-person 场景，含具体时间 / 版本号 / commit hash（CLAUDE.md §3.8 rule 1 + `docs/geo-writing-module.md` §四）
- ✅ **每篇必含真实 log / 真实数据** — 不编造"模拟场景"
- ✅ **每篇必含作者本人选择 / 立场** — 不躲在"取决于"后面
- ✅ **每篇 first commit 时记录 prompt 类型** — front matter 加 `prompt_type: A-E`（方便后续 mock-reader 检验结构多样性）
- ✅ **字数控制（D24-B）**：soft 建议按 prompt_type（A≤1200 / B≤1800 / C≤2200 / D≤2500 / E≤2500），全档通用 ceiling **3500 词**。超本档 soft 但 ≤ 3500 = AI 自检报告，不阻 commit；超 3500 = 必须 trim 或拆分为多篇。**反 Scaled Content 主防线是结构多样性 + 指纹段 + 真实 log，字数只是辅助编辑纪律。**
- ❌ **禁止 SEO-spam 模板套话** — `ultimate guide` / `you won't believe` / `X tips to master Y`（CLAUDE.md §3.1）
- ❌ **禁止跨文章结构高度相似** — 至少 3-4 种结构轮换，违反即触发 Scaled Content 审计

---

## 八、参考

- `docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 1（Scaled Content 识别信号）
- `docs/article-writing-workflow.md` §5.2（推荐结构）+ §5.1（措辞分类）
- `docs/geo-writing-module.md`（GEO 5 段骨架 + 指纹段定义）
- `CLAUDE.md` §3.1（tone）+ §3.8（AI 不写 first-person + cross-reference 锚点）
- `docs/blog-writing-prompt.md`（**已并入 Prompt A · 下线归档**）

---

**D24-B 决策记录**：软化字数上限（hard cap → soft advisory）+ 新增全档通用 ceiling 3500 词。触发因素：Y1 +7 词 / S18 +215 词超档争议揭示 D16 硬上限与"结构多样性"主防线**优先级倒置**。详见本会话上下文。