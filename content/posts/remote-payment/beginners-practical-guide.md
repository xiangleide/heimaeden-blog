+++
title = "Overseas Domain Purchase and Cross-Border Payment Guide"
description = "A step-by-step guide for developers to buy .com domains securely using PayPal and standard UnionPay debit cards without a credit card."
date = 2026-08-10T14:30:00Z
draft = false
tags = ["Domain", "PayPal", "Spaceship"]
categories = ["Remote-Payment"]

# 👇 PaperMod 专属友好展示模板开关
ShowToc = true         # 自动在右侧/顶部生成文章目录（超级利于操作型文章导航）
TocOpen = true         # 默认展开目录
hidemeta = false       # 显示文章发布日期、阅读时间、字数等元数据
comments = true        # 开启评论区展示
disableShare = false   # 开启社交媒体分享按钮
lint_allow = ["cjk-body"]  # 历史包袱：存量文豁免英文要求；新文禁止

[cover]
    image = "remote-payment/beginners-practical-guide/cover.jpg"
    alt = "Hand holding a credit card while typing on a laptop keyboard, depicting an online cross-border payment scenario."
+++

## 境外域名购买与跨境支付新手实操指南

做境外网站，域名是我们的核心资产。作为一名新手，在第一次购买境外域名时，我发现里面的暗坑远比想象中多。本篇教程由我亲身实操沉淀而来，带你避开国内域名商的监控风险，在海外顶级批发商处顺利拿下 `.com` 域名，并彻底解决无外币信用卡的跨境支付难题。

---

## 一、 域名注册商选择

在海外买域名，核心原则是**无首年低价套路、续费不涨价、免费赠送 WHOIS 隐私保护**，且必须与服务器服务商彻底解耦。以下是我在起步时对比过的海外顶级域名注册商：

### 海外顶级域名注册商对比

| 注册商名称 | 核心优点 | 核心缺点 | 我的推荐指数 |
| :--- | :--- | :--- | :--- |
| **Spaceship** | 行业性价比黑马，`.com` 常年 \$7-\$9，后台界面极简现代，解析极快。 | 新晋品牌，部分国内借记卡直连容易触发反诈回调。 | ⭐⭐⭐⭐⭐ (我的首选) |
| **Cloudflare** | 业界公认的“批发价”注册商，零利润运营，续费永远不涨价。 | 修改 DNS 记录必须绑定其自家的生态。 | ⭐⭐⭐⭐ |
| **Namecheap** | 海外老牌行业巨头，管理后台极其稳定安全，24小时客服响应极快。 | 价格比 Spaceship 略贵。 | ⭐⭐⭐⭐ |

---

## 二、 Spaceship 域名选购与防黑查漏步骤

为了防止某些不规范平台的“影子监控”（频繁检索某个冷门域名后被系统暗中抢注抬价），我严格执行了**无痕无污染查询**：

1. **开启无痕模式**：打开电脑浏览器，按下 `Ctrl + Shift + N`（Mac 系统为 `Cmd + Shift + N`）进入谷歌浏览器的**无痕/隐身窗口**。
2. **访问官网**：在地址栏直接输入 `://spaceship.com` 进入首页。
3. **域名检索**：在首页大搜索框中输入我心仪的英文域名组合（例如：`heimaeden.com`），点击搜索。
4. **加入购物车**：页面显示 **Available**（可用），价格在 \$8-\$10/年左右，我果断点击 **Add to cart**（加入购物车）。
5. **核对账单**：点击右上角购物车进入结算页面，核对域名年限（选择 1 Year），确认系统免费赠送了 **Domain Privacy**（隐私保护），其余增值服务一律不选，保持账单纯净。

---

## 三、 跨境支付实操步骤（针对无外币信用卡选手）

我手头当时没有带 Visa 或 Mastercard 标志的外币信用卡，只有普通的国内银联借记卡（储蓄卡），且实体卡还不在身边。以下是我摸索出通过 **PayPal 通道** 100% 成功扣款的绝招，**即使不知道真实安全码也完全可以操作**：

### 步骤 1：5秒获取国内卡号
1. 打开我的手机银行 App（我用的是中国银行/工商银行），登录账户。
2. 进入「我的账户」，点击对应的卡片，点击「卡号显示/复制」（或小眼睛图标），**复制出完整的19位卡号**。

### 步骤 2：注册并绑定中国区 PayPal 账户
1. 在浏览器中打开 **PayPal 中国官网**（`://paypal.com`），点击右上角注册。
2. 选择「个人账户」，输入我当前的中国手机号接收验证码，并填写我的真实姓名与身份证号（这是国家合规要求，完全安全）。
3. 注册成功并登录，点击顶部菜单栏的 **「钱包 (Wallet)」**。
4. 点击 **「关联卡或银行卡」**。
5. **核心避坑点**：在绑定选项里，**不要选关联卡**，拉到下方点击 **「关联银行账户 (Link a bank account)」**。
6. 在银行列表里搜索并选择我的发卡行（如“中国银行”），输入刚才复制的卡号和手机号。
7. **通过银联快捷支付网关**接收并输入短信验证码，成功将卡片以”银行账户快捷代扣”形式绑死。

> ⚠️ **反面教材**：如果你误选了「关联卡」（而不是「关联银行账户」），下一步就会撞上这个对话框——**银联借记卡没有 CVV，「卡安全代码（CVV）」字段会持续红框 + 「查看CVV」警示，根本无法提交**。我当时就是撞了这条死路才切回「关联银行账户」的。下图是误选路径的现场：

![PayPal 关联卡对话框 — 银联借记卡在 CVV 字段被卡死，CVV 红框 + 查看 CVV 警示](/images/remote-payment/beginners-practical-guide/paypal-link-card-cvv-stuck.png)

### 步骤 3：返回 Spaceship 完成最终支付
1. 在无痕浏览器中返回 Spaceship 购物车，点击 Checkout（结算）。
2. 在支付方式（Payment Method）中，明确勾选 **PayPal**。
3. 页面弹出了 PayPal 登录小窗口，登录后直接勾选我刚才绑定的中国银行账户。
4. **触发安全码验证玄学**：在点击最后支付时，PayPal 系统突然弹窗提示需要验证卡片信息，弹窗内容与步骤2中截图类似，**强制要求我输入一个 3 位的 CSC 安全码**。由于我的卡是普通人民币储蓄卡，背面根本没有这个码，**我索性在框里随便输入了三个数字（例如 123），点击提交，没想到系统竟然直接验证通过了！**，我认为这是bug，要求输入CSC安全码的时候应该校验卡片类型，既然允许绑定银联卡借记卡（没有安全码），就不应强制要求输入CSC。
5. 伴随着工行的扣款短信（扣除等额人民币），我的域名成功秒速拿下！

---

<!-- 📸 截图位 #4
     位置: §三 步骤 4 后
     内容: Spaceship 后台 Domain Manager + 域名详情面板 — 可见 Auto-renew On 开关；Privacy / Transfer 为折叠子菜单入口
     文件: /images/remote-payment/beginners-practical-guide/spaceship-domain-overview.png
     脱敏: ⚠️ 真实域名 → example.com（必做）；续费金额已用 redact-image.sh 打码
     建议尺寸: 1920×1080 优先保留完整右侧详情面板 -->

### 步骤 4：Spaceship 后台关键设置（防丢域名的最后一道锁）

域名买下来后，立即在 Spaceship 后台核对几个关键状态。**Spaceship 的 UI 经常调整，下面描述基于我下单后立即进入 Domain Manager 的实测界面**——具体开关名称与你看到的可能略有出入，以你账号内的实际呈现为准。

进入 Spaceship 后台 → 左侧菜单的 **Domain Manager**，会看到你的域名列表：

1. **列表层就能直接确认自动续费状态**。域名行右侧有 `Auto-renew` 列，显示 `On` / `Off` 状态。如果已经是 `On`，列表里看一眼就行，无需再点进去。

2. **点击域名 → 右侧滑出域名详情面板**：
   - **顶部 Renewal 卡片**：显示续费到期日（如 `Aug 11, 2027`）和 `Extend subscription` 按钮。
   - **Auto-renew 卡片**：含一个直观的开关（`On` / `Off`）。**务必保持 `On`**。如果你不想自动续费，至少**在手机日历里提前 30 天**设置续费提醒。`.com` 过期后还有 30 天宽限期可正常续，过了就进入赎回期（redemption period），赎回费可高达 $100 以上。
   - **下方多个折叠子菜单**：`Nameservers & DNS` / `Domain Contacts` / `Privacy` / `Transfer` / `URL redirect` / `Email forwarding` 等。**重点核对两个**——点击进入 `Privacy` 和 `Transfer` 页面，查看里面的实际状态：
     - **Privacy 子页**：Spaceship 对 `.com` 默认赠送 ICANN 隐私保护，所以状态字段多半已经是 `On` / `Active`。如果显示 `Off`，手动开启。
     - **Transfer 子页**：确保处于锁定状态（具体开关名称以你看到的为准，可能是 `Transfer Lock` 或 `Domain Lock`）。否则任何人拿到你的邮箱验证码就能把域名转走。

   > ⚠️ 上面两个子页里的具体开关名，我没有下钻截图（首次域名购买流程用不到进入子页的操作），仅基于 Spaceship 官方文档的常见命名给出参考名。

<!-- 📸 截图位 #4: spaceship-domain-overview.png (域名 + 价格已 redact-image.sh 打码, On toggle 保留) -->
![Spaceship Domain Manager — Auto-renew On toggle with Privacy and Transfer sub-menu entries visible](/images/remote-payment/beginners-practical-guide/spaceship-domain-overview.png)

📸 **上图说明**：可见 `Auto-renew On` 状态、`Privacy` 和 `Transfer` 子菜单入口。

### 步骤 5：PayPal 中国区账户安全设置（防风控 + 防盗刷）

PayPal 中国区账户开通后，直接大额消费极易触发风控。下面 3 步是稳账户的基础操作。

1. **开启两步验证（2FA）**：登录 PayPal ➔ 设置 ➔ 安全 ➔ **两步验证** ➔ 选「短信验证码」（推荐，门槛最低）。不开 2FA 的账户，首次跨境消费触发风控的概率显著提升。

2. **完成实名认证**：设置 ➔ 账户 ➔ **认证状态** ➔ 上传身份证正反面 + 绑定一张本人名下的银行卡。**未实名账户的年度结汇额度有严格上限**（具体数额以 PayPal 官方公告为准），完成实名后额度会大幅提升。

3. **设置提现银行卡**：钱包 ➔ 关联银行卡 ➔ 输入前面步骤里那张中国银行 / 工商银行储蓄卡卡号。**这张卡必须与实名姓名一致**，否则首次提现会失败并进入人工审核。

---

## 四、 PayPal 账户常见限制原因（公开资料整理）

本节为 PayPal 官方帮助文档的公开资料整理，仅用于事前了解风险，**非作者亲历**。请勿将其当作完整或权威的合规依据——以 PayPal 最新帮助页为准：

- 通用：[Why is my PayPal account limited or locked?](https://www.paypal.com/us/cshelp/article/help164)
- 解除流程：[Accessing your PayPal account if it's limited](https://www.paypal.com/us/cshelp/article/help345)
- 限制原因清单：[Why is my PayPal account restricted?](https://www.paypal.com/us/cshelp/article/help165)
- 常见问答：[What can I do if my PayPal account is limited — FAQ](https://www.paypal.com/us/smarthelp/article/what-can-i-do-if-my-paypal-account-is-limited-faq4047)

### 4.1 账户被限制（Limited / Restricted）

按 PayPal 官方文档，账户可能被限制的常见原因包括：新账户短期内异常活动、账户信息缺失或需复核、信用/风控规则命中、以及合规要求触发的复审。被限制后，PayPal 通常会在账户首页顶部展示黄色横幅提示，并要求提交相应材料（身份证件、地址证明、消费凭证等，**具体清单以账户内弹窗为准**）。

### 4.2 提现到银行卡失败

PayPal 官方明确：**账户姓名与银行卡开户姓名不一致会导致提现（转账）失败**。规避方法就是保证两者一致（含生僻字、空格）。如果姓名不一致，处理路径是先去银行侧确认/变更，或在 PayPal 侧提交更名申请（具体审核时长以 PayPal 反馈为准，官方未公开承诺）。

### 4.3 永久限制与"代付"

按 PayPal 的[账户类型政策](https://www.paypal.com/us/cshelp/article/help164)，账户可能被永久限制（包括余额无法提现）。社区与第三方资料中常被列为高风险触发的行为包括：短期内 IP 频繁切换、单笔金额远高于账户历史消费水平、替他人代收代付等。这些属于**传闻级风险信号**，请勿将其当作 PayPal 的官方禁令牌——是否触发、严重程度如何，最终由 PayPal 风控系统判定。

---

✅ 至此，域名购买 + 跨境支付 + 账户安全 + 风控边界全链路打通。**PayPal 通道仅适用于跨境消费场景**（域名续费、SaaS 订阅、海外服务付款等），**不适用于收款**。AdSense / 联盟营销的美元收款走万里汇（WorldFirst）通道，详见后续 WorldFirst 实战文章。
