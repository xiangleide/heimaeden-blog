# WorldFirst 美元账户申请 Checklist（worldfirst-usd-checklist.md）

> **用途**：移动端按部就班执行 WorldFirst USD 收款账户开通的现场操作手册。
> **配套**：`docs/think-payment.md` §五-3（WorldFirst 个人收款完整流程）+ `docs/think-strategy.md` §五（万里汇方案）。
> **节奏**：D4 末 → D5 前完成 USD 账户 + 截图保存 + hugo.toml 本地段写入 → A2 全部完成。
> **承诺**：完成本 checklist 100% 后，README §1 M3 由 95% → 100%。

---

## 进度概览

| Phase | 动作 | 状态 |
|---|---|---|
| ✅ 已完成 | 实名认证（身份证 + 支付宝人脸 KYC）| 2026-08-15 |
| ✅ 已完成 | 绑定支付宝用于人民币收款 | 2026-08-15 |
| ✅ 已完成 | WorldFirst 控制台申请 USD 收款账户（业务类型「数字内容创作」，仅绑定 AdSense）| **2026-08-15** |
| ⏳ Phase 2 | 拿到 Routing/Account Number/SWIFT/Bank Name 4 字段 | 待办 |
| ⏳ Phase 3 | 截图保存至本地保密目录 + 写入 `hugo.toml [params.payout]`（本地版，不进 git） | 待办 |
| ⏳ Phase 4 | AdSense 后台绑定 USD 收款账户 + 测试款到账验证 | 待办 |
| ⏸ Phase 5 | 各联盟平台 USD 账户（**WorldFirst 一户一平台**，按需申请，30s/账户） | **延后至 M5 商业化收割阶段，按需申请** |

---

## Phase 1：WorldFirst 控制台申请 USD 收款账户

### 入口路径

WorldFirst 主控台 → 「收款账户」或「多币种账户」→ 「申请新账户」→ 选 USD。

### 必填字段（开发者账号）

- [ ] **账户类型**：选「USD 收款账户」或「Global Account」
- [ ] **业务用途**：从下拉列表选 **「数字内容创作」** 或 **「软件服务」**
  - 🚨 **绝对不要选**：电商 / 实物贸易 / 跨境物流（会要求物流单据，数字服务无单 = 审核失败）
- [ ] **预计月入金额**：如实填写
  - 新站起步建议填 **100-1000 USD/月**（虚报会被复审冻结）
  - 6 个月后可上调
- [ ] **资金来源描述**（自由文本）：
  > "Google AdSense advertising revenue and overseas SaaS affiliate program commissions for a personal developer blog."

### 提交后等待

- 通常 1-3 个工作日
- **首次申请**可能 5-7 天（KYC 复审）
- 审核结果会通过 App 推送 + 短信通知

---

## Phase 2：拿到 4 个关键字段

审核通过后，在「收款账户详情」页记录以下 4 个字段：

| 字段 | 格式 | 示例（仅供参考，以实际为准）|
|---|---|---|
| **Account Number** | 9-12 位纯数字 | 123456789012 |
| **Routing Number / ABA** | 9 位纯数字 | 021000021 |
| **SWIFT/BIC Code** | 11 位字符（8字母+3数字/字母）| BOFAUS3N |
| **银行英文名** | WorldFirst 合作行 | Bank of America, N.A. |

### 验证清单

- [ ] 4 个字段全部从官方控制台复制（**不要截图 OCR**，避免出错）
- [ ] 检查 Account Number 没有空格/连字符混入
- [ ] Routing Number 与银行名匹配（同一银行 Routing 唯一）
- [ ] SWIFT Code 末三位 = 银行城市代码（如 BOFAUS3N = Bank of America US 3N）

---

## Phase 3：本地保密目录 + hugo.toml

### 3.1 截图保存（4 张 PNG，文件名规范化）

建议路径：`~/Documents/heimaeden-payout/worldfirst-usd-2026-08-XX/`

| 文件名 | 内容 |
|---|---|
| `01-account-number.png` | 含完整 Account Number |
| `02-routing-number.png` | 含完整 Routing Number |
| `03-swift-code.png` | 含完整 SWIFT/BIC |
| `04-bank-name.png` | 含合作行英文名 |

📸 截图要求：
- 包含账户持有人姓名拼音（核对与 AdSense 一致）
- 包含账户开通时间戳
- 不要发到云相册（防止泄露）

### 3.2 写入 hugo.toml（**仅本地版**，不进 git）

```toml
# hugo.toml [params.payout] 段 — 仅本地，不 commit
[params.payout]
provider = "WorldFirst"
accountHolder = "XIANG LEIDE"  # 按 AdSense 拼音实际填
accountNumber = "XXXXXXX"
routingNumber = "XXXXXXX"
swift = "BOFAUS3N"  # 按 Phase 2 实际填
bankName = "Bank of America, N.A."
lastUpdated = "2026-08-XX"
```

🔒 加入 `.gitignore`（如果还没有）：
```
# .gitignore 本地加一行
hugo.toml.local
```
或者用本地 override 文件（推荐）。

---

## Phase 4：AdSense 后台绑定 USD 账户

### 步骤

1. 登录 https://adsense.google.com
2. 「付款」→「管理付款方式」
3. 点击「添加付款方式」→「添加银行账户」
4. 选择「电汇（Wire Transfer）」或「银行账户（Bank Account）」
6. 填写 WorldFirst USD 账户 4 字段
7. **收款人姓名**：必须与 AdSense 账户名**完全一致**（倒字母 = 拒收）
8. 提交

### 首次验证

- Google 通常会先打 **$1-2 测试款**到 USD 账户
- 1-3 个工作日到账
- WorldFirst 收到后会自动按实时汇率转 RMB → 支付宝
- **不要撤销**：测试款到账后 AdSense 才算真正绑定成功

### 时间估算

- AdSense 申请提交后 → 测试款到账 = **7-14 天**
- USD 账户 → 支付宝 RMB = **1-3 工作日**

---

## Phase 5：各联盟平台 WorldFirst USD 账户（**延后至 M5，按需申请**）

> **实测结论（2026-08-15）**：WorldFirst 一个 USD 收款账户 = 绑定一个**指定**收款平台，不能跨平台共用。
> - 已开通：AdSense 专用 USD 账户（Phase 1）
> - 后续每个联盟对接时 → WorldFirst 控制台再单独申请一个 USD 账户（**约 30 秒/账户**）
> - 战略意义：无需提前批量开通，刚需时再开，零复杂度

### M5 阶段（商业化收割）执行清单（**D30+ 触发**）

按相同模式逐个申请 + 绑定：

| 联盟平台 | 申请时机 | 操作 |
|---|---|---|
| **Hetzner Affiliate** | D30 后申请联盟资格后 | WorldFirst 控制台 → 申请新 USD 账户（业务类型「联盟佣金」） |
| **DigitalOcean Referral** | D30+ | 同上 |
| **Porkbun Affiliate** | 域名续费时顺便 | 同上 |
| **WildCard 推广** | 订阅 SaaS 工具推荐时 | 同上 |
| **其他** | 按需 | 同上 |

### 多账户管理建议

- WorldFirst 控制台会给每个 USD 账户起名（建议格式：`USD-AdSense`、`USD-Hetzner-Aff` 便于识别）
- 每个账户单独保存 4 字段截图到 `~/Documents/heimaeden-payout/worldfirst-<platform>-<date>/`
- `hugo.toml` `[params.payout.<platform>]` 段按需扩展，不挤一个段里

---

## ⚠️ 避坑提醒（5 条硬约束）

> 与 `docs/think-payment.md` §六 一致。

1. **拼音一致性**：WorldFirst 注册的拼音必须与 AdSense 后台 `收款人姓名` **完全一致**（颠倒字母、错大小写、空格差异 = 拒收或退回）
2. **不要选电商类型**：审核会以「实物贸易」为由要你提供物流单据（数字服务无单 = 失败）
3. **不要大额突然到账**：首次单笔 >$1000 会触发复审，可能冻结 7-15 天
4. **5 万 USD 年度便利化额度**：每年累计结汇超 5 万美元需主动申报，WorldFirst 可代为服务贸易申报（参考 `think-payment.md` §五-3 步骤 5）
5. **8-12 个月复核**：USD 账户政策会变，每年至少复核一次 Routing/SWIFT 是否仍有效

---

## 🔄 冗余备份（WorldFirst 故障时的应急通道）

> 此前版本建议同时开通 Payoneer / Wise 作为冗余。
> **2026-08-15 修正**：WorldFirst 单账户 30s 申请、多账户并行无额外成本 → **WorldFirst 一家足以覆盖**主需求，备份通道仅在 WorldFirst 服务整体不可用时启用。

| 通道 | 启用时机 |
|---|---|
| **WorldFirst 多账户** | 主方案；按需申请，每账户绑定 1 平台 |
| **Payoneer** | 仅当 WorldFirst 整体服务异常时启用（如平台倒闭/账号冻结） |
| **Wise** | 仅当出境/有护照后启用（需地址证明） |
| **PingPong** | 不推荐（电商导向） |
| **PayPal** | 不推荐作主通道（5 万 USD 限制、汇率差） |

---

## ✅ 完成定义（M3 = 100% 收官标志）

完成 Phase 1-4 即可达 M3 = 100%（Phase 5 延后至 M5 商业化收割阶段）：

1. [ ] WorldFirst AdSense USD 账户开通（Phase 1 ✅）
2. [ ] 4 字段全部截图保存至 `~/Documents/heimaeden-payout/worldfirst-adsense-2026-08-XX/`
3. [ ] `hugo.toml` 本地版写入 `[params.payout.adsense]` 段
4. [ ] AdSense 绑定完成 + 测试款到账验证通过（7-14 天）
5. [ ] README §1 M3 状态由 98% → **100%**
6. [ ] README §6 追加「M3 = 100%」状态行
7. [ ] README §7.3 阶段 α 全部勾选 A1/A2/A3

满足上述 7 项后，**M3 收官**，可正式进入 M4 内容冲刺（§7.3 阶段 β B1-B4）。
Phase 5（联盟账户）按需在 M5 阶段（商业化收割）触发，不阻塞 M3 → M4 推进。

---

## 📞 卡点求助

如遇以下情况，先记录具体报错截图，再问 Claude：

- WorldFirst 控制台看不到 USD 申请入口 → 可能账号类型不对
- AdSense 拒绝绑定 → 检查拼音一致性 + Routing 格式
- 测试款超过 14 天未到账 → 检查 Routing Number 是否填写正确
- 提现时弹出「需补充材料」→ 一般是首次大额触发，按指引补提交即可