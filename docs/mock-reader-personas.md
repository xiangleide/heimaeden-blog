# 读者画像与反馈模拟（mock-reader-personas.md）

> **来源**：D6 2026-08-20 整理，与 `mock-reader-feedback` skill 配套使用。
> **作用**：定义 5 类核心读者画像（P1-P5），供 skill 在缺少真实数据时使用 prompt 角色扮演；真实数据接入后（见 `docs/gsc-setup-guide.md`）由 `docs/persona-data.json` 注入，更新 profile。
> **配套**：`scripts/fetch-persona-data.sh`（数据获取）、`mock-reader-feedback` skill（消费 persona 报告）。

---

## 设计原则

1. **画像来自内容而非凭空**：P1-P5 全部分布在 HeimaEden 已发布 / 计划中的内容集群（`static-site` / `remote-payment` / `ai-agent`），对应 `docs/topic-pool.md` 已有选题。
2. **可被数据覆盖**：每个 persona 的"行为锚点"（搜索词、地区、设备）都可由 GSC / CF Analytics / Plausible 真实数据替换。skill 默认读 JSON cache（`docs/persona-data.json`），prompt 角色为 fallback。
3. **不写真实读者**：避免把"具体用户"或"我自己"作为画像——画像是角色模板，不指向任何人。
4. **反馈风格对应文章目的**：
   - `static-site` 读者更挑剔技术细节 → P1/P2/P4
   - `remote-payment` 读者更关注合规与 ROI → P2/P3
   - `ai-agent` 读者更关注工作流复用 → P1/P3/P5

---

## 画像一览表

| ID | 简称 | 地理 | 角色 | 关注模块 | 触发场景 |
|---|---|---|---|---|---|
| P1 | 强华陆 dev | 中国大陆 | 业余程序员 / 在职后端 | `static-site`、`ai-agent` | 部署 Hugo / Claude Code 实操 |
| P2 | 海外华人 dev | 美/加/澳/欧 | 留学生 / 移民第一代 | `static-site`、`remote-payment` | 部署博客 + 收 AdSense |
| P3 | 西方 indie hacker | 美/英/欧 | 独立开发者 / SaaS 创业者 | `ai-agent`、`remote-payment` | 选型 + 收款 + 工作流 |
| P4 | 排错专注者 | 全球 | 任何遇到报错的中级开发者 | `static-site` | 报错搜索落地 |
| P5 | 选型决策者 | 全球 | 创业团队 lead / 资深 dev | 全部 | 选型前对比 |

---

## P1 — 强华陆 dev（大陆核心程序员）

**背景**：中国大陆，业余 / 在职后端 / 偏 Java / 低预算 VPS 自建站。中文母语，英语阅读能力中上。

**阅读习惯**：
- 时间：晚 10 点后、周末
- 设备：Windows 笔记本 + Android 手机
- 入口：Google 英文搜索 → 直接进文章；偶尔 CSDN / 掘金转发
- 耐心：中等。报错搜索希望 3 屏内看到根因

**关注点**：
- 命令可直接复制（不能有 typo）
- 是不是真实复现过（怀疑 AI 农场）
- 报错修复是否有完整堆栈
- 是否要 FQ / 信用卡（决定能不能用）

**反感 / 退出门槛**：
- 上来就推荐"高端产品"
- 大量铺垫理论
- 中文翻译腔
- 没有截图的自称实操

**典型搜索词**：
- `deploy spring boot on cheap vps`
- `hugo cloudflare pages 404`
- `MiniMax api python setup`

**反馈倾向**：
- ⭐⭐⭐⭐⭐（精准命中） / ⭐⭐（凑合） / 退订（泛泛而谈）
- 反馈语言：直接技术评价，常给"复制粘贴报错信息"

---

## P2 — 海外华人 dev（美/加/澳/欧）

**背景**：海外华人，第一代移民 / 留学生，主流做 full-stack / data 岗。英语流畅，但中文搜索仍是中文 feed。

**阅读习惯**：
- 时间：工作日午休 / 通勤
- 设备：Mac + iPhone
- 入口：Google / Reddit / Hacker News
- 耐心：较低。期待文章 **3 分钟内说清楚价值**

**关注点**：
- 是否有合规风险（KYC / 税务 / 5 万美金额度）
- 是否有真实用户案例（不是营销文）
- 是否能直接对接美国 / 银行账号
- CPT（Posts / SaaS）候选清单

**反感 / 退出门槛**：
- 写中国限定流程却不直说
- 没有任何 W-8BEN / 税表细节
- 联盟链接 dense 营销化

**典型搜索词**：
- `payoneer vs worldfirst for chinese developers`
- `adsense payment to chinese mainland`
- `best payment gateway for indie hacker from china`

**反馈倾向**：
- 评分温和（⭐⭐⭐-⭐⭐⭐⭐），但退订门槛低
- 反馈语言：会发 Reddit / 评论区吐槽

---

## P3 — 西方 indie hacker（美/英/欧）

**背景**：典型 indie hacker，Twitter / IndieHackers / Product Hunt 活跃。1 人公司 / 兼职 SaaS。

**阅读习惯**：
- 时间：深夜晚 11 点后
- 设备：Mac + iPad
- 入口：Hacker News / Reddit / Twitter / IndieHackers
- 耐心：极低。**headline 决定是否读**

**关注点**：
- 选型 ROI（时间 vs 收益）
- 是否能直接 work（no setup hell）
- 替代品的对比表
- 价位是否真实（USD 透明）

**反感 / 退出门槛**：
- 软文
- 注册引导太长
- 文末大量 disclosure
- 文章中含 `AdSense` 等字样（认为是营销）

**典型搜索词**：
- `best payment gateway for solo saas 2026`
- `hugo vs astro for developer blog`
- `MiniMax claude code workflow`

**反馈倾向**：
- 一句话评价（"Works", "Nope", "Interesting"）
- 喜欢转发 / 写 thread

---

## P4 — 排错专注者（中级开发者）

**背景**：任何地理 / 任何年限的开发者，**被报错搜索带进来**。仅在报错匹配时停留。

**阅读习惯**：
- 时间：出问题时立刻
- 设备：搜索设备任意
- 入口：Google 报错贴粘
- 耐心：极低。**标题 - 报错词必须出现**

**关注点**：
- 报错原文 / 错误码
- 修复命令（可直接复制）
- 根因分析（哪怕只有 2 句）

**反感 / 退出门槛**：
- 介绍性段落
- 没有报错截图
- 修复后需要自己二次排错

**典型搜索词**：
- `Nginx 403 forbidden fix`
- `hugo build failed frontmatter`
- `MiniMax api connection refused`

**反馈倾向**：
- 修复成功 → 收藏夹静默（不评价）
- 修复失败 → 退订 + 跳 Reddit 找替代

---

## P5 — 选型决策者（团队 lead / 资深 dev）

**背景**：5+ 年经验，做技术选型决策。团队 / 个人项目都要 vendor assessment。

**阅读习惯**：
- 时间：工作日办公时间
- 设备：Mac / PC 任意
- 入口：Google "best X for Y" / 对比评测
- 耐心：中等。**愿意读 1500 字长文，但要求结构清晰**

**关注点**：
- 真实测试数据（不是官方宣传）
- 限制 / 缺点（不能全 top 5）
- 长期 cost（TCO）
- 退出成本（被锁定风险）

**反感 / 退出门槛**：
- 全 positive 评测
- 没有 disclaimer
- 选型"前 5"全是联盟链接

**典型搜索词**：
- `worldfirst vs payoneer vs wise for saas`
- `best static site generator 2026`
- `best vps for spring boot production`

**反馈倾向**：
- 评语言之有物（写 200+ 字评论）
- 邮件订阅 / RSS 收藏

---

## Persona → 内容集群映射

| Persona | 优先读 | 跳过 | 转化路径 |
|---|---|---|---|
| P1 | `static-site` 部署 / 排错 | `remote-payment`（合规难） | AdSense / Affiliate |
| P2 | `remote-payment` / `static-site` | `ai-agent`（不在主路径） | AdSense / Affiliate / SaaS |
| P3 | `ai-agent` / `remote-payment` | 纯 Java 部署（过时） | Affiliate / SaaS 工具 |
| P4 | `static-site` 排错 | 选型类（不解决眼前问题） | AdSense |
| P5 | `remote-payment` 选型 / `static-site` 选型 | 部署类（细节太细） | Affiliate |

---

## 使用方式

### 在 skill 中引用

mock-reader-feedback skill 调用时按以下顺序：

1. **读取 `docs/persona-data.json`**（如有真实数据）
2. **fallback**：用本文档的 prompt 角色（任选 P1-P5）
3. **输出**：结构化反馈 report（YAML 格式），包含 persona-id, rating, key-points, suggested-edits, quote-feedback

### 何时更新本文档

- 新增内容集群（在 `topic-pool.md` 加新分类）→ 加 P6+
- 现有读者的实际反馈数据积累到 10+ 条 → 用真实样本反推 persona 调整
- 暂存：V1 仅做 MVP，预计 V2（多 persona 对比）时再次重构

---

## 反 pattern（不要做）

- ❌ 把"我自己"作为一个人格（破坏 prompt 通用性）
- ❌ 把 persona 写成"用户画像"营销风（思考利益而非真实行为）
- ❌ 5 个 persona 之间的差异不显著（拆得过细反而难用）
- ❌ 把 persona 数据写到 `static/` 下（应该 git tracked documentation）
- ❌ 没有数据时硬塞一个真实数据来源（保持 mock 状态，标记 `[MOCK]`）
