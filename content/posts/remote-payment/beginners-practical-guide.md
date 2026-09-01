+++
title = "Overseas Domain Purchase and Cross-Border Payment Guide"
description = "A step-by-step guide for developers to buy .com domains securely using PayPal and standard UnionPay debit cards without a credit card."
date = 2026-08-10T14:30:00Z
draft = false
tags = ["Domain", "PayPal", "Spaceship"]
categories = ["Remote-Payment"]
# D24 backfill: prompt_type per writing-prompts.md §一 + D16 word hard cap. 1901 words body — fits C≤2200 (war-story narrative: hands-on domain purchase + cross-border payment + 3 fails + key insight).
prompt_type = "C"

# 👇 PaperMod display toggles
ShowToc = true         # auto-generate TOC in right sidebar / top — great for how-to articles
TocOpen = true         # expand TOC by default
hidemeta = false       # show publish date, reading time, word count
comments = true        # enable comments section
disableShare = false   # enable social share buttons

[cover]
    # D24 [fix]: same-type bug as A1 cover fix e54c7f0 + Hub fix b3a3a51. Missing
    # `images/` prefix caused render-image.html hook warning and live cover 404.
    # Fix: rewrite to resources path (relative to assets/) to match PaperMod cover.html line 22 absURL fallback.
    image = "images/remote-payment/beginners-practical-guide/cover.jpg"
    alt = "Hand holding a credit card while typing on a laptop keyboard, depicting an online cross-border payment scenario."
+++

## Beginner's Practical Guide to Buying an Overseas Domain and Making Cross-Border Payments

If you're building an overseas-facing site, the domain is your core asset. As a first-timer buying my first overseas domain, I found the hidden pitfalls far more numerous than I'd imagined. This walk-through is the distilled result of my own hands-on process — it helps you steer clear of mainland-registrar surveillance risks, walk away with a `.com` at a top overseas wholesale registrar, and completely solve the cross-border payment problem when you don't have a foreign-issued credit card.

---

## 1. Choosing a Domain Registrar

The golden rules for buying a domain overseas are: **no first-year teaser pricing, no surprise renewal hikes, free WHOIS privacy**, and full decoupling from your hosting provider. Here are the top overseas registrars I compared when starting out:

### Overseas Top-Tier Registrar Comparison

| Registrar | Core Strength | Core Weakness | My Rating |
| :--- | :--- | :--- | :--- |
| **Spaceship** | Industry value-for-money dark horse — `.com` runs \$7–\$9 year-round, with a clean modern dashboard and lightning-fast DNS propagation. | A relatively new brand; some mainland debit cards hitting it directly can trigger anti-fraud callbacks. | ⭐⭐⭐⭐⭐ (my top pick) |
| **Cloudflare** | The industry's de-facto "wholesale price" registrar — zero-margin operation, renewals never go up. | Editing DNS records locks you into the Cloudflare ecosystem. | ⭐⭐⭐⭐ |
| **Namecheap** | An overseas veteran giant — rock-solid, secure dashboard and 24-hour lightning customer support. | Pricier than Spaceship. | ⭐⭐⭐⭐ |

---

## 2. Spaceship Search & Anti-Tracking Walk-Through

To avoid "shadow tracking" by less scrupulous platforms (where repeated searches for a niche domain quietly tip the system off to register it and jack the price), I followed a strict **clean-room search** protocol:

1. **Open an incognito window**: open your desktop browser and hit `Ctrl + Shift + N` (or `Cmd + Shift + N` on macOS) to enter Chrome's **Incognito** mode.
2. **Hit the official site**: type `://spaceship.com` straight into the address bar to land on the home page.
3. **Search the domain**: paste the English domain combo you like (e.g. `heimaeden.com`) into the big search box on the home page and hit Search.
4. **Add to cart**: the page shows **Available**, with the price in the \$8–\$10/year range — click **Add to cart** without hesitation.
5. **Review the bill**: click the cart icon in the top-right to reach the billing page, confirm the term (1 Year), make sure the system is gifting you **Domain Privacy** for free, deselect every value-added add-on, and keep the bill clean.

---

## 3. Cross-Border Payment Walk-Through (For Anyone Without a Foreign Credit Card)

At the time I had no Visa- or Mastercard-branded foreign credit card — just a regular mainland UnionPay debit (savings) card, and the physical card wasn't even with me. Below is the 100%-success recipe I worked out using the **PayPal route** — it works **even if you don't know your real security code**:

### Step 1: Grab Your Domestic Card Number in 5 Seconds

1. Open your mobile banking app (I used Bank of China / ICBC) and sign in.
2. Go to "My Accounts", tap the card, tap "Show/Copy Card Number" (or the little eye icon), and **copy the full 19-digit card number**.

### Step 2: Register and Link a China-Region PayPal Account

1. In your browser, go to **PayPal China** (`://paypal.com`) and click Sign Up in the top-right.
2. Pick the **Personal account**, enter your current mainland mobile number to receive a verification code, and fill in your real name and national ID number (this is a national compliance requirement and is fully safe).
3. After successful registration and login, click **Wallet** in the top menu bar.
4. Click **Link a card or bank account**.
5. **Critical pitfall to avoid**: in the linking options, **don't pick "Link a card"** — scroll down and click **"Link a bank account"**.
6. Search the bank list and select your card-issuing bank (e.g. "Bank of China"), then enter the card number you copied earlier and your mobile number.
7. Use the **UnionPay quick-pay gateway** to receive and enter the SMS code, and the card is locked in as a "direct-debit bank account".

> ⚠️ **Counter-example**: if you accidentally pick "Link a card" (instead of "Link a bank account"), the very next dialog will trap you — **UnionPay debit cards have no CVV, the "Card Security Code (CVV)" field stays red-bordered with a "View CVV" warning, and the form simply won't submit**. I hit exactly this dead end before switching back to "Link a bank account". Here's what the wrong-path dialog looks like:

![PayPal Link Card dialog — UnionPay debit card blocked at the CVV field with red box and "View CVV" warning](/images/remote-payment/beginners-practical-guide/paypal-link-card-cvv-stuck.png)

### Step 3: Head Back to Spaceship to Finish the Payment

1. In your incognito browser, return to the Spaceship cart and click **Checkout**.
2. In **Payment Method**, explicitly pick **PayPal**.
3. The PayPal sign-in pop-up appears — sign in and directly tick the Bank of China account you just linked.
4. **The voodoo of CSC verification**: on the final payment click, PayPal suddenly pops a dialog asking you to verify card info — the popup looks similar to the screenshot in Step 2 — and **forces me to enter a 3-digit CSC security code**. Since my card is an ordinary RMB savings card with no such code on the back, **I just typed any three digits (e.g. 123), hit submit, and unbelievably the system let it through!** I consider this a bug: when CSC is required the system should check the card type, and if it allows a UnionPay debit card (which has no security code), it shouldn't force CSC entry.
5. An ICBC debit SMS arrived (deducting the equivalent in RMB) and my domain was locked in within seconds!

---

<!-- 📸 截图位 #4
     位置: §三 步骤 4 后
     内容: Spaceship 后台 Domain Manager + 域名详情面板 — 可见 Auto-renew On 开关；Privacy / Transfer 为折叠子菜单入口
     文件: /images/remote-payment/beginners-practical-guide/spaceship-domain-overview.png
     脱敏: ⚠️ 真实域名 → example.com（必做）；续费金额已用 redact-image.sh 打码
     建议尺寸: 1920×1080 优先保留完整右侧详情面板 -->

### Step 4: Key Spaceship Post-Purchase Settings (The Last Lock Against Losing Your Domain)

Right after buying the domain, hop into Spaceship and verify a few critical states. **Spaceship's UI changes frequently — the description below is based on the Domain Manager interface I saw immediately after checkout** — exact toggle names may differ slightly from what you see; treat your account's actual UI as the source of truth.

Go to the Spaceship dashboard → **Domain Manager** in the left menu; you'll see your domain list:

1. **Confirm auto-renew status straight from the list**. The row's right-hand side has an `Auto-renew` column showing `On` / `Off`. If it's already `On`, just glance at the list — no need to click in.

2. **Click the domain → the detail panel slides out on the right**:
   - **Top Renewal card**: shows the renewal expiry date (e.g. `Aug 11, 2027`) and an `Extend subscription` button.
   - **Auto-renew card**: contains an intuitive toggle (`On` / `Off`). **Keep it `On`.** If you'd rather not auto-renew, at minimum **set a renewal reminder 30 days ahead on your phone calendar**. After a `.com` expires you still have a 30-day grace period to renew normally; miss that and it enters the redemption period, with redemption fees easily exceeding \$100.
   - **Several collapsible sub-menus below**: `Nameservers & DNS` / `Domain Contacts` / `Privacy` / `Transfer` / `URL redirect` / `Email forwarding`, etc. **Two of them matter** — click into `Privacy` and `Transfer` and check the actual state inside:
     - **Privacy sub-page**: Spaceship givers ICANN privacy protection for free on `.com`, so the status field is most likely already `On` / `Active`. If it shows `Off`, enable it manually.
     - **Transfer sub-page**: make sure it's locked (the exact toggle name depends on what you see — it may be `Transfer Lock` or `Domain Lock`). Otherwise anyone with your email verification code could walk away with the domain.

   > ⚠️ I didn't drill into screenshots for those two sub-pages' exact toggle names (the first-time domain-buying flow doesn't actually need to visit those sub-pages) — the names above are common labels based on Spaceship's official docs.

<!-- 📸 截图位 #4: spaceship-domain-overview.png (域名 + 价格已 redact-image.sh 打码, On toggle 保留) -->
![Spaceship Domain Manager — Auto-renew On toggle with Privacy and Transfer sub-menu entries visible](/images/remote-payment/beginners-practical-guide/spaceship-domain-overview.png)

📸 **Above**: the `Auto-renew On` status, plus the `Privacy` and `Transfer` sub-menu entries are visible.

### Step 5: China-Region PayPal Account Security Settings (Anti-Risk-Control + Anti-Fraud)

Once your China-region PayPal account is open, going straight to a large purchase is the easiest way to trigger risk control. These three steps are the foundation for keeping the account stable.

1. **Turn on two-step verification (2FA)**: sign in to PayPal ➔ Settings ➔ Security ➔ **Two-step verification** ➔ pick "SMS code" (recommended — the lowest barrier). Accounts without 2FA are significantly more likely to trip risk control on their first cross-border purchase.

2. **Complete identity verification**: Settings ➔ Account ➔ **Verification status** ➔ upload the front and back of your national ID + link a bank card under your own name. **Unverified accounts have strict caps on annual foreign-exchange settlement quotas** (the exact figure follows PayPal's official announcement); once verified, the quota jumps significantly.

3. **Set up your withdrawal bank card**: Wallet ➔ Link a bank card ➔ enter the Bank of China / ICBC savings card number from earlier steps. **This card must match the name on your verified identity**, otherwise the first withdrawal will fail and enter manual review.

---

## 4. Common Reasons for PayPal Account Limits (Compiled from Public Sources)

This section is compiled from PayPal's official help documentation — for pre-emptive risk awareness only, **not first-hand experience**. Do not treat it as a complete or authoritative compliance reference — defer to PayPal's latest help pages:

- General: [Why is my PayPal account limited or locked?](https://www.paypal.com/us/cshelp/article/help164)
- Resolution flow: [Accessing your PayPal account if it's limited](https://www.paypal.com/us/cshelp/article/help345)
- Reason checklist: [Why is my PayPal account restricted?](https://www.paypal.com/us/cshelp/article/help165)
- FAQ: [What can I do if my PayPal account is limited — FAQ](https://www.paypal.com/us/smarthelp/article/what-can-i-do-if-my-paypal-account-is-limited-faq4047)

### 4.1 Account Limited / Restricted

Per PayPal's official docs, common reasons an account may be limited include: unusual activity on a new account in a short window, missing or needing-recheck account info, a hit on credit / risk-control rules, or a compliance-triggered review. Once limited, PayPal typically shows a yellow banner at the top of the account home page and asks for supporting materials (ID, address proof, purchase receipts, etc. — **the exact list depends on the in-account pop-up**).

### 4.2 Withdrawal to Bank Card Fails

PayPal's docs are explicit: **a mismatch between the account holder name and the bank card holder name will cause withdrawal (transfer) to fail**. The workaround is to make the two names match exactly (including rare characters and spacing). If they don't, the resolution path is to first confirm or correct the name on the bank side, or submit a name-change request on PayPal's side (the review duration follows whatever PayPal responds — the company has not publicly committed to a timeline).

### 4.3 Permanent Limits and "Proxy Payments"

Per PayPal's [account-type policy](https://www.paypal.com/us/cshelp/article/help164), accounts can be permanently limited (including balance withdrawal). Community and third-party sources frequently flag the following as high-risk triggers: frequent IP switching in a short window, a single transaction far above the account's historical spend level, receiving or paying on behalf of third parties, and so on. These are **rumour-grade risk signals** — do not treat them as PayPal's official ban list; whether they trigger and how severely is ultimately decided by PayPal's risk-control system.

---

✅ With this, the full chain — domain purchase + cross-border payment + account security + risk-control boundaries — is done. **The PayPal route only works for cross-border spending scenarios** (domain renewals, SaaS subscriptions, overseas service payments, etc.) — **it does not work for receiving payments**. AdSense / affiliate-marketing USD receipts go through WorldFirst instead — see the upcoming WorldFirst walkthrough.