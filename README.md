# 🗺️ HeimaEden 独立站全球变现项目全景路线图与资产白皮书

> **项目定位**：面向欧美技术出海市场的硬核程序员技术博客与联盟营销（Affiliate Marketing）网赚独立站。
> **核心站点**：[HeimaEden.com](https://heimaeden.com)
> **大后方控制中心**：本文件作为项目的动态路线图，后续所有新增的工作模块、技术细节及搞钱计划请在此处持续追加同步。

---

## 📅 一、 项目当前所处里程碑（Project Milestones）

| 里程碑阶段 | 核心任务目标 | 当前状态 | 达成时间 / 预期时间 |
| :--- | :--- | :--- | :--- |
| **M1: 生产底座闭环** | 域名抢注、跨境支付打通、Cloudflare 边缘托管流水线合龙 | **🟢 100% 达成** | 2026-08-11 |
| **M2: 合规与视觉美化** | 隐私条款五件套上线、About/Contact页面补齐、极客美学样式重构 | **🟢 100% 达成** | 2026-08-13 |
| **M3: 变现血脉打通** | 申请属于个人名下的合规美国虚拟银行卡（万里汇/PingPong） | **🟢 100% 达成** | 2026-08-15 |
| **M4: 内容营销起航** | 专栏首发 3 篇硬核干货与高客单价 Money Page 商业测评文发布 | **🟡 推进中 (30%)** | 2026-08-20 前 |
| **M5: 商业化收割** | 申请 Google AdSense 保底广告，冲刺月 PV 突破变现临界点 | **🔴 挂起 (待时机)** | 预计运营 1-3 个月后 |

---

## 🛠️ 二、 项目已完成事项清单（Accomplished Tasks）

### 1. 核心资产与域名解析层
*   [x] **品牌域名抢注**：在 Spaceship 成功购入顶级独立出海域名 `HeimaEden.com`。
*   [x] **跨境无卡支付打通**：通过中国区 PayPal 绑定国内普通 19 位银联借记卡（储蓄卡）完成代扣，盲打“123” CSC 安全码强行通关，完美避开外币信用卡风控。
*   [x] **全球 CDN 防爆神盾**：将 Nameservers 移交给 Cloudflare，实现毫秒级瞬开和免费防 DDoS 攻击。

### 2. DevOps 云端自动化流水线
*   [x] **Hugo 框架落地**：本地成功初始化基于 Go 语言的 Hugo 静态引擎，挂载行业顶级的 `PaperMod` 极客风主题。
*   [x] **Cloudflare Pages 解耦部署**：绑定 GitHub 仓库，成功避开 Workers/Wrangler 后台 UI 误导陷阱，正确在 Pages 纯净沙盒中配置 `Build command: hugo` 自动化流水线。
*   [x] **版本与环境锁死**：在云端环境变量中注入 `HUGO_VERSION`，彻底消除由于版本滞后引发的现代主题语法编译红字报错。

### 3. 内容集群、功能页与合规法务
*   [x] **二级目录逻辑隔离**：在本地 `content/posts/` 之下创建了 `remote-payment/`（境外收款金矿，原 `payment/` 已重命名）与 `static-site/`（静态建站）两个长尾内容流集群。
*   [x] **全站极速搜索与归档**：成功点亮 `Search`（JSON 极速本地检索）与 `Archives`（时间轴归档）两个核心功能页，并在 `hugo.toml` 中显式配置唯一 `identifier` 破除菜单命名的二义性模糊（Ambiguous）。
*   [x] **法务四件套彻底去 404 化**：批量产出符合 GDPR / CCPA / FTC 欧美最高标准法务文本，移动到 `legal/` 专属合规目录下，通过在 `hugo.toml` 中页脚路径补齐前置斜杠 `/`，彻底根治路径套娃跳转到 localhost 的幽灵 Bug。
*   [x] **关于/联系我实体页点亮**：成功补充 `about.md` 和 `contact.md` 页面，并将官方邮箱锁定为纯净且彰显极客逼格的 **`heimaeden@proton.me`**。
*   [x] **首发图文长文上墙**：将这两天所有踩坑血泪史转化为了 1200 字原创图文教程《Hugo + Cloudflare Pages 部署：我踩过的 7 个隐形大坑与终极修复笔记》，成功引入两张真实后台实操截图，全面拉高谷歌 HCU 审查所需的 EEAT 权重得分。

---

## 📝 三、 当前即时执行待办事项（Immediate Todo List）

> 💡 **操作指南**：今晚电脑端的基建已经以无可挑剔的品质全部封顶，当前处于移动端/碎片时间状态，请按照以下顺序在明天推进商务收金通道的落地。

*   [ ] **【待办 1：手机端秒杀】注册万里汇个人海外网赚账户**
    *   **注册主体**：认准「跨境电商/独立站/网赚」➔「个人账户」（持国内身份证和手机号刷脸秒过）。
    *   **主营行业**：在销售/买卖大类下勾选：**「数字产品 / 虚拟商品或软件销售」**（100% 豁免跨境物流发货单风控）。
    *   **提款卡地区**：精准勾选 **「美国（USD 美元）」**，下卡后将专属的 *Routing Number* 和 *Account Number* 截图保存至手机相册。
*   [ ] **【待办 2：长期挂起】线上黑夜/白天模式点击不响应跟进**
    *   **现状描述**：全站的高级圆角样式、1.8 倍舒适行高（CSS）在线上已经通过 `/assets/css/extended/extended.css` 100% 成功生效，但右上角图标的 JavaScript 切换事件在线上依然卡死。目前默认的 `auto` 模式会自动根据欧美读者电脑系统自动适配皮肤，不影响阅读。
    *   **后续动作**：先放着不用管，等后续我们产出几篇搞钱文章后，随时进控制台看 `F12` 报错再一枪狙杀。
*   [ ] **【待办 3：暂缓执行】在 HTML 头部注入欧美 GDPR 隐私同意弹窗**
    *   **后续动作**：等我们的网站开始有真实老外流量进来、准备接入高级广告联盟时，再去 Cookiebot 复制 JS 脚本，新建 `/layouts/partials/head.html` 注入进去。当前阶段先保持代码绝对纯净。

---

## 🎯 四、 后期阶段性工作目标（Long-Term Project Goals）

1.  **第一阶段：专栏内容填充（1-2 周内）**
    *   在【Jamstack 建站避坑笔记】专栏下，以你这两天的真实经历继续输出剩下的 2 篇博文，并全文输出那篇专门用来躺赚高额服务器提成的 **《Hetzner 云服务器硬核商业测评文（Money Page）》**。
2.  **第二阶段：SEO 关键词与外部权重累积（1 个月内）**
    *   将网站提交给 **Google Search Console**（谷歌搜索控制台），向谷歌主动呈递全站的 `sitemap.xml` 站点地图，开始拦截欧美全栈程序员和独立开发者的报错长尾搜索流量。
3.  **第三阶段：多渠道被动收入全面收割（3 个月内）**
    *   当全站的高质量英文长文达到 15-20 篇后，正式向 Google AdSense 发起保底广告商业化申请。
    *   同时，拿着已经拥有极高极客内容品质的 `HeimaEden.com` 去批量申请 WildCard 虚拟卡、SaaS 工具和各大云机房的官方 **Affiliate 推广资格**，变现链接全面由占位符替换为属于你自己的美金收钱直链。

---

## ⚠️ 五、 后期日常运营注意事项（Operational Precautions）

*   **1. 严格遵守 TOML 语法格调**
    *   由于我们的全局配置采用的是 `hugo.toml`，未来每次写新文章时，头部的元数据区域（Front Matter）必须使用 `+++` 包裹，且属性赋值必须使用**等号 `=`**，绝对不能写成带冒号 `:` 的 YAML 格式，否则线上编译器会直接报错。
*   **2. 坚守文章发布日期的“过去式原则”**
    *   未来每次写完新教程准备上墙时，文章头部的 `date` 属性绝对不能写成未来的时间（小心国内时区与线上 Linux UTC 时间的利差）。如果不小心穿越到了未来，Hugo 线上主页会直接把文章强行隐形（开天窗）。改成本地当前时间或昨天的日期即可。
*   **3. 始终维持“利他主义”的变现文案姿态**
    *   在海外独立站生态里，老外极度反感牛皮癣广告。我们在嵌入类似 WildCard 或 Hetzner 的推广链接时，必须采用**“推荐我的专属链接，你可以直接白嫖 €20 试用金/减免 \$2 开卡费，同时也能帮我赚杯咖啡钱”的双向互惠利他文案**。
*   **4. 杜绝侵权流氓，首选 CC0 素材库**
    *   未来写技术博客需要配图时，绝对不能去谷歌图片里搜科技感图直接用。必须且只能使用 Unsplash、Pexels 等无版权可商用的素材库作为文章首图，防止收到海外版权流氓几百美金的自动化索赔律师函。

---

## 📝 六、 下一阶段工作计划与备忘录（Project Notes & Appendices）

*( 💡 **小提示**：后续你在实际操盘中，无论是遇到新的报错、构思出了新的高转化搞钱选题、还是成功拿下了哪家大 SaaS 厂的联盟推广资格，直接用编辑器打开本文件，在下方依次追加：`### 2026-XX-XX 工作同步：xxxx` 即可，这里将成为你出海赚美金的终极备忘档案库！)*

### 📝 动态追加备忘区域：
*   **2026-08-13 状态记录**：全站技术基建大满贯封顶，首发图文踩坑干货长文已完美推上线。
*   **2026-08-14 状态校准**：PayPal 定位 = 仅域名一次性付账；万里汇收款链路已开通 dev 账号（未选电商类型），仅差实名认证；项目启动日锚定为 2026-08-11（D3）。
*   **2026-08-14 Bug 修复 / 黑夜白天按钮**：根因不是 SRI，也不是大小写，而是用了**无效键名 `showThemeToggle = true`**——PaperMod 三处模板只认 `disableThemeToggle`（取反）。hugo.toml 改为 `disableThemeToggle = false`，无需 JS 覆盖。同步订正发布文 `hugo-cloudflare-pages-pitfalls.md` §Trap 7 的归因，避免误导后来读者。
*   **2026-08-14 状态收口 / D3 闭环（双旧账结清）**：本轮一次性清掉两笔工程债——(1) `layouts/partials/footer.html` 此前**整模板覆盖** PaperMod，导致黑夜/白天切换 JS handler 被吞；现已恢复 PaperMod 完整 footer（含 4 个 `<script>` 块）+ 内联法务四件套 span。(2) `static-blog-setup-guide.md` 中 2 条 HTML TODO 占位符（Workers 配置截图、Pages 入口截图）已替换为合规 `![alt](/images/...)` 语法；原 PNG 从 `content/posts/static-site/`（Hugo 路由不可服务区）迁至 `static/images/` 配 kebab-case 命名。commit `7f1b80d` 已推 origin/main，CF Pages 线上全链路验证通过；lint-post.sh 全仓 **0 errors / 0 warnings**。
    ⚠️ **订正上述 2026-08-14 Bug 修复条**：`disableThemeToggle = false` 仅解决**配置键**这一层；真实根因链 = `[错键名 showThemeToggle] + [footer 整模板覆盖丢失 click handler]` 双层叠加，单修任一层按钮仍卡死。`hugo-cloudflare-pages-pitfalls.md` §Trap 7 暂未补这一层归因，留待 M4 阶段统一修订。
*   **2026-08-14 D3.5 全站 QA + 6 类 polish 闭环**：33 端点 probe → 32/34 通过 → 触发 5 类修复，全部 commit `86cef90` + `73dd3a0` 推 origin/main。

    **修复明细（commit 顺序）**

    *   **commit `86cef90` feat: brand assets** — 用 Python `struct`/`zlib` 手写生成 6 张品牌资产，零第三方 IP / 字体依赖。设计：slate-900 底 + emerald-400 像素 "H" 标，与全站极客绿主题统一。
        * `static/favicon.ico` (262B, 16+32 多尺寸 ICO) / `favicon-16x16.png` (98B) / `favicon-32x32.png` (126B) / `apple-touch-icon.png` (585B, 180×180) / `safari-pinned-tab.svg` (290B)
        * `static/images/og-default.png` (6360B, 1200×630)
    *   **commit `73dd3a0` fix: site-wide polish** — 6 项同步打包：
        * `layouts/404.html` 重写：原 PaperMod `.not-found` 容器带 `font-size:160px`，塞入 H1/段落/列表后整页 160px 字号溢出 viewport。新结构用 `.not-found-page` 容器 + `<h1 class="big-404">404</h1>` + 4 个胶囊按钮。
        * `assets/css/extended/extended.css` 追加 ~70 行专属样式，`.big-404` 用 `clamp(8rem, 22vw, 16rem)` 响应式 + `--primary-color` 翡翠绿。
        * `layouts/partials/extend_head.html` 新建：注入默认 og:image（last position，让 per-page 图片在 first-valid-wins 客户端胜出）。
        * `hugo.toml` 加 `[params] description = "..."` (152 字符) 全站兜底 + nav urls `archives`/`search` 加尾斜杠（消除点击时的 308）。
        * `content/{about,archives,contact,search}.md` 各加 `date = 2026-08-14T00:00:00Z`，sitemap `<lastmod>` 覆盖从 22/26 提升到 26/26。
        * `content/legal/*.md` 4 个加显式 description ≤160 字符（原 434-612 字符 auto-summary 被 SERP 截断）。

    **D3 终态**：4 个 commit 在 origin/main，本地 0 ahead、working tree 干净（仅 `public/` 构建产物未 tracked）、Hugo dev server 在跑（PID 46384, port 1313）。

    **遗留工程债（不影响 D4 主线，记入 §7.2 速度债清单）**
    * `public/` 仍未进 `.gitignore`（构建产物不该入 git）
    * `minify` 顶级配置已 deprecated（Hugo v0.150+ 提示，需迁移到 `minify.minifyOutput`）
    * PaperMod 上游三处 deprecation（`.Language.LanguageDirection` / `.Language.LanguageCode`），本项目无权改主题源码，需等 PR 上游合
    * `hugo-cloudflare-pages-pitfalls.md` §Trap 7 仍未补「footer 整模板覆盖」第二层根因（订正优先级 = 低）

    **D4 衔接点（按 §7.3 阶段 α — M3 收官）**
    * 24h 冷却期：M1/M2 已 0 冷却封顶，从 M3 起强制恢复 §7.4 自检
    * **A1** 万里汇 dev 控制台提交实名认证材料（移动端秒杀） — ✅ 2026-08-15 完成
    * **A2a** 截图保存 Routing/Account Number 至本地保密目录 — ✅ 2026-08-15 完成（保存至 `~/Documents/heimaeden-payout/worldfirst-adsense-2026-08-15/account-overview.png`）
    * **A2b** 写入 `hugo.local.toml [params.payout.adsense]` 段 — ⏸ 2026-08-15 跳过决策（D4 第五次）
    * **A3** README §6 追加「M3 = 100%」状态行 — ✅ 2026-08-15 完成（D4 第六次）

*   **2026-08-15 状态校准 / D4 第一次**：WorldFirst dev 账号已完成实名认证（身份证 + 支付宝人脸 KYC）+ 绑定支付宝用于人民币收款。万里汇链路已具备完整人民币端通路。
    * **关键缺口**：**美元收款账户（Routing Number + Account Number）尚未开通**——按 `docs/think-payment.md` §五-3 步骤3，这是 AdSense / 海外联盟绑定的硬前提，M3 = 100% 前必须补齐。
    * M3 进度：90% → **95%**（仅 USD 账户待开）
    * §1 状态行 / §7.1 校准行 / §7.3 阶段 α 勾选 同步更新
    * 📋 **下一步**：参考下方 WorldFirst USD 账户申请 checklist（按需移动到独立 docs 备忘）

*   **2026-08-15 状态校准 / D4 第二次（USD 账户申请成功）**：WorldFirst USD Global Account 已申请成功，业务类型选「数字内容创作」无误。**4 字段（Account Number / Routing Number / SWIFT / Bank Name）尚未截图复制**。
    * M3 进度：95% → **98%**（仅 4 字段截图 + AdSense 绑定两步即 100%）
    * 📋 **下一步**（按 [`docs/worldfirst-usd-checklist.md`](../docs/worldfirst-usd-checklist.md)）：
        1. **Phase 2**：进控制台复制 4 字段，截图保存至 `~/Documents/heimaeden-payout/worldfirst-usd-2026-08-XX/`
        2. **Phase 3**：写入 `hugo.toml [params.payout]` 段（本地版，不进 git）
        3. **Phase 4**：AdSense 后台绑定 USD 账户，等测试款到账（7-14 天）
    * 满足 8 项完成定义后，M3 = 100%，正式进入 §7.3 阶段 β（M4 内容冲刺）

*   **2026-08-15 状态校准 / D4 第三次（WorldFirst 账户结构实测发现）**：WorldFirst 一个 USD 收款账户 = 绑定一个**指定**收款平台，不能跨平台共用；新联盟对接时需单独申请（约 30 秒/账户）。战略意义：
    * M3 = 100% 收官门槛**降低**：Phase 5（联盟账户绑定）从「收官必备」调整为「M5 阶段按需触发」，M3 闭环只需 Phase 1-4（即 AdSense 单账户完整链路）
    * 备份通道方案简化：WorldFirst 多账户即可覆盖主需求，Payoneer / Wise 仅在 WorldFirst 整体异常时启用
    * 📂 **更新文档**：
        * [`docs/think-payment.md`](../docs/think-payment.md) §一-5 新增账户结构说明
        * [`docs/worldfirst-usd-checklist.md`](../docs/worldfirst-usd-checklist.md) Phase 5 改为 M5 延后 + 备份章节简化
        * §7.3 D2 同步加注
*   **2026-08-15 状态校准 / D4 第四次（Phase 2 完成 + 安全事件复盘）**：WorldFirst USD 账户 4 字段（Account Number / Routing Number / SWIFT / Bank Name）截图已保存至 `~/Documents/heimaeden-payout/worldfirst-adsense-2026-08-15/account-overview.png`。M3 进度：98% → **99%**。
    * 🚨 **安全事件复盘（必读，下次同类操作 SOP）**：用户首次将截图放在 `docs/`（git tracked 目录）→ Claude 立即识别安全风险并询问 → 用户选 A → 移到 git 外安全位置。**教训**：(1) docs/ 虽不是 Hugo 内容树，但仍是 git 工作树的一部分，敏感资产永远不进 repo。(2) checklist §3.1 明确建议路径 `~/Documents/heimaeden-payout/`，执行 SOP 必须先看 checklist，不能图方便就近放。
    * ⏸ **Phase 3 已跳过（2026-08-15 用户决策）**：原计划写 `hugo.local.toml` 段以便未来 shortcode 复用。决定跳过理由：Phase 3 非收款链路硬卡点，仅前端展示 + 模板复用价值，直接进 Phase 4 可更快触发 7-14 天测试款等待期。脚手架（.gitignore + docs 模板）保留，未来 M5 产出 ≥3 篇 Money Page 后如负担明显可重启。详见 `docs/worldfirst-usd-checklist.md` §三。
    * ⏸ **Phase 4 待办（不可压缩）**：AdSense 后台绑定 → 测试款到账（7-14 天） → M3 = 100%。
*   **2026-08-15 状态校准 / D4 第五次（Phase 3 跳过决策）**：用户决定跳过 `hugo.local.toml` override 文件写入步骤，直接进 Phase 4。理由：Phase 3 非收款链路硬卡点，仅为未来 Money Page 模板复用价值。M3 完成定义从 7 项调为 6 项。
    * 📂 **更新文档**：
        * `docs/worldfirst-usd-checklist.md` 进度概览表 Phase 3 行改为「⏸ 已跳过」+ Phase 2 行补 ✅ 状态
        * `docs/worldfirst-usd-checklist.md` 新增「⚠️ Phase 3 决策记录（2026-08-15 跳过）」节：跳过理由、代价、何时回补、脚手架状态
        * `docs/worldfirst-usd-checklist.md` §七 完成定义：移除 Phase 3 项，7 → 6 项
        * README §7.3 阶段 α A2 拆分为 A2a（截图 ✅）+ A2b（hugo.local.toml ⏸ 跳过）
        * M3 进度保持 **99%**（Phase 4 未做，不升级）
*   **2026-08-15 状态校准 / D4 第六次（M3 边界重新定义 — 激进型方案 A）**：用户指出关键事实：现在还没接入广告与营销联盟 → AdSense 测试款机制无法触发 → 之前 Phase 4 作为 M3 收官门槛是错的。M3 = 100% 边界重新定义为「**WorldFirst USD 账户 + 4 字段截图**」即可，不再要求 AdSense 绑定 + 测试款到账。
    * 🔑 **新边界**：
        * M3 = 100% = Phase 1（USD 账户）✅ + Phase 2（4 字段截图）✅ = **2 项硬要求**
        * Phase 3（hugo.local.toml）已跳过（见 D4 第五次）
        * Phase 4（AdSense 绑定 + 测试款）→ **推迟到 M5 阶段**（商业化收割），需先满足：(a) AdSense 申请审核通过；(b) 累计收益 ≥ $100 支付阈值；(c) 真实流量基础
        * Phase 5（联盟 USD 账户）→ 仍按原计划 M5 按需申请
    * 📊 **阶段 β 前置任务升级**：sitemap.xml + robots.txt + GSC 验证文件从 B3 升级为 ⭐ **B0 前置必做**——AdSense 审核要求「GSC 已验证 + sitemap 已提交」，否则审核自动拒绝
    * 📊 **阶段 δ 新增任务 D4**：AdSense 申请提交（**仅提交**，不等审核通过）。提交条件：(a) 内容 ≥ 15 篇优质英文长文（README §四阶段三）；(b) GSC + sitemap 验证文件就位；(c) 合规四件套完整
    * 📂 **更新文档**：
        * `docs/worldfirst-usd-checklist.md` §七 完成定义精简：6 → **2 项**（Phase 1 + Phase 2）
        * `docs/worldfirst-usd-checklist.md` Phase 4 标记「M5 阶段触发」+ 新增「M3 边界重新定义」节
        * README §1 M3 状态：99% → **100%** 🟢
        * README §7.1 关键事实校准表新增 M3 边界误判行
        * README §7.3 阶段 α：全部勾选 + A3 标记 ✅；阶段 β B3 升级为 B0 前置必做；阶段 δ 新增 D4 AdSense 申请提交
    * ⚠️ **历史回顾过期声明**：上文 D4 第一次/第二次/第三次叙述里的「M3 = 100% 收官标准」「关键缺口」「Phase 4 不可压缩」等措辞已过期。**以本条（D4 第六次）为唯一准绳**：M3 = 100% 仅需 Phase 1 + Phase 2。历史叙述保留作为决策轨迹，不作修改。
*   **2026-08-15 状态校准 / D4 第七次（阶段 β B0 收官 + push 边界重划）**：
    * ⭐ **B0 = 100%**（阶段 β 前置必做完成）：sitemap config + robots.txt + GSC 验证（CF Pages 308 clean-URL 重定向 → Googlebot 跟随 → 验证通过）+ sitemap.xml 提交全部完成。
    * 🚧 **push 边界重划**：用户在 D4 第七次校准对话中明确质疑「未经确认就 git push」。**新边界即刻生效**：所有 `git push` 必须经用户显式 ack 后执行；本地 `git commit` 可直接做（本地可 amend/reset）。本次 commit（`docs/seo-setup-checklist.md` Phase 4 ✅ + README §7.3 B0 勾选 + 本次校准条目）将停在本地，**等待用户 ack push**。
    * 🔓 **下一步解锁**：B1（写第二/第三篇图文长文）+ B2（WorldFirst 实战 Money Hook）不再被 B0 阻塞。

*   **2026-08-16 偏好记录 / commit 消息语言**：用户明确要求后续 commit message 优先用中文描述（含标题行 + body 说明），便于本地翻账与跨会话追溯。即刻生效于 D5 起的所有 commit（含本轮「D5 博客主页分类导航重构」尚未提交的 2 个 commit）。push 边界沿用 D4 第七次校准：本地 commit 可直接做，`git push` 必须经用户显式 ack。

*   **2026-08-16 状态校准 / D5 第一次（博客主页分类导航重构落地）**：nav 4 大内容集群从草案到落地一次走完，3 commit 全部 push 至 origin/main。
    * **3 commit 列表**（按时间序）：
        * `186d1e2` chore: 记录 commit 消息中文偏好到 README §6
        * `e1315c3` D5: 顶 nav 4 大内容集群重排
        * `ffbd326` D5: Payment → Remote-Payment 迁移 + 301 兜底
    * **nav 新结构**：Static Site / Remote Payment / AI Agent / Side Project（权重 10/20/30/40）+ 工具页 Archives / Search / About / Contact（50/60/70/71）。主题菜单权重梯度均匀分布，便于未来插入「Newsletter」「Reviews」等单篇页时按 5-10 阶梯插队。
    * **301 兜底**：`/categories/payment/` → `/categories/remote-payment/`，CF Pages 边缘解析，本地 `hugo server` 不生效，5 分钟内线上验证。
    * **已知 UX 小坑（已接受）**：AI Agent / Side Project 空分类首篇文章到位前 404。Hugo 默认不为未引用分类生成列表页，这是已知行为不是 bug。等 J 系列 / AI-Agent 系列首篇标 `categories = ["AI Agent"]` / `["Side Project"]` 后页面自动出现，无需再改 nav。
    * **Java-Advanced 落地**：仅作 tag（用户 Q2 决策），不上 nav。`/tags/java-advanced/` 页面在 J1 首篇落地后自动可见。PaperMod `single.html` 默认不渲染 tag chip 的问题留作独立 task，本轮不修。
    * **推后动作**：
        1. **线上验证窗口**（push 后 5 分钟）：浏览器访问 `https://heimaeden.com/categories/payment/`，期望 301 跳到 `/categories/remote-payment/` 且页面显示 1 篇文章。
        2. **GSC 索引**（3-7 天）：新分类 URL 重新抓取 + 旧 URL 301 迁移权重。
    * **D5 解锁**：B1（写第二/第三篇图文长文）不再被 nav 结构阻塞，可按 docs/topic-pool.md 选题推进。AI Agent 集群首篇是关键——出文即关闭「空分类 404」UX 坑。

---

## 🧭 七、 项目启动复盘与下阶段作战图（Retrospective & Forward Battle Map）

> **模块定位**：本节是 **M3-M5 全部后续动作的唯一战略参考源**，与第六节「动态备忘」剥离——前者记流水，后者管路线。每次决定下一步动作前，先在本节找锚点；本节没有的，才回第六节补临时记录。

### 🔧 7.1 关键事实校准（Fact Calibration）

| 项 | 上一轮误判 | 校准后真相 | 后续影响 |
| :--- | :--- | :--- | :--- |
| **PayPal 通道定位** | 误判为主收款链路 | **仅用于 Spaceship 域名一次性付账**，非收款通道 | 移除所有「停掉 PayPal」类建议，结算通道风险归零 |
| **万里汇账户状态** | 推进中 90% | 「**开发者**」账号已注册完成（**注册时未勾选电商类型**），仅差**实名认证** | 2026-08-15 三次校准：(1) 实名认证 + 支付宝 KYC 完成 ✅；(2) USD Global Account 开通（业务类型「数字内容创作」，仅绑 AdSense）✅；(3) **4 字段截图已保存至 git 外** ✅ | D4 第六次校准：M3 收官门槛重新定义，本账户已**满足** M3 = 100% |
| **项目启动日 / 今日基准** | 未明示 | 启动日 = **2026-08-11**；本文成稿时 = **D3**（2026-08-14） | 全文时间锚点统一为 `D=N ↔ 2026-08-11 + N` |
| **M3 完成边界** | 把「AdSense 绑定 + 测试款到账」作为 M3 收官门槛 | AdSense 测试款机制依赖：(a) 申请审核通过；(b) 累计收益 ≥ $100；(c) 真实流量。三者皆需 1-3 个月 → **让 M3 永远卡在 99%** | 2026-08-15 用户指出后重新校准：**M3 = 100% 仅需 WorldFirst USD 账户 + 4 字段截图**。AdSense 绑定 + 测试款 → 推迟至 M5 阶段 | 阶段 β B3 升级为 B0 前置必做（AdSense 审核硬要求）；阶段 δ 新增 D4 AdSense 申请提交（仅提交） |

### 📊 7.2 72 小时速度复盘（Velocity Audit）

**行业基准**：域名 + Hugo 部署 + Cloudflare Pages + 合规四件套 + 首篇图文长文 + 收款链路开账户，个人出海博客常规节奏 **8-12 个日历日**。

**实际完成表**：

| 时段 | 日期 | 完工事项 | 行业用时估算 |
| :--- | :--- | :--- | :--- |
| D0-1 | 2026-08-11 | 域名抢注、PayPal 跨境付账绕障、Cloudflare NS 移交 | 2-3 天 |
| D2 | 2026-08-12/13 | Hugo 初始化、PaperMod 挂载、Cloudflare Pages 流水线、HUGO_VERSION 锁版 | 2-3 天 |
| D3 | 2026-08-13/14 | Legal 四件套、About/Contact/Archives/Search 实页化、首篇图文长文（1200 字 + 2 截图）、万里汇 dev 账号开立 | 4-6 天 |
| **合计** | **3 个日历日** | **完成度 ≅ 行业 8-12 天工作量** | **×2.5 ~ ×4 加速** |

**判定**：⚡ **Hyper-Velocity（极速档）**。

**加速度来源解构**：
- OCM 自动化流水线的体感加速：**~40-50%**（内容生成 + 配置改写）
- 个人对欧美出海链路已具备 pre-knowledge：**~30%**（跳过早期认知坑）
- 真实剩余速度债（即被高速度掩盖的问题）：

| 债种 | 已暴露症状 | 偿还优先级 |
| :--- | :--- | :--- |
| 工程债 | 主题换肤 JS 线上卡死（暂不致命） | M5 前 |
| 合规深度债 | Legal 四件套文本未经独立法务复核，目前仅形似 | M4 前 |
| SEO 索引债 | sitemap / robots / GSC 验证文件尚未就位 | M4 前 24h 内 |
| 法务账户债 | 万里汇实名认证未完成 + 无 ITIN/EIN 规划 | M3 完成时同步启动 |

### 🗺️ 7.3 下阶段作战图（Forward Battle Map）

> **节奏阀门**：每个里程碑从「推进中」切到「100%」前必须**冷却 24h 自检**。M1/M2 已「无冷却封顶」，是已知隐患；从 M3 起强制恢复该阀。

#### 📍 阶段 α — M3 收官（**✅ 已完成**，2026-08-15）

> **新边界**（D4 第六次校准）：M3 = 100% 仅需 WorldFirst USD 账户 + 4 字段截图。Phase 4 推迟至 M5。

- [x] **A1** 登录万里汇 dev 控制台，确认注册类型为「开发者」（已确认），提交实名认证材料 — **2026-08-15 完成**（身份证 + 支付宝人脸 KYC）
- [x] **A2a** 截图保存 *Routing Number* + *Account Number* 至本地保密目录 — **2026-08-15 完成**（保存至 `~/Documents/heimaeden-payout/worldfirst-adsense-2026-08-15/account-overview.png`；**重要**：用户先误放 `docs/`，Claude 立即识别安全风险并移出 git，避免公网仓库泄露银行信息）
- [⏸] **A2b** 写入 `hugo.local.toml` 段（本地版，不进 git）— **2026-08-15 跳过决策**：Phase 3 非收款链路硬卡点，仅为前端复用，详见 `docs/worldfirst-usd-checklist.md` §三跳过说明 + §七完成定义调整
- [x] **A3** README 第六节追加「M3 = 100%」状态行 — **✅ 2026-08-15 完成**（D4 第六次校准）
- [x] ⏸ **冷却自检**：核对「未选电商类型」是否会触发后续 Stripe / PayPal Merchant 入驻时的「类型不匹配」风险——**结论**：WorldFirst 已确认业务类型「数字内容创作」可承载 AdSense/Payoneer 联盟佣金场景；Stripe 因境内个人不支持，无需提前备案；**自检通过**，无遗留风险

#### 📍 阶段 β — M4 内容冲刺（目标 D6 = 2026-08-20 前）

> **重要调整**（D4 第六次校准）：原 B3（sitemap/robots/GSC）升级为 ⭐ **B0 前置必做**——AdSense 审核要求 GSC 已验证 + sitemap 已提交，否则审核自动拒绝。**B0 必须在 B1 第一篇内容上线前完成**。

- [x] ⭐ **B0**（前置必做）`hugo.toml` 显式补 `[sitemap]` 段、`static/robots.txt`、`static/google<hash>.html` GSC 验证文件 + 提交 GSC 验证 + 提交 sitemap — **2026-08-15 完成**（commit `67ae311` + `a6cf65b` + `f1e7efa` + 本次收官）
- [ ] **B1** 完成第二 + 第三篇图文长文，与首篇同为 `Jamstack 建站避坑笔记`专栏话题
- [ ] **B2** 发布 `remote-payment/` 子目录下的《WorldFirst 开发者账户实战：0 电商流水极速下卡全纪录》——这是 M4 首个 **Money Hook**（**注**：WorldFirst 仅做知识普及，无公开英文联盟，联盟链接留待 Payoneer / Wise / PingPong 真实注册后再植入）
- [ ] **B3** 接 Plausible / Umami 轻量分析（合规第一原则，无需 GDPR banner）
- [ ] ⏸ **冷却自检**：每篇上线后过 24h 看 GSC 抓取是否成功，再发下一篇

#### 📍 阶段 γ — M4.5 索引与权重过渡期（D6 → D14）

- [ ] **C1** 监控 GSC 索引曲线，单篇 7 天未被索引则手动 fetch + 检查 robots
- [ ] **C2** Cloudflare Pages 开启 Preview Branches，OCM SOP 第 16 步从「直推 main」改为「feature 分支 → preview URL → 人工审 → merge main」
- [ ] **C3** `themes/PaperMod/` 由整库内联迁移到 Hugo Modules，同步更新 `.gitignore`（追加 `.hugo_build.lock`、`public/`、`resources/`）
- [ ] **C4** 已发布 2 篇 `posts/` 重构为 Page Bundles（同名文件夹里 `index.md` + 图片），启用 `Resize` + `WebP` 优化线图

#### 📍 阶段 δ — 变现起跑线（D14 → D30）

- [ ] **D1** Money Page 落地：《2026 远程工作者收款工具横评》——**英文联盟伙伴专版**（Wise / Payoneer / PingPong / WorldFirst 横评表格 + 联盟链接 + 用户画像分流；WorldFirst 仅作知识普及，不放联盟链接）
- [ ] **D2** 建立 `data/affiliates.toml` 统一管理联盟关系（**仅英文联盟**：Payoneer / Wise / PingPong / Hetzner / DigitalOcean / WildCard / Porkbun；WorldFirst 与 A2Hosting 仅留 placeholder 不放链接），文章内统一 shortcode 引用。**WorldFirst USD 账户结构（2026-08-15 实测）**：一户绑定一平台，对接新联盟时单独申请新 USD 账户（约 30 秒/账户），无需提前批量开通
- [ ] **D3** ITIN/EIN 申请 Checklist 入档；WorldFirst 月度对账工作流（CSV → 简单记账表）建立
- [ ] **D4** ⭐ **AdSense 申请提交**（**仅提交，不等审核通过**）—— D4 第六次校准新增。提交硬条件：(a) 内容 ≥ 15 篇优质英文长文（README §四阶段三）；(b) GSC + sitemap 验证文件就位（B0 必做）；(c) 合规四件套 + About/Contact 页面完整。**审核结果：通常 1-4 周；通过率受 EEAT 权重影响（M5 E2 加固）**

#### 📍 子阶段 δ-Payment — 境外收款模块启动（D20 → D40，并行于变金线主轴）

> 完整规划见 [`docs/think-payment.md`](docs/think-payment.md)。本节为 README 内嵌的执行锚点。
> **关键约束**：收款集群不先发，须底盘 30-40 篇部署/排错就位后再启动。

- [ ] **P1** 前 20 篇锁定部署+排错（4:4:2 比例），`remote-payment/` 集群暂不开张
- [ ] **P2** 第 21 篇起插入收款文章，节奏：每 6-8 篇部署/排错 → 1-2 篇收款（最终占比 ≤15%）
- [ ] **P3** 联盟植入：选型对比文章 → Payoneer / Wise / PingPong 联盟链接；排错文章 → 仅广告
- [ ] **P4** 双向内链：AdSense / 联盟变现文章 ↔ `remote-payment/` 收款文章（互推权重）
- [ ] **P5** 每 8-12 个月批量复核全部收款文章（KYC 规则、费率、平台名称变更）
- [ ] ⏸ **冷却自检**：每篇收款文上线前，对照 [`docs/think-payment.md §六`](../docs/think-payment.md) 风险规避5条硬约束逐条打勾

#### 📍 阶段 ε — M5 长跑（D30 → D90）

- [ ] **E1** 内容累计 ≥ 15 篇优质英文长文后，正式提交 Google AdSense 申请
- [ ] **E2** EEAT 加固：增加 author schema、公开 founding date、扩展独立 About 页（加入真实履历 + 一张真人头像 + 1 段反 AI 透明声明）
- [ ] **E3** 申请 Cookiebot 或自建 consent banner；FTC 端：每条联盟链接后短线 follow 标记 `(affiliate link)` 而非仅页脚 disclosure

### 🧷 7.4 24 小时冷却自检模板

每篇文章 / 每次配置变更 / 每次里程碑切换前，对照打勾：

- [ ] 线上版 ≠ 跳过的本地合并提交
- [ ] 所有联盟链接已用 shortcode 注入并验证 302 跳转目标
- [ ] 无未关闭的 `auto`/`toml`/`favicon` 漂移
- [ ] 截图、Routing/Account 等敏感数据入库不入 git
- [ ] GSC / 分析后台已就绪（指标可观察，不可观察的改进不算完成）
