# Cover Prompt v2 — hugo-cloudflare-pages-pitfalls（A1）

> **目标文章**：`content/posts/static-site/hugo-cloudflare-pages-pitfalls.md`（初次发布 D3，当前 `[correction] be430eb` + `[polish] f8c5aef` 已校准根因 + 视觉净化）
>
> **风格基调**：技术蓝图 + dev ops dashboard 风（部署管线 + 故障断点）
>
> **版本**：v2（替换 v1 捕兽夹方案）—— 首次落地 v1 2026-08-17 / 866eaf2；v2 落地 2026-08-19
>
> **v2 变更理由**：用户反馈 v1 不合适（捕兽夹抽象度过高、不面向技术人员的运维审美、不显式总结文章内容），改为中文 prompt + 文章内容驱动的部署管线蓝图

---

## 一、目标文章内容总结

文章主题：**Hugo 静态站点 + Cloudflare Pages 部署流程中的 7 个隐藏陷阱**。

7 个陷阱（按部署时序）：

| # | 陷阱标题 | 部署阶段 | 故障类别 |
|---|---|---|---|
| 1 | Cloudflare Dashboard UI 混淆（Workers vs Pages） | 项目初始化 | 平台选择错 |
| 2 | `npm error could not determine executable to run` | 构建配置 | 运行时找不到二进制 |
| 3 | `unmarshal failed: toml: expected character =` | front matter 撰写 | 语法错误 |
| 4 | 在线首页完全为空 | 部署上线 | 时区/路由导致 hidden post |
| 5 | `page reference "X" is ambiguous` | 导航配置 | 命名冲突导致死循环 |
| 6 | Root-Level 404 + localhost 跳转循环 | 法律页迁移 | 路径斜杠漏写 |
| 7 | 主题切换（Dark Mode）失效 | 主题定制 | 键名错 + SRI 配置 |

**文章核心叙事**：一次完整部署过程中，**从 UI 入口 → 构建配置 → 内容撰写 → 上线验证 → 导航 → 法律页迁移 → 主题定制**七个环节，每个环节踩一个坑，并精准定位修复。

---

## 二、视觉概念设计意图（v2 替换 v1）

| 视觉元素 | 对应文章隐喻 |
|---|---|
| 一条横向发光的"**部署管线**"贯穿画面 | Hugo + Cloudflare Pages 部署流程（7 个 trap 在这条流上发生） |
| **三个发光节点**：代码仓库 / 构建 / 上线网站 | 部署流程的三个关键阶段（对应文章 "初始化 / 构建配置 / 上线验证" 主线） |
| 沿管线均匀分布 **7 个橙红色闪电断点** | 7 个隐藏陷阱（"陷阱"直接可视化，闪电 = dev 圈熟悉的 fault 符号） |
| 编号 **01-07** 小标签 | dev ops 风格的可定位 trap 标识（仿 PagerDuty / Datadog dashboard） |
| **坐标网格 + 模糊代码片段**背景 | 工程蓝图 + 终端环境氛围 |
| **深蓝黑底 + 青色主线 + 橙红断点** | dev ops dashboard 风（Slack / PagerDuty / Datadog 同款配色） |

---

## 三、完整 Prompt（中文 v2 · 可直接复制）

```text
极简科技工程蓝图风格，主题为"静态网站部署故障诊断图"。

中央主体（占画面 70%）：一条横向发光的"部署管线"，从左至右贯穿画面，包含三个发光节点——最左侧"代码仓库"（抽象的代码方块）、中部"构建流水线"（连续发光线段）、最右侧"已上线网站"（抽象的浏览器窗框）。管线呈淡青色辉光，节点用淡青色描边圆角矩形表示。

沿管线均匀分布 7 个显眼的"故障断点"标记，每个断点由一个橙红色闪电符号构成，周围环绕细微的故障光晕。每个闪电上方悬浮一个小型的诊断编号标签（仅含抽象的 01 至 07 两位数字风格），以等距排列从左到右沿管线依次呈现。

背景：深蓝黑色基调（#0a0e1a），覆盖半透明的工程蓝图坐标网格（淡青色细线 #1a2a3a），叠加模糊处理的部署日志代码片段（仅作为环境氛围层，不可清晰阅读），整体形成"工程师工作台上的故障定位作战图"氛围。

色调锁定：底色 #0a0e1a 深蓝黑、青色主线 #4dd0e1、橙红色闪电 #ff5722、少量暖白高光 #f5f5f5。

风格关键词：技术蓝图、运维作战地图、调试战情室、dev ops dashboard、故障定位视图、电路原理图。

技术参数：16:9 宽屏（1440×810 最小尺寸），无人物、无可读文字、无装饰边框、构图极简留白。

负面提示词：避免人物面孔、避免手绘水彩感、避免装饰边框、避免彩虹色霓虹、避免多焦点、避免过度装饰、避免现实摄影感、避免大面积红色覆盖（仅 7 个闪电使用橙红）。
```

---

## 四、模型特定参数

| 模型 | 附加参数 | 备注 |
|---|---|---|
| **Midjourney v6+** | `--ar 16:9 --style raw --s 80 --q 2` | `raw` 保持极简；stylize=80 让中文 prompt 更精确 |
| **DALL-E 3** | 选 1792×1024 尺寸；style `vivid` 出饱和蓝色调 | 中文 prompt 直接贴全文 |
| **Stable Diffusion XL** | `--ar 16:9`，Tech / Blueprint 风格 LoRA（如 `BlueprintArt` / `TechDiagram`），配 ControlNet 锁色块 | 适合自托管 |
| **Flux.1 / Recraft v3** | 自然语言直接用；强调 "engineering blueprint" | 风格最贴近 |

**风格微调关键词**：
- 更"冷静"：把 `dev ops dashboard` 改成 `minimalist tech diagram`
- 更"工业"：把节点从圆角矩形改成六角形（HUD 风）
- 更"湿润"（更立体）：MJ 加 `--style scenic` 或 SDXL 配 `SciFiStyle` LoRA

---

## 五、落地路径（与 v1 保持一致）

| 维度 | 值 |
|---|---|
| **物理路径** | `assets/images/static-site/hugo-cloudflare-pages-pitfalls/cover.jpg` |
| **front matter 引用** | `static-site/hugo-cloudflare-pages-pitfalls/cover.jpg` |
| **目录命名** | kebab-case，沿用 article filename |
| **格式** | JPG（封面图统一 JPG） |
| **尺寸上限** | 1440px（per CLAUDE.md §3.3.2） |

---

## 六、Alt 文本建议（欧美独站博客克制风格）

**首选**：
> A blueprint illustration of a glowing deployment pipeline with three nodes and seven red lightning-shaped fault markers along the line, evoking hidden pitfalls in static site deployment.

**备选**：
> A minimalist dev ops dashboard view: a horizontal cyan pipeline with three glowing nodes and seven orange-red lightning fault markers numbered 01 to 07.

---

## 七、Front Matter 拼接示例

```toml
[cover]
    image = "static-site/hugo-cloudflare-pages-pitfalls/cover.jpg"
    alt = "A blueprint illustration of a glowing deployment pipeline with three nodes and seven red lightning-shaped fault markers along the line, evoking hidden pitfalls in static site deployment."
```

插入位置：tags 之后、showToc 之前（与 A2/A3 当前 front matter 风格保持一致）。

---

## 八、生成后落档流程 Checklist

按顺序执行（任一步失败都先停下，**不要直接 commit**）：

- [ ] **保存原始 PNG/JPG** 到 `~/Downloads/cover-raw.png`（任意暂存路径）
- [ ] **跑优化**：`./scripts/optimize-image.sh <raw.png>`（自动降采样到 1440px ceiling）
- [ ] **移动到物理路径**：优化后的文件落到 `assets/images/static-site/hugo-cloudflare-pages-pitfalls/cover.jpg`
- [ ] **更新 A1 front matter**：加 `[cover]` 块（image + alt，按本文件 §七）
- [ ] **跑 lint**：`./scripts/lint-post.sh content/posts/static-site/hugo-cloudflare-pages-pitfalls.md`
- [ ] **跑 hugo build**：`hugo --gc`（0 errors 才算合格）
- [ ] **commit prefix**：`[asset]`（表示"补 cover 资产"）
- [ ] **HOLD push**（per CLAUDE.md §6 所有 commit 等用户 ack）

---

## 九、复用备注（蓝图风变体表）

写姊妹篇（Cloudflare Pages 其他主题）时，**沿用本文件的"管线 + 故障断点"叙事骨架**，按主题替换主线语义：

| 姊妹篇主题 | 主线变体 | 7 trap 替换主题 |
|---|---|---|
| Worker 路由配置 | "request → routing → response" | routing edge cases |
| CDN 缓存策略 | "origin → cache → edge → user" | cache invalidation pitfalls |
| Cloudflare R2 集成 | "upload → bucket → fetch" | object storage pitfalls |
| Access 鉴权 | "user → JWT → edge → origin" | auth pitfalls |
| Stream 视频 | "upload → encode → deliver" | video pipeline pitfalls |

⚠️ **数量 7 不要硬塞**：如果姊妹篇不是 7 个 trap，改用对应数字（5 / 10 / N）替换闪电数量即可。

---

## 附录 A · 设计取舍记录（v2 替换 v1 决策对照）

| 维度 | v1（捕兽夹）— 用户判定不合适 | v2（管线蓝图）— 现行 |
|---|---|---|
| 核心视觉 | 线框捕兽夹 + 7 红 LED | 发光部署管线 + 7 闪电断点 |
| 提示词语言 | 英文 | **中文**（用户明确要求） |
| 是否总结文章内容 | 弱（"陷阱"概念泛化对应） | **强**（管线 = 部署流程，断点 = 7 trap 编号 01-07） |
| 面向人群审美 | 抽象极客 cyberpunk | **dev ops dashboard 风**（Slack/PagerDuty/Datadog 同款，更贴 ops 圈） |
| 生动形象 | 几何抽象 | **流程具象**（节点 + 流向 + 断点位置） |
| 科技风格 | cyberpunk 暗调紫黑 | **工程蓝图亮调**（坐标网格 + 节点连接 + 编号标签） |
| 主色调 | 紫黑 + 单绿 + 红 | **蓝黑 + 青色主线 + 橙红断点**（更"故障定位地图"语义） |
| 保留项 | 7 数量显式表达 | 同上，且**新增编号 01-07 进一步强化** |
| 新增项 | — | **三个节点**（仓库/构建/上线）显式对应部署三阶段 |

---

## 附录 B · 版本演进

| 版本 | commit | 日期 | 方案 | 用户反馈 |
|---|---|---|---|---|
| v1 | `866eaf2` | 2026-08-17 | 极简赛博朋克捕兽夹 × 7 LED | **不合适**：抽象度过高、不显式总结文章、不面向 dev ops 审美 |
| v2 | （待 commit） | 2026-08-19 | 中文 dev ops 部署管线蓝图 + 7 闪电断点 | （待确认） |

---

## 附录 C · 为什么不沿用 v1 一些组件

| v1 元素 | v2 是否保留 | 理由 |
|---|---|---|
| `<>` HTML 标签 ghost 框架 | **删除** | v1 太抢戏，且没显式表达"Hugo"——v2 用"代码仓库节点"更直接 |
| 暗紫黑色背景 | **替换为深蓝黑** | dev ops dashboard 调色板偏蓝（Slack/Linear/Datadog 同款），紫黑太 cyberpunk |
| 7 LED 排布 | **替换为 7 闪电断点** | LED 太抽象（与"trap"无语义关联），闪电符号在 dev 圈直指 fault |
| 单绿色霓虹 | **替换为青色 + 橙红双色** | v1 单绿太"安静"；v2 青色（healthy flow）+ 橙红（fault point）符合 ops 仪表盘对比配色 |
| 远处 monospace 字符流 | **保留为模糊代码片段层** | 仍然贡献"终端环境氛围"——但加坐标网格丰富背景层次 |
| 底部 cyan 边缘线 | **删除** | v2 把 cyan 作为"主线"贯穿整张图，不再单点 cyan 边缘线 |