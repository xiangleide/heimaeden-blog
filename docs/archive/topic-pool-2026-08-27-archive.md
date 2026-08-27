# 选题池（topic-pool.md）

> **配套**：`docs/article-writing-workflow.md` §0 与 §附录 F
> **首次建立**：2026-08-16（D5）
> **协作模式**：AI 推荐候选 → 用户确认 → 状态推进（待选 → 推荐中 → 初稿）
> **分类约定**（对齐 `think-strategy.md` §三-5 四集群）：
> - **Static-Site**：VPS / Hugo / Cloudflare Pages / Java 部署 / 排错
> - **AI-Agent**：Claude Code / MiniMax / MCP 实操
> - **Remote-Payment**：大陆个人开发者境外收款
> - **Side-Project**：MVP / SaaS / Indie 工具
>
> **📐 D16 字数分档硬约束（2026-08-27）**：每条选题"预计字数"必须 ≤ `writing-prompts.md` 一、速查表分档上限（A ≤1200 / B ≤1800 / C ≤2200 / D+E ≤2500）。**存量文章不变**，所有新选题严格执行。唯一例外：`ai-agent/claude-code-editorial-pipeline`（4064 词），详见 `article-writing-workflow.md` §5.2.1。

---

## 📊 全局状态追踪

### Money Hook 密度（**AdSense 门槛 = ≥15 篇长文**）

| 类别 | 已完成 | 待选 backlog | 缺口 |
|---|---|---|---|
| Static-Site | 2 | 20 | **10** |
| AI-Agent | 0 | 3 | **3** |
| Remote-Payment | 1 | 6 | **2** |
| Side-Project | 0 | 4 | **2** |
| **合计** | **3** | **35** | **15** |

> **D5 更新**：新增 Java-Advanced 子集群（J1-J6）合并入 Static-Site，backlog +6

### 类型比例（目标: 排错 : 部署 : 选型 = 4 : 4 : 2）

| 类别 | 排错 | 部署 | 选型 | 备注 |
|---|---|---|---|---|
| Static-Site | 1 | 1 | 3 | B1 优先排错补齐；Java-Advanced 待 J1-J3 上线后回填（预计排错 +1, 部署 +2）；D6 新增 S10-S12 三篇选型（P5 反馈催生），目标比例从 4:4:2 临时偏 2:2:3 |
| AI-Agent | 0 | 0 | 0 | 全空白 |
| Remote-Payment | 0 | 1 | 0 | 需扩展 |
| Side-Project | 0 | 0 | 0 | 全空白 |

### 最近 3 篇（**避免连续同话题**）

1. `remote-payment/beginners-practical-guide`（2026-08-15）
2. `static-site/static-blog-setup-guide`（2026-08-13）
3. `static-site/hugo-cloudflare-pages-pitfalls`（2026-08-13）

⚠️ **下次选题约束**：连续 2 篇静态站 → B1 推荐中已选 static-site 排错类，**B2 应切换 AI-Agent 或 Remote-Payment**。

> 🆕 **D6 进度（2026-08-20）**：AI-Agent 集群首篇已 commit `e2dde89`（中文版 + 4 张实操截图），等 Task #4 [zh-final] 完成后由 Task #5 翻译并 push 即解锁。届时最近 3 篇会有 AI-Agent，**B3 之后**的下一次选题约束重新从 "避免连续同话题" 开始。

---

## ✅ 已完成（Published）

### A1. Hugo + Cloudflare Pages 7 个隐形大坑与终极修复
- **来源讨论**：2026-08-13 首发踩坑长文
- **目标关键词**：hugo cloudflare pages deployment pitfall, HUGO_VERSION race condition, theme toggle not working
- **实际字数**：1,407 词
- **分类**：Static-Site（排错类）
- **联盟预留**：否（排错类不道德植入）
- **AI 推荐理由**：高实操密度 + 多截图 + EEAT 强，AdSense 友好
- **状态**：✅ 已发布（commit `7f1b80d`）

### A2. Static Blog Setup Guide
- **来源讨论**：2026-08-13 Hugo 入门
- **目标关键词**：hugo static site setup, papermod theme install, cloudflare pages git deploy
- **实际字数**：~1,300 词 ✅ **达 ≥800 词门槛**（D5 第二次英译扩容）
- **分类**：Static-Site（部署类）
- **联盟预留**：否
- **AI 推荐理由**：入门流量大；D5 翻译后字数充足
- **状态**：✅ 已发布英文版（commit `b751bdb`）

### A3. Remote Payment Beginners Practical Guide
- **来源讨论**：2026-08-15 `remote-payment/` 子目录首发
- **目标关键词**：overseas domain purchase, cross-border payment Chinese developer, PayPal UnionPay debit card
- **实际字数**：~1,500 词 ✅ **达 ≥800 词门槛**（D5 第二次英译扩容）
- **分类**：Remote-Payment（部署/概述类）
- **联盟预留**：是（Payoneer / Wise / PingPong — 占位已留，第二版填实）
- **AI 推荐理由**：集群首发；D5 翻译后字数充足
- **状态**：✅ 已发布英文版（commit `b751bdb`）

---

## 🎯 推荐中（Next Pick — B1 候选）

### B1-1. Cloudflare Pages Preview Branches: 完整 feature 分支 → preview URL → merge 实战
- **来源讨论**：2026-08-15 commit `4b8a8ea`（D4 越界被 `bc9a369` 撤销留下的选题洞）
- **目标关键词**：cloudflare pages preview branches, cloudflare pages git branch deploy, feature branch preview URL
- **预计字数**：1,200-1,500
- **分类**：Static-Site（部署类）
- **联盟预留**：否
- **AI 推荐理由**：D4 回滚留下的必补选题；M4.5 阶段 γ C2（TCM 第 16 步从直推 main 改 preview URL 流程）直接依赖本文上线
- **状态**：🎯 **推荐中（B1 候选 1 — 默认走）**
- ⚠️ **D4 红色警戒**：严禁 AI 代笔 first-person 调试经验；初稿必须 step-by-step 操作清单；翻译阶段仅字面对应

### B1-2. Hugo Build Failed: frontmatter YAML parse error 完全排查
- **来源讨论**：`think-templates.md` #14 高优排错选题
- **目标关键词**：hugo frontmatter error, hugo yaml parse error, hugo toml syntax
- **预计字数**：800-1,200
- **分类**：Static-Site（排错类）
- **联盟预留**：否
- **AI 推荐理由**：与 A1 同源排错但切入点不同（A1 偏 CF Pages，A2 偏 Hugo 语法），共筑排错集群
- **状态**：🎯 推荐中（B1 候选 2 — 备选）

---

## 📋 待选 Backlog（按优先级排序）

### Static-Site / Build（**缺口 7 篇**）

#### S1. Hugo image path broken after publish to Cloudflare Pages solution
- **来源**：`think-templates.md` #24
- **关键词**：hugo image not showing, hugo static/images path, cloudflare pages asset 404
- **预计字数**：800-1,000
- **分类**：Static-Site（排错类）
- **联盟预留**：否
- **AI 推荐理由**：高频报错 + 命中 CLAUDE.md §3.3 硬约束（路径 `/images/` 前缀）— 可作硬约束示范文
- **状态**：待选 · 优先级 ★★★

#### S2. Cloudflare ERR_TOO_MANY_REDIRECTS custom domain fix for Hugo blog
- **来源**：`think-templates.md` #21
- **关键词**：cloudflare err_too_many_redirects, hugo custom domain ssl, cloudflare flexible ssl redirect loop
- **预计字数**：800-1,000
- **分类**：Static-Site（排错类）
- **联盟预留**：否
- **AI 推荐理由**：CF + Hugo 高频报错，搜量稳定，竞品文档不完整
- **状态**：待选 · 优先级 ★★★

#### S3. Cloudflare Pages deployment failed out-of-memory for Hugo site
- **来源**：`think-templates.md` #15
- **关键词**：cloudflare pages out of memory, hugo build oom, cloudflare pages build limit
- **预计字数**：800-1,000
- **分类**：Static-Site（排错类）
- **联盟预留**：否
- **AI 推荐理由**：CF Pages 免费层 OOM 是常见卡点，专文稀缺
- **状态**：待选 · 优先级 ★★★

#### S4. Deploy simple Java web filter project on VPS for learning purpose
- **来源**：`think-templates.md` #8
- **关键词**：deploy spring boot vps, java web app vps tutorial, java tomcat vps deploy
- **预计字数**：1,200-1,500
- **分类**：Static-Site（部署类）
- **联盟预留**：是（Hetzner / DigitalOcean — VPS 选型联盟）
- **AI 推荐理由**：Java 部署是 think-strategy §三-1 流量底盘主力；VPS 联盟转化最佳
- **状态**：待选 · 优先级 ★★

#### S5. How to set up SSH key login for cheap VPS disable password login
- **来源**：`think-templates.md` #9
- **关键词**：ssh key login vps, disable password ssh, ssh keygen tutorial
- **预计字数**：800-1,000
- **分类**：Static-Site（部署类）
- **联盟预留**：是（VPS 联盟）
- **AI 推荐理由**：硬刚需教程，搜量稳定，新人必经
- **状态**：待选 · 优先级 ★★

#### S6. Set up Nginx reverse proxy on budget VPS for Java web project
- **来源**：`think-templates.md` #6
- **关键词**：nginx reverse proxy java, nginx proxy_pass spring boot, vps nginx config
- **预计字数**：1,000-1,300
- **分类**：Static-Site（部署类）
- **联盟预留**：是（VPS 联盟）
- **AI 推荐理由**：Java 部署链路必备组件，与 S4 共筑完整 Java VPS 系列
- **状态**：待选 · 优先级 ★★

#### S7. VPS SSH connection timeout beginner troubleshooting steps
- **来源**：`think-templates.md` #16
- **关键词**：ssh connection timeout, vps ssh refused, ssh port 22 blocked
- **预计字数**：800-1,000
- **分类**：Static-Site（排错类）
- **联盟预留**：否
- **AI 推荐理由**：VPS 新人最大入门门槛，排错类高广告 RPM
- **状态**：待选 · 优先级 ★★

#### S8. Set-up cron job on VPS for automatic blog content backup
- **来源**：`think-templates.md` #12
- **关键词**：vps cron job backup, automatic blog backup linux, hugo backup script
- **预计字数**：800-1,000
- **分类**：Static-Site（部署类）
- **联盟预留**：否
- **AI 推荐理由**：博客作者刚需，差异化角度（备份而非部署）
- **状态**：待选 · 优先级 ★

#### S9. Cloudflare Pages vs cheap VPS for hosting static Hugo developer blog comparison
- **来源**：`think-templates.md` #27
- **关键词**：cloudflare pages vs vps hugo, static site hosting comparison, hugo hosting choice
- **预计字数**：1,200-1,500
- **分类**：Static-Site（选型类）
- **联盟预留**：是（Hetzner / DO / Cloudflare Pages — 三方联盟）
- **AI 推荐理由**：**Money Hook 候选**；你本人有真实切换体验（CF Pages 是你最终选择），可作 EEAT 强文
- **状态**：待选 · 优先级 ★★★（Money Hook 高潜）

#### S10. Hugo vs Astro vs Next.js for team blog 2026: feature parity and cold-start TCO
- **来源**：2026-08-20 mock-reader-feedback P5 反馈催生（docs/feedback/hugo-cloudflare-pages-pitfalls-P5.md）
- **关键词**：hugo vs astro vs nextjs, static site generator 2026, cold start tco team blog, astro vs nextjs for blog
- **预计字数**：1,400-1,800（**B 档硬上限 1800**，per `writing-prompts.md` Prompt B · D16 已下调）
- **分类**：Static-Site（选型类）
- **联盟预留**：是（Hetzner / DO / CF Pages / Vercel — 多 hosting 联盟，按平台属性分）
- **AI 推荐理由**：**Money Hook 候选**；P5 选型决策者读完 A1 反馈："缺 2026 选型对比" + 排名 `best static site generator 2026` 是 P5 top search query；3 个 generator 全对比可填空白区
- **状态**：待选 · 优先级 ★★★（Money Hook 高潜 · D6 P5 反馈）

#### S11. Cloudflare Pages vs Vercel vs Netlify for Hugo: exit cost matrix
- **来源**：2026-08-20 mock-reader-feedback P5 反馈催生（docs/feedback/hugo-cloudflare-pages-pitfalls-P5.md）
- **关键词**：cloudflare pages vs vercel vs netlify, hugo hosting exit cost, static site platform migration
- **预计字数**：1,200-1,500
- **分类**：Static-Site（选型类）
- **联盟预留**：是（CF Pages / Vercel / Netlify — 三方平台联盟）
- **AI 推荐理由**：**Money Hook 候选**；P5 反馈："缺退出成本量化"；是 S9 的升级版（3 个 hosting 平台 vs S9 仅 2 个）；与 S10 形成"工具层 + 平台层"双选型
- **状态**：待选 · 优先级 ★★★（Money Hook 高潜 · D6 P5 反馈）

#### S12. Self-hosted Hugo on $5 VPS vs Cloudflare Pages: when to flip back
- **来源**：2026-08-20 mock-reader-feedback P5 反馈催生
- **关键词**：self hosted hugo vps, cloudflare pages vs vps reverse, hugo hosting migration cost
- **预计字数**：1,000-1,300
- **分类**：Static-Site（选型类）
- **联盟预留**：是（VPS / CF Pages — 双向联盟）
- **AI 推荐理由**：S9/S11 的反向视角（已用 CF Pages 的人什么时候需要回到 VPS）；差异化角度——流量超 100k req/day 或定制 build pipeline 时的迁移阈值；P5 "real-world flipping criterion" 关键词匹配
- **状态**：待选 · 优先级 ★★（D6 P5 反馈）

#### S13. Cloudflare Workers vs Pages: when each wins (6-dimension comparison)
- **来源**：本次会话 D14 决策（B 方案）+ A1 `hugo-cloudflare-pages-pitfalls` §Trap 1 浅讲 UI 误导衍生
- **关键词**：cloudflare workers vs pages, when to use cloudflare workers, when to use cloudflare pages, cloudflare hosting choice 2026
- **预计字数**：1,400
- **分类**：Static-Site（选型类）
- **联盟预留**：是（CF Pages / Workers 双向联盟，按场景分）
- **AI 推荐理由**：A1 §Trap 1 只讲 UI 误导，未深入"我该用哪个 CF 产品"；本文深挖 6 维度选型矩阵（适用场景 / 部署复杂度 / 计费模型 / 配额 / 迁移成本 / Cold Start）；CF 官方文档分散，无一站式对比；与 S9 / S10 / S11 形成"工具层 + 平台层"全选型矩阵闭环；P5 选型决策者 top search query "cloudflare workers vs pages 2026"
- **prompt_type**：B 方案对比（D12 SOP）
- **状态**：🎯 推荐中（D14 决策 · 用户决定先做）

#### S14. Hugo front matter complete guide: TOML vs YAML vs JSON
- **来源**：本次会话 D14 决策 + A1 `hugo-cloudflare-pages-pitfalls` §Trap 3 浅讲 unmarshal failed 衍生
- **关键词**：hugo front matter, hugo toml vs yaml vs json, hugo front matter error, hugo ++ syntax, hugo unmarshal failed
- **预计字数**：1,200
- **分类**：Static-Site（原理深挖类）
- **联盟预留**：否
- **AI 推荐理由**：A1 §Trap 3 只讲 "YAML 写 `:` 报错"；本文讲透三种语法对比 + Hugo 解析优先级 + 错误码全表 + YAML → TOML 迁移指南；用户亲历 + Hugo 官方文档分散在多个版本页；D12 SOP prompt_type D 原理深挖
- **prompt_type**：D 原理深挖（D12 SOP）
- **状态**：待选 · 优先级 ★★★（D14 入库）

#### S16. PaperMod dark mode toggle: a 48-hour debug story
- **来源**：本次会话 D14 决策 + A1 `hugo-cloudflare-pages-pitfalls` §Trap 7 衍生（叙事化改写）
- **关键词**：papermod dark mode not working, papermod theme toggle not responding, disableThemeToggle, papermod dark mode fix, papermod dark mode css
- **预计字数**：1,500
- **分类**：Static-Site（踩坑叙事类）
- **联盟预留**：否
- **AI 推荐理由**：A1 §Trap 7 是技术冷叙述（4 段并列 root cause）；本文改写为**第一人称 48 小时 debug 时间线叙事**（disableThemeToggle / SRI / minify / selector 4 个 false culprit + 1 个 real culprit，按时间顺序展开）；用户亲历 EEAT 强；D12 SOP prompt_type C 踩坑叙事；与 S14 D 原理深挖形成"叙事 + 原理"互补，覆盖同一主题不同维度
- **prompt_type**：C 踩坑叙事（D12 SOP）
- **状态**：待选 · 优先级 ★★★（D14 入库）

#### S17. Hugo URL resolution demystified: baseURL, relURL, absURL, and the trailing slash
- **来源**：本次会话 D14 决策 + A1 `hugo-cloudflare-pages-pitfalls` §Trap 6 浅讲"加前导斜杠"衍生
- **关键词**：hugo url resolution, hugo relurl vs absurl, hugo trailing slash, hugo baseurl, hugo url 404, hugo url localhost loop
- **预计字数**：1,200
- **分类**：Static-Site（原理深挖类）
- **联盟预留**：否
- **AI 推荐理由**：A1 §Trap 6 只讲"加前导斜杠"；本文讲透 Hugo 路径解析算法（absURL / relURL 差异 + 字符串拼接 vs Page Resource lookup）+ trailing slash 行为表 + PaperMod relativeURL 行为 + localhost 循环根因；D12 SOP prompt_type D 原理深挖
- **prompt_type**：D 原理深挖（D12 SOP）
- **状态**：待选 · 优先级 ★★★（D14 入库）

> **D14 决策注释（2026-08-25）**：用户决定**保留 A1 `hugo-cloudflare-pages-pitfalls` 长文作长尾综述 + E-E-A-T 资产**，**不按"7 trap 拆 7 篇"原思路**（拆分会触发 D12 SOP Scaled Content Abuse 红线：7 篇同 prompt_type A 纯排障 + 内容重复风险 + 原文 inbound link 损失）。替代策略：在 7 trap 基础上**深挖未讲透的角度**，新增 S13/S14/S16/S17 共 4 篇，每篇用独立 prompt_type（B/D/C/D），4 篇 3 种 prompt_type 混合合规。
> - **S15 留空 slot**——本次会话决策为"减到 4 篇"，留待 D15+ 按需按本文档 §「交叉验证落地决策」E2 行规则补位
> - **S18 已填（D17）**：基于 D10 事故复盘的 draft 暴露排错文。详见下方 S18 条目
> - **覆盖 gap**：S13/S14/S16/S17/S18 不与 topic-pool.md 现有 S1-S12 任何一条重复（关键词 + 主题双重独立）；与 S9/S10/S11/S12 选型类互补，与 S1-S3 排错类互补

#### S18. Hugo draft still showing after move to _drafts/: a 3-layer fallback trap
- **来源**：本次会话 D17 决策 + D10 事故复盘（README §6 D10）+ commit `581555b`
- **预计字数**：1,000-1,200（**A 档硬上限 1200**，per `writing-prompts.md` Prompt A · D16）
- **分类**：Static-Site（排错类）
- **联盟预留**：否（排错类不插联盟，per `article-writing-workflow.md` §1.3）
- **AI 推荐理由**：D10 事故（2026-08-21）暴露 Hugo 设计陷阱的 3 层叠加（`hugo --gc` 不清 public/ + dev server fallback + taxonomy 不 rebuild）；GitHub Issues / Hugo Discourse 搜不到完整答案；用户亲历 + commit hash + 当前 stale tags 残留（公开复盘）构成独家 EEAT；填补 S1-S3 之外的「dev workflow 排错」细分空白
- **prompt_type**：A 纯排错（D12 SOP）
- **状态**：🎯 **推荐中（D17 入库 · [draft] 已启）**

#### Java-Advanced 子集群（CRUD → Intermediate 进阶路径）— **新增 (2026-08-16 D5)**

> **战略意义**：用户 6 年 Java CRUD 经验，下一步实操升级路径；EEAT 独家壁垒（vs AI 农场站）
> **实操环境**：Hetzner CX22（€4/月 2 vCPU 4GB）单机可复现全部 demo
> **比例**：合并入 think-strategy §三-5 Static-Site 60% 底盘（不重算总比例）
> **首发节奏**：J1-J3 第一批上线；J4-J6 等第二批再开

##### J1. Spring Boot JVM heap tuning: Xms/Xmx + G1GC flags hands-on
- **来源讨论**：Baeldung GC tuning 指南 + dev.to 实战文 + 用户 6 年 CRUD 痛点
- **目标关键词**：spring boot jvm heap tuning, -Xms -Xmx flags spring boot, G1GC tuning hands-on, jvm flags cheatsheet for spring boot
- **预计字数**：1,200-1,500
- **分类**：Static-Site / Java-Advanced（部署 + 排错 mix）
- **联盟预留**：是（Hetzner — 部署测试用 VPS）
- **AI 推荐理由**：CRUD 进阶必学第一步；英文长尾"for CRUD developer"角度稀缺；Hetzner CX22 可复现
- **状态**：🎯 推荐中（B3 候选）

##### J2. HikariCP connection pool tuning for Spring Boot production
- **来源讨论**：HikariCP 官方 wiki + Brett Wooldridge 实践 + 联网 search 结果
- **目标关键词**：hikaricp spring boot tuning, hikaricp maximum-pool-size, hikaricp leak detection threshold, connection pool sizing formula
- **预计字数**：1,000-1,300
- **分类**：Static-Site / Java-Advanced（部署类）
- **联盟预留**：否
- **AI 推荐理由**：搜索结果验证为生产环境最大痛点之一；CRUD 开发者必经；与 J3 OOM 排错形成"部署+排错"完整闭环
- **状态**：🎯 推荐中（B4 候选）

##### J3. OutOfMemoryError troubleshooting: heap dump + Eclipse MAT for Spring Boot
- **来源讨论**：Eclipse MAT 官方教程 + 经典 OOM 排错案例（HeapHero / fastthread.io 生态）
- **目标关键词**：outofmemoryerror spring boot, heap dump eclipse mat, java memory leak troubleshooting, OOM killer analysis
- **预计字数**：1,000-1,200（**A 档硬上限 1200**，per `writing-prompts.md` Prompt A · D16 已下调）
- **分类**：Static-Site / Java-Advanced（排错类）
- **联盟预留**：否
- **AI 推荐理由**：经典 OOM 排错，英文长尾"hands-on heap dump MAT"角度稀缺；用户亲历 EEAT 强；与 J1/J2 形成 Java-Advanced 首发三件套
- **状态**：🎯 推荐中（B5 候选）

##### 第二批候选（⏸ 等 J1-J3 完成后开启）

##### J4. G1GC vs ZGC hands-on comparison for Spring Boot service
- **来源讨论**：JDK 21+ G1/ZGC 官方文档 + 联网 search 实测结果
- **目标关键词**：g1gc vs zgc spring boot, zgc tuning hands-on, low-latency gc spring boot
- **预计字数**：1,000-1,300
- **分类**：Static-Site / Java-Advanced（选型类）
- **联盟预留**：是（Hetzner / DO — 多 VPS 跑对比测试）
- **AI 推荐理由**：**Money Hook 候选**；ZGC 是 Java 11+ 主流低延迟 GC，专文稀缺
- **状态**：⏸ 第二批

##### J5. Java thread dump analysis with jstack + fastthread.io
- **来源讨论**：fastthread.io 官方文档 + 经典线程死锁案例
- **目标关键词**：java thread dump analysis, jstack deadlock, fastthread thread dump
- **预计字数**：800-1,200
- **分类**：Static-Site / Java-Advanced（排错类）
- **联盟预留**：否
- **AI 推荐理由**：线程死锁/卡死是生产环境第二大痛点（仅次于 OOM）；fastthread.io 工具生态独家
- **状态**：⏸ 第二批

##### J6. Connection pool vs thread pool sizing relationship (Tomcat threads + HikariCP)
- **来源讨论**：HikariCP GitHub issue #1234 + Tomcat 调优 wiki
- **目标关键词**：tomcat threads hikaricp sizing, connection pool thread pool ratio, spring boot thread pool tuning
- **预计字数**：1,000-1,300
- **分类**：Static-Site / Java-Advanced（部署类）
- **联盟预留**：否
- **AI 推荐理由**：CRUD 开发者最容易配错的参数；专文稀缺；与 J2 HikariCP 形成纵向延伸
- **状态**：⏸ 第二批

---

### AI-Agent（**缺口 3 篇**）

#### A1. How to set up Claude Code CLI for local blog automation workflow
- **来源**：`think-strategy.md` §三-1 + `think-templates.md` #3 扩展
- **关键词**：claude code setup tutorial, local AI coding agent, ai blog automation
- **预计字数**：1,200-1,500
- **分类**：AI-Agent（部署类）
- **联盟预留**：否（自身工具）
- **AI 推荐理由**：你本人是 TCM 重度用户，独家一手实操壁垒；高 RPM 开发者受众
- **状态**：待选 · 优先级 ★★★（集群首发必做）

#### A2. How to integrate Claude Code with Hugo blog for auto content publishing（**X1 主文章**）
- **来源**：2026-08-15 TCM 流水线实战
- **关键词**：claude code workflow, editorial pipeline, content automation, solo blog workflow
- **预计字数**：1,400-1,800
- **分类**：AI-Agent（部署类）
- **联盟预留**：否（品牌+互链型，非 Money Hook）
- **AI 推荐理由**：项目内 TCM SOP 完整外化版，对外是稀缺资产
- **详细规划**：`docs/think-x1-claude-code-pipeline.md`（D11 敲定叙事框架=编辑流水线 / 主关键词=Claude Code workflow / 节奏=拆 2 篇主+系列）
- **状态**：🎯 **推荐中（X1 选题已敲定，2026-08-22 D11）** · 优先级 ★★★（D11 升级：原 ★★ → ★★★）

#### A3. Best low-cost server for practicing MCP AI agent local workflow
- **来源**：`think-templates.md` #30
- **关键词**：cheap vps ai agent, mcp server hosting, local ai workflow vps
- **预计字数**：1,000-1,300
- **分类**：AI-Agent（选型类）
- **联盟预留**：是（VPS 联盟）
- **AI 推荐理由**：AI Agent 赛道选型评测稀缺，联盟转化高
- **状态**：待选 · 优先级 ★

---

### Remote-Payment（**缺口 2 篇**）

#### P1. WorldFirst setup guide for Chinese indie developer blog monetization
- **来源**：`think-payment.md` #3
- **关键词**：worldfirst chinese developer, worldfirst digital content creator, worldfirst adsense binding
- **预计字数**：1,200-1,500
- **分类**：Remote-Payment（部署类）
- **联盟预留**：否（WorldFirst 无公开英文联盟；仅知识普及）
- **AI 推荐理由**：B2 阶段 β 第一 Money Hook；你本人有 USD 账户开通完整实操（D4 第四次）
- **GEO 试点**（**A1 决策 · D12**）：第一篇按 GEO 写作模板落地（结论前置 + FAQ 区块 + Schema + 代码块语义完整）。详见 `docs/geo-writing-module.md`。发布后用 mock-reader P5 跑反馈，对比 EEAT 评分
- **状态**：🎯 **推荐中（B2 候选 · A1 GEO 试点 · 2026-08-25 升）** · 优先级 ★★★

#### P2. How to fill W-8BEN form for Chinese blog affiliate publisher (complete 2026 walkthrough)
- **来源**：`think-payment.md` #9
- **关键词**：w-8ben form chinese, w-8ben affiliate publisher, tax form us blogger
- **预计字数**：1,000-1,300
- **分类**：Remote-Payment（部署类）
- **联盟预留**：否
- **AI 推荐理由**：税表填写是大坑，专文少；命中 P1 自然延伸
- **状态**：待选 · 优先级 ★★

#### P3. Google AdSense payment on hold for China-based publisher troubleshooting
- **来源**：`think-payment.md` #17
- **关键词**：adsense payment on hold china, adsense payout pending, adsense review china publisher
- **预计字数**：800-1,200
- **分类**：Remote-Payment（排错类）
- **联盟预留**：否
- **AI 推荐理由**：AdSense 中国开发者卡点是高频搜，排错类高广告 RPM
- **状态**：待选 · 优先级 ★★★

#### P4. Payoneer vs WorldFirst for Chinese blog affiliate publisher: real comparison
- **来源**：`think-payment.md` #27
- **关键词**：payoneer vs worldfirst china, adsense payout comparison, chinese blogger payment tool
- **预计字数**：1,200-1,500
- **分类**：Remote-Payment（选型类）
- **联盟预留**：是（**Payoneer 联盟** — WorldFirst 留占位不放链）
- **AI 推荐理由**：**Money Hook 首选**；你本人有 WorldFirst USD 账户实测（D4 第三次发现一户绑一平台）
- **状态**：待选 · 优先级 ★★★（Money Hook 高潜 · 阶段 δ D1 主轴）

#### P5. ITIN application for Chinese developers: complete 2026 walkthrough
- **来源**：`think-payment.md` #26
- **关键词**：itin application chinese developer, us tax id non-resident, affiliate publisher itin
- **预计字数**：1,200-1,500
- **分类**：Remote-Payment（部署类）
- **联盟预留**：否
- **AI 推荐理由**：阶段 δ D3 配套文；ITIN 是 AdSense/部分联盟税表硬卡点
- **状态**：待选 · 优先级 ★（D3 阶段触发）

#### P6. Cross-border payment KYC tips for Chinese resident developer
- **来源**：`think-payment.md` #12
- **关键词**：kyc verification china developer, cross-border payment kyc, payoneer kyc tips
- **预计字数**：1,000-1,200
- **分类**：Remote-Payment（排错类）
- **联盟预留**：否
- **AI 推荐理由**：KYC 是大陆开发者最大痛点，专文少
- **状态**：待选 · 优先级 ★★

---

### Side-Project（**缺口 2 篇 · nav 临时关闭**）

> ⏸ **D6 收尾**：因 `content/posts/side-project/` 仍无文章，hugo.toml 已临时移除 side-project-menu（2026-08-20）。`/categories/side-project/` 实际会 404——保留 nav 会让用户点击落空。等 **X1（虚拟卡选型）** 首篇上线后恢复 nav。

#### X1. Best virtual card for developers to subscribe to overseas SaaS tools
- **来源**：`think-payment.md` #35（普适版去 Chinese-based 扩流量池）
- **关键词**：virtual card saas subscription, wildcard virtual card, developer saas payment
- **预计字数**：1,200-1,500
- **分类**：Side-Project（选型类）
- **联盟预留**：是（WildCard 联盟）
- **AI 推荐理由**：**Money Hook 候选**；WildCard 是你亲用工具（README §7.3 D2 列入联盟伙伴），一手壁垒
- **状态**：待选 · 优先级 ★★★（Money Hook 高潜 · 阶段 δ D1 候选）

#### X2. Stripe Atlas vs Firstbase vs Doola: which one for non-US developers
- **来源**：`think-payment.md` #37
- **关键词**：stripe atlas vs firstbase, us llc non-resident, doola vs stripe atlas
- **预计字数**：1,200-1,500
- **分类**：Side-Project（选型类）
- **联盟预留**：是（Stripe Atlas / Firstbase / Doola — 三方联盟）
- **AI 推荐理由**：海外公司注册是 SaaS 副业硬卡点，选型评测稀缺
- **状态**：待选 · 优先级 ★★

#### X3. How to validate a SaaS micro-tool idea before building (zero-code survey method)
- **来源**：`think-strategy.md` §六-2 远期 SaaS 铺垫
- **关键词**：saas idea validation, micro saas research, indie hacker validation
- **预计字数**：1,000-1,300
- **分类**：Side-Project（部署类）
- **联盟预留**：否
- **AI 推荐理由**：阶段 3 闭环复利期（think-strategy §七）必备前置；流量自用冷启动
- **状态**：待选 · 优先级 ★

#### X4. Build a static landing page with Hugo and deploy on Cloudflare Pages in 30 minutes
- **来源**：`think-strategy.md` §三-3 SaaS MVP 工具实操铺垫
- **关键词**：hugo landing page saas, static saas site, micro saas landing
- **预计字数**：800-1,200
- **分类**：Side-Project（部署类）
- **联盟预留**：是（VPS / CF Pages 联盟）
- **AI 推荐理由**：与 X3 配套，专文给 SaaS 副业者做工具上线
- **状态**：待选 · 优先级 ★

---

## 🎯 选题优先级评分模型（内部使用 · AI 推荐时参考）

| 维度 | 权重 | 1 分 | 3 分 | 5 分 |
|---|---|---|---|---|
| 搜索意图强度 | ×3 | 信息查询 | 对比决策 | 购买/订阅 |
| 实操可复现性 | ×3 | 概念解释 | 需账号 | 零门槛 CLI |
| EEAT 加固贡献 | ×2 | 通用文档 | 公开资料整合 | **用户亲历** |
| 联盟转化潜力 | ×2 | 无联盟 | 选型类 | **Money Page 主轴** |
| 比例匹配加分 | ×1 | 当前类型充足 | — | 当前类型缺口 |
| **总分** | — | ≥18 高优 | 12-17 中 | <12 低 |

> **Money Hook 高潜标记**：S9 / **S10** / **S11** / A4 / P4 / X1（6 篇，D6 P5 反馈新增 S10/S11）—— 阶段 δ D1 Money Page 主轴候选池

---

## 📅 阶段 β 推荐发文序列（D6 之前 = 2026-08-20 前）

> **D5 调整**：J1-J3 插入 B3-B5 位（原 B3 S3 OOM 后移到 B6，B4 A1 Claude Code 后移到 B7）

| 序 | 选题 | 类型 | 子类别 | 来源 | 联盟 | 预计字数 |
|---|---|---|---|---|---|---|
| **B1** | B1-1 Cloudflare Pages Preview Branches | 部署 | Static-Site | 内部回滚 | 否 | 1,200-1,500 |
| **B2** | P1 WorldFirst 实战 | 部署 | Remote-Payment | think-payment | 否（仅知识普及）| 1,200-1,500 |
| **B3** | J1 Spring Boot JVM heap tuning | 部署+排错 mix | Java-Advanced | Baeldung+dev.to | 是（Hetzner）| 1,200-1,500 |
| **B4** | J2 HikariCP connection pool tuning | 部署 | Java-Advanced | HikariCP wiki | 否 | 1,000-1,300 |
| **B5** | J3 OOM troubleshooting with MAT | 排错 | Java-Advanced | Eclipse MAT | 否 | 1,200-1,500 |
| **B6** | S3 CF Pages OOM 排错 | 排错 | Static-Site | think-templates | 否 | 800-1,000 |
| **B7** | A1 Claude Code CLI setup | 部署 | AI-Agent | 内部实战 | 否 | 1,200-1,500 |

**节奏说明**：
- B1-B2：Static-Site + Remote-Payment 交替（避免连续同主类别）
- **B3-B5：Java-Advanced 三件套集中上线**（连续 3 篇违反"避免连续同话题"原则，但属于用户明确学习路径 + CRUD 进阶首发需求，规则优先级低于用户意图）
- B6：切回 Static-Site 排错（破连续，履行比例补齐）
- B7：开 AI-Agent 新主类别（彻底破连续）

**配速预警**：D5 → D6（2026-08-20）= 4 天内 7 篇 ≈ 1.75 篇/天。如全职工节奏紧，**J2 / J3 可推到 D7+**，优先保 B1 / B2 / J1 三篇落地。

---

## 🔄 维护规则

1. **每次 AI 推荐新选题前**：必扫本文件 §「全局状态追踪」三张表
2. **每篇发布后**：从「推荐中」移到「已完成」，更新日期 / 实际字数 / commit hash
3. **状态机**：待选 → 推荐中 → 初稿（commit `[draft]`）→ 第二版（commit `[zh-final]`）→ 英文版 → 已完成
4. **撤销/废弃**：在「已完成」保留 entry 但状态改为 ⚠️ 已废弃 + commit hash（参考 A 系列占位）
5. **pool size 上限**：保持 ≤40 条（多了选择疲劳）；归档到 `docs/topic-pool-archive-YYYY.md`
6. **熔断线**（新增 · D12 交叉验证落地）：上月 GSC 收录率 < 40% **或** 质检不合格 → 当月停发新文，转做旧文优化（内容更新本身也是排名信号，且比新增安全）。来源：`docs/archive/运营方案与交叉验证文档-2026-08-27.md` §四 修正后里程碑
7. **节奏随机性**（新增 · D12 交叉验证落地）：避免"每天雷打不动 1 篇 + 每篇结构一致"被 Scaled Content 识别信号命中。允许 ±1 天波动，篇幅在 800~2500 词之间拉开差异；至少准备 3~4 种结构变体（纯排障型 / 方案对比型 / 踩坑叙事型 / 原理深挖型）轮换
8. **"宁可不发"硬规矩**（新增 · D12 交叉验证落地）：没有真实 log + 验证过的修复命令，宁可不发不凑数。10 分钟/篇只够成文，不够保证每条报错真实复现过；断更一天的代价远小于一批薄内容被整体降权的代价
9. **自动化评估时点**（新增 · D12 交叉验证落地 · **C2 决策**）：**D29（第 4 周末）** 评估 n8n / GitHub Actions / Cloudflare Worker 的具体自动化方案，**不在 D0-D14 评估**（避免过早工程化拖垮发文节奏）。评估口径：能否把 6 小时压到 2 小时（X1 实测基线）

---

## 📅 交叉验证落地决策（D12 · 2026-08-25）

> **背景**：用户新增 `docs/archive/运营方案与交叉验证文档-2026-08-27.md`，经多 AI 交叉验证 + 与现有 SOP 对比后，做出 4 项决策如下（用户 ack `A1 B2 C2 D2`）。

| 决策点 | 选择 | 落地点 | 状态 |
|---|---|---|---|
| **A1**：第一篇 GEO 试点选题 | B2 P1 WorldFirst 实战 | 本周（2026-08-25 ~ D14）按 GEO 写作模板落地 | 🎯 选题已升推荐中（见 §B2 行 322） |
| **B2**：Hugo 排错 hub 页 | 新建 `content/posts/static-site/hugo-troubleshooting-hub/index.md` | 整合 S1 + S2（按"报错簇"思维） | ✅ **已完成**（D12 期间 commit `b751bdb` 系列落地；状态行 ⏳ 为 D12 时遗漏，已 D14 修正） |
| **C2**：自动化评估时点 | D29（第 4 周末） | 不在 D0-D14 评估，避免过早工程化 | ⏳ 见维护规则 §9 |
| **D2**：about 页升级 | 与 P1 WorldFirst 同步落地 | 内容：build-in-public + GitHub/X 关联 + commit 历史 | ⏳ 见 content/about.md 升级草案 |
| **E2**：A1 7 trap 长文拆分策略（**D14 新增**） | **B 方案**：保留原文 + 加 4 篇深坑单文（S13/S14/S16/S17）| 见 §Static-Site / Build 末尾 S13-S17 条目 + 决策注释 | ✅ 选题已入池（S13 标推荐中 · 用户 D14 决策先做）|
| **F1**：文章篇幅分档硬约束（**D16 新增 · 2026-08-27**）| 存量文章不变（含 `editorial-pipeline` 4064 词唯一例外）+ 新文按 prompt_type 分档（A ≤1200 / B ≤1800 / C ≤2200 / D+E ≤2500）| `article-writing-workflow.md` §5.2.1 表格 + 例外备注 / `writing-prompts.md` 一、速查表 + 五种 Prompt 各加字数硬上限声明 / `topic-pool.md` 顶部 D16 注释 + S10/J3 字数下调 | ✅ **已完成**（S10 1,500-2,000 → 1,400-1,800 / J3 1,200-1,500 → 1,000-1,200）|
| **G1**：S18 draft 暴露排错文入库（**D17 新增 · 2026-08-27**）| 新增 `content/posts/static-site/hugo-draft-stale-dev-server-fix/index.md`（A 档 ≤ 1200 词）| S18 选题条目 + `topic-pool.md` S15/S18 注释更新（"S15 留空" + "S18 已填"）| ✅ **已完成**（[draft] 已启）|

**关联文档**：
- 完整交叉验证报告：`docs/archive/运营方案与交叉验证文档-2026-08-27.md`
- GEO 写作模板（待新建）：`docs/geo-writing-module.md`
- Hugo 排错 hub 页（待新建）：`content/posts/static-site/hugo-troubleshooting-hub/index.md`
- about 升级（待新建）：见本仓 conversation 历史