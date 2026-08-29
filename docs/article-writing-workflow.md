# 文章写作协作 SOP（article-writing-workflow.md）

> **触发条件**：任何新增英文 long-form post（≥800 词、发布到 heimaeden.com）必须按此 SOP 协作完成。
> **配套硬约束**：`CLAUDE.md §3.8`（auto-loaded）
> **首次落地**：2026-08-15（D4 后）
> **教训来源**：D4 越界 commit `4b8a8ea`（AI 编造 first-hand 经验） → `bc9a369` 撤销

---

## 🎯 协作角色分工

| 阶段 | 执行者 | 输出产物 |
|---|---|---|
| 0. 选题 | **AI 推荐 + 用户确认** | 选题 + 角度 |
| 1. 初稿 | AI | 中文 step-by-step + 截图标注位 + 联盟预留位 + 步骤0搜索任务 |
| 2. 实操 | **用户** | 真实操作结果 + 错误日志 + 时间戳 |
| 3. 反馈 | **用户** | 卡住点 / 报错 / 补充事实 |
| 4. 截图 | **用户** | 按初稿 §1.1 标注位提供真实截图 |
| 5. 第二版 | AI | 中文定稿（合并初稿 + 实操反馈 + 截图 + 社区坑附录） |
| 6. 用户确认 | **用户** | 增删事实 |
| 7. 翻译 | AI | 英文版（仅字面对应 + 地道英语 + SEO） |
| 8. 提交 | AI | commit + hold push 等 ack |

---

## 0. 选题推荐（AI 主导，基于上下文）

### AI 推荐前必须扫描

1. **现有文章分布**：
   ```bash
   find content/posts -name '*.md' | xargs -I{} dirname {} | sort | uniq -c
   ```
   - `static-site`：N 篇
   - `remote-payment`：M 篇
   - `side-project`：K 篇
   - ratio = N / (N+M+K)
2. **话题覆盖度**：对照 `docs/archive/think-templates-2026-08-27.md`（30 条）+ `docs/archive/think-payment-2026-08-27.md`（35 条）
   - 已写过的话题列表
   - 高 SEO 价值空白话题
3. **最近 3 篇 topics**：避免连续同话题
4. **Money Hook 密度**：对照 `README §7.3 E1`（≥15 篇长文 → AdSense）
   - 当前已有多少篇 affiliate-ready 文章？
   - 距 AdSense 申请还差几篇？

### AI 推荐输出

- 3 个候选 + 各自理由（基于站点情况 + 题目库）
- 用户选 1 个 → 进入初稿阶段

### 题目库

> 协作产物，本次会话**未创建**。下次会话讨论后写入 `docs/archive/topic-pool-2026-08-27-archive.md`。
>
> 题目库格式见附录 F。

---

## 1. 初稿（AI 写，中文）

### 1.0 文件位置

- Page Bundle 模式（CLAUDE.md §3.3 推荐）：`content/posts/<category>/<slug>/index.md`
- 命名规范：kebab-case + 英文 + 不含中文（CLAUDE.md §3.6）

### 1.1 语气约束（**最关键**）

✅ **正确**（step-by-step 操作清单）：

```markdown
## 步骤 1：打开 Cloudflare Pages 后台

1. 登录 https://dash.cloudflare.com
2. 进入 Workers & Pages → 选择对应项目
3. 点击 Settings → Builds
```

❌ **错误**（first-person 叙述）：

```markdown
## 我曾经遇到的问题

当时我配置 Preview Branches 时，被 Cloudflare 仪表盘的 UI 误导了整整两个小时。
我点击了那个显眼的蓝色按钮，结果掉进了 Workers workflow 的陷阱...
```

**初稿绝不写 first-person 经验**。first-person 仅在第二版出现，且必须有用户实操事实支撑。

### 1.1.1 「宁可不发」硬规矩（D12 交叉验证落地）

> **背景**：`docs/archive/运营方案与交叉验证文档-2026-08-27.md` §一 1. 微调逻辑 + 第二轮复核明确指出："10 分钟/篇是把双刃剑，这个时间只够成文，不够保证每条报错都真实复现过"。

**硬规矩**：

- ❌ 没有真实 log + 验证过的修复命令 → **宁可不发，不凑数**
- ❌ 一周内如果凑出 7 篇但其中 2 篇是"我猜是这样" → 整批触发 Scaled Content 降权的概率远高于少发 2 篇
- ✅ 断更一天的代价 < 一批薄内容被整体降权的代价
- ✅ "本篇有 1 条报错我没能 100% 复现" → 在 §已知问题与社区报告 显式标注 + 给来源链接，**绝不在正文编造修复命令**

**写入位置**：本规则应在每篇 [draft] commit 时由 AI 自检——若 §0 踩坑搜索输出 < 3 条，或用户在阶段 3 没反馈实操过程，立即暂停进度并回到用户。

### 1.2 截图标注位（每一步骤都需要）

```markdown
📸 **截图标注位**（步骤 N）：
- **位置**：[具体页面 / 设置项 / 区域]
- **脱敏要求**：[打码邮箱 / 隐藏 4 字段 / 高亮目标区域]
- **文件命名**：`step-N-描述.png`（kebab-case + 数字前缀）
- **放哪**：Page Bundle 同目录（如 `content/posts/static-site/<slug>/step-1.png`）
```

### 1.3 联盟链接预留位（适合联盟的文章）

```markdown
> 📎 **【联盟-占位 platform】** 待第二版确定
> 推荐用语模板（按 README §五-3 双向互惠）：
> "I use {platform} for my own {use case}. If you sign up via my link,
> you get {benefit}, and I earn a small commission at no extra cost to you."
> 链接变量：`{{ ref "data/affiliates.toml#platform" }}`（Phase 5 启用时填真值）
```

**适用文章类型**：
- ✅ 选型对比（如 VPS 横评）
- ✅ 个人使用体验（如 "Why I switched to Hetzner"）
- ❌ 故障排错（不道德）
- ❌ 官方 API 文档翻译（不专业）

### 1.4 步骤 0：踩坑搜索任务（实操前必做）

初稿开头必须包含「步骤 0：踩坑搜索」：

```markdown
## 步骤 0：踩坑搜索（实操前必做）

**任务**：动手前先搜一轮社区踩坑，为实操做心理预期

**搜索关键词模板**：
- `{技术} not working` / `{技术} trap` / `{技术} reddit`
- `{技术} github issue` / `{技术} stackoverflow`
- `{技术} + {关联关键词}`（如 "Hugo cache bleed"、"Cloudflare HUGO_VERSION"）

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
```

### 1.5 commit 边界

- commit message 前缀：`[draft] <topic>`
- **不自动 push**，hold 等用户 ack

---

## 2. 实操（用户执行）

按初稿步骤操作，记录：
- ✅ 哪些步骤顺利
- ❌ 哪些卡住
- 🐛 真实错误 / 报错截图 / 时间戳
- ⏱️ 真实耗时

---

## 3. 反馈（用户提供）

把实操结果整理为 markdown 反馈，发回给 AI：
- 哪些步骤需要调整描述
- 哪些错误初稿没预见
- 哪些链接/截图位置需要修正

---

## 4. 截图（用户提供）

按初稿 §1.1 标注位：
- 区域（仅截需要的部分）
- 脱敏（打码邮箱 / 隐藏 4 字段 / 高亮目标区域）
- 命名规范：`step-N-描述.png`
- 放到 Page Bundle 同目录（如 `content/posts/static-site/<slug>/step-1.png`）

### 4.1 上线前文件大小审计（D20 起强制 · CLAUDE.md §3.3.5）

截图入库后、`git add` 前必须跑：
```bash
./scripts/check-image-size.sh
```

阈值（错误阈值 = commit gate 必过）：
- cover 图 ≤ **200 KB** error / 150 KB warn
- body 图 ≤ **500 KB** error / 350 KB warn

超过阈值时按 CLAUDE.md §3.3.5 给出的 PIL palette-quantize 片段就地压缩到 ≤ error 阈值，然后重跑 gate 至 0 errors。

> 触发历史：D19 push 的 S18 cover 是 1.3MB PNG（sips resize 没压缩），srcset 兜底变体也是 1.3MB — 1080p 屏幕一次加载浪费 500+ KB。D20 加此铁律 + 自动化脚本防复发。

---

## 5. 第二版（AI 整合，中文定稿）

### 5.1 整合规则

| 内容来源 | 措辞 | 资格 |
|---|---|---|
| 用户 first-hand 经验 | "我" 描述（如"我配置时遇到..."）| ✅ 仅当用户实操事实支撑 |
| 他人 reported 坑 | "Per Cloudflare Community #1234..." / "Users on Reddit report..." | ✅ 来源透明 |
| 官方文档引用 | "Per Hugo documentation..." / "According to Cloudflare docs..." | ✅ 来源透明 |
| AI 编造内容 | "I learned this the hard way..." | ❌ **严禁** |

### 5.2 推荐结构

**先选 prompt，再套结构**（详见 `docs/writing-prompts.md`）：

每篇文章先判定 5 种 prompt 类型之一（A 纯排障 / B 方案对比 / C 踩坑叙事 / D 原理深挖 / E 方法论 retrospective），再按对应 prompt 的 output structure 套骨架。**禁止 5 篇文章同结构**——这是 Scaled Content Abuse 识别信号（参考 `docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 1）。

**默认结构**（仅在文章不属于 A-E 任意一种时使用，极少情况）：

1. **引言**（100 词）：本文解决什么问题
2. **前提条件**：环境 / 工具 / 账号要求
3. **步骤 1-N**：主线操作（合并初稿 + 实操反馈）
4. **已知问题与社区报告**（如果实操顺利，本节基于 §0 搜索结果）
5. **总结**

### 5.2.1 节奏随机性 + 结构变体（D12 交叉验证落地）

> **背景**：`docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 1 + 第一轮复核 §1 微调 1：匀速本身就是信号，每天雷打不动 1 篇 + 每篇结构一致，正是 Scaled Content Abuse 识别信号里"结构和措辞高度相似"的高危区。

**节奏要求**（写入每周 SOP）：

| 维度 | 硬规矩 | 原因 |
|---|---|---|
| **发布间隔** | ±1 天随机（不能"日更如钟表"） | 真人写作有波动，机器节奏触发审计 |
| **篇幅区间（分档硬约束，D16 决策）** | A 纯排错 ≤ **1200** / B 方案对比 ≤ **1800** / C 踩坑叙事 ≤ **2200** / D 原理深挖 ≤ **2500** / E 方法论 retrospective ≤ **2500** | 单篇结构指纹避免高度相似；分档规避"全 800 词短文"或"全 3000+ 长文"两极化 |
| **结构变体** | 至少 3~4 种轮换（纯排障型 / 方案对比型 / 踩坑叙事型 / 原理深挖型） | 避免 Error-to-Post 流水线天然产出的"报错→原因→修复"统一结构 |

> **D16 例外备注（2026-08-27）**：当前唯一例外为 `content/posts/ai-agent/claude-code-editorial-pipeline/index.md`（4064 词，commit `4225a6e` 已发布）。
> - **超档程度**：超 C 档上限 2200 +85%，超 D 档上限 2500 +63%
> - **保留理由**：该文为 X1 主文章，承担「品牌+互链型」资产作用；重写/压缩会损失 inbound link 价值与已建立的外链权重
> - **后续约束**：所有新文（含 S13/S14/S16/S17 + Hub §簇 3-5 填充 + P1/J1-J3/A1-A3 等推荐选题）严格按分档硬约束
> - **下次重审时点**：该文累计 inbound link 收益触顶时（建议 ≥ 30 个外部引用后评估压缩）

**GEO 优先试点**：第一篇 GEO 写作模板（**B2 P1 WorldFirst 实战 · D12 · 2026-08-25 升推荐中**）按 `docs/geo-writing-module.md`（待新建）落地——结论前置 + FAQ Schema + 代码块语义完整。详见该模块 SOP。

### 5.3 commit 边界

- commit message 前缀：`[zh-final] <topic>`
- **不自动 push**，hold 等用户 ack

---

## 6. 用户确认

- review 第二版
- 增删事实
- 确认无误 → 触发翻译阶段

---

## 7. 翻译润色（AI）

### 7.1 硬边界

- ❌ AI **不增删任何事实**
- ❌ AI **不改写用户原话**（包括中文口语化表达的真实感）
- ✅ 字面对应 + 地道英语表达 + SEO 结构（title/description/tags）
- ✅ 保留中文版本作为存档

### 7.2 commit 边界

- commit message：无前缀（最终版）
- **不自动 push**，hold 等用户 ack

---

## 8. 提交

- 用户 ack 后 `git push origin main`
- CF Pages 自动部署
- GSC 24-48h 开始抓取（已有 sitemap.xml 接入）

---

## 📋 附 A：踩坑策略选择

| 策略 | 适用场景 | 内容结构 |
|---|---|---|
| **A：Happy Path + 已知问题附录**（**默认**） | 入门教程 / 流程指南 | 1000 字 happy path + 400 字社区报告附录 |
| **B：大幅扩展社区坑搜索**（Money Hook 推荐） | 商业价值高 / 选型对比 | 主线 + 5-10 条社区坑深度展开 |
| **C：纯 Happy Path 短文**（不推荐） | 日常轻量 / 临时记录 | 仅 800 词左右 |

**决策点**：初稿 §0 搜索结果出来后，AI 根据"发现社区坑的数量 + 数量"建议用户选 A/B/C。

---

## 📋 附 B：截图标注格式（固定模板）

```markdown
📸 **截图标注位**（步骤 N）：
- **位置**：[具体页面 / 设置项 / 区域]
- **脱敏要求**：[打码邮箱 / 隐藏 4 字段 / 高亮目标区域]
- **文件命名**：`step-N-描述.png`
```

---

## 📋 附 C：联盟链接预留格式（固定模板）

```markdown
> 📎 **【联盟-占位 platform】** 待第二版确定
> 推荐用语模板（按 README §五-3 双向互惠）：
> "I use {platform} for my own {use case}. If you sign up via my link,
> you get {benefit}, and I earn a small commission at no extra cost to you."
> 链接变量：`{{ ref "data/affiliates.toml#platform" }}`
```

---

## 📋 附 D：commit 边界总览

| 阶段 | commit 前缀 | push 边界 |
|---|---|---|
| 初稿（中文） | `[draft] <topic>` | hold 等 ack |
| 第二版（中文） | `[zh-final] <topic>` | hold 等 ack |
| 英文版 | （无前缀，最终版）| hold 等 ack |

**所有 commit 都按 CLAUDE.md §6「git push 永远等 ack」规则**。

---

## 📋 附 E：D4 教训（写在最显眼位置防止再犯）

> **D4 越界 commit `4b8a8ea` 复盘**：
>
> AI 在该 commit 中"代笔"了 1787 词英文 troubleshooting 长文，包含：
> - "I went through this debugging marathon"
> - "Trap 1: build cache bleed — after that one-line change, I have not seen a leak in six weeks"
> - "Trap 2: HUGO_VERSION race condition cost me an entire evening"
>
> **全部是虚构的 first-hand 经验**。该 commit 已被 `bc9a369` 撤销。
>
> **核心错误**：AI 不应该伪装有 first-hand experience。这是 Google HCU 直接打击的 AI 内容农场模式。
>
> **本 SOP 存在的全部意义**：防止 D4 错误重演。

---

## 📋 附 F：题目库格式（`docs/archive/topic-pool-2026-08-27-archive.md` 待创建）

```markdown
## 候选：<标题>
- **来源讨论**：[YYYY-MM-DD 会话链接或要点]
- **目标关键词**：[3-5 个]
- **预计字数**：[800-1500]
- **分类**：[Static-Site / Remote-Payment / Side-Project]
- **联盟预留**：[是/否 + 平台]
- **AI 推荐理由**：[什么时候优先推这篇]
- **状态**：[待选 / 推荐中 / 已完成]
```