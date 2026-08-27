# 跨境收款 USD 账户申请 Checklist（worldfirst-usd-checklist.md）

> **用途**：移动端按部就班执行 USD 收款账户开通的现场操作手册（适用 WorldFirst / 类似平台）。
> **配套**：`docs/think-payment.md` §五（跨境收款平台选择通用指引）。
> **承诺**：完成本 checklist Phase 1-3 后即可向海外平台收款；Phase 4-5 视商业化阶段触发。

---

## 进度概览（个人完成状态 = 本地记录，不入库）

> ⚠️ **公开化精简（2026-08-27）**：本节原为个人完成时间表（含 ✅ 状态 + 具体日期 + 本地路径），公开化前删除。读者使用本 checklist 时，按自己节奏勾选下表即可，无需复刻任何时序。

| Phase | 动作 | 你的状态 |
|---|---|---|
| Phase 1 | 实名认证（身份证 + 平台人脸 KYC）| ⬜ 待完成 |
| Phase 1 | 绑定用于人民币提现的收款工具 | ⬜ 待完成 |
| Phase 1 | 控制台申请 USD 收款账户（业务类型「数字内容创作」）| ⬜ 待完成 |
| Phase 2 | 拿到 Routing / Account Number / SWIFT / Bank Name 4 字段 | ⬜ 待完成 |
| Phase 3 | 4 字段截图保存至本地保密目录 | ⬜ 待完成 |
| Phase 3 | `hugo.local.toml` 写入 4 字段（可选，仅为未来 shortcode 复用）| ⬜ 可选 |
| Phase 4 | AdSense 后台绑定 USD 收款账户 + 测试款到账验证 | ⬜ 推迟到商业化阶段 |
| Phase 5 | 各联盟平台 USD 账户（按需申请，30s/账户） | ⬜ 商业化阶段按需触发 |

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

> ⚠️ **公开化精简（2026-08-27）**：本节原含个人本地路径示例（`~/Documents/heimaeden-payout/worldfirst-usd-2026-08-XX/`）——该路径暴露账户持有者本人机器 + 命名习惯。公开化后改为通用「截图保存至本地保密目录」指引，文件名规范保留作为 SOP 参考。

**路径约定**（请按自己习惯命名，本文档不指定具体路径）：

| 文件名（参考规范） | 内容 |
|---|---|
| `01-account-number.png` | 含完整 Account Number |
| `02-routing-number.png` | 含完整 Routing Number |
| `03-swift-code.png` | 含完整 SWIFT/BIC |
| `04-bank-name.png` | 含合作行英文名 |

📸 截图要求（通用）：
- 包含账户持有人姓名拼音（核对与 AdSense 一致）
- 包含账户开通时间戳
- **不要发到云相册 / 公开 GitHub / 团队共享盘**（防止泄露，公开后无法撤回）

### 3.2 写入 hugo.local.toml override 文件（**不进 git**）

**为什么用 override 文件？**
Hugo `--config` 只识别 `.toml/.yaml/.json` 后缀，所以 override 文件必须是合法后缀。
我们命名 `hugo.local.toml`（中间带 `.local.` 表示私有，结尾 `.toml` 让 Hugo 接受）。
主配置 `hugo.toml` 保持原样，零修改，敏感字段全部在 override 文件里。

**操作步骤**：

1. 在 repo 根创建 `hugo.local.toml`（**不要 commit**，确保已在 `.gitignore`）

2. **参数名列表**（具体值由你从平台控制台复制粘贴，不在本节示例化——避免示例值被误填使用）：

```toml
# hugo.local.toml — PRIVATE override, NEVER commit
# Usage: hugo --config hugo.toml,hugo.local.toml

[params.payout.<platform-slug>]
provider       = "<平台名 e.g. WorldFirst / Payoneer / Wise 等>"
accountHolder  = "<收款人姓名英文 / 拼音，必须与上游平台 payout name 完全一致>"
accountNumber  = "<9-12 位纯数字>"
routingNumber  = "<9 位 ABA / Routing Number>"
swift          = "<11 字符 BIC (8 字母 + 3 字母数字)>"
bankName       = "<合作行英文全称>"
lastUpdated    = "<YYYY-MM-DD，每次刷新更新>"
```

> ⚠️ **公开化精简（2026-08-27）**：原模板含 `accountHolder = "XIANG LEIDE"` 等真实示例值（拼写 = 账户持有人本人姓名拼音）+ Routing/SWIFT/Account Number 真实格式占位数字——这些示例值即使带 `# comment` 也属于「不应公开」的 PII（账号持有者可被反查）。**公开化后此处改为参数名列表，具体值由你从平台控制台复制，不在此文档出现任何真实数字 / 姓名示例**。

3. 验证 Hugo 能加载双 config：

```bash
hugo --config hugo.toml,hugo.local.toml --gc
```

应输出 `Total in <N> ms`，无 `failed to load config` 错误。

4. 本地预览命令（替代裸 `hugo server`）：

```bash
hugo server --config hugo.toml,hugo.local.toml --buildDrafts
```

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

## Phase 5：各联盟平台 USD 账户（**按需申请，商业化阶段触发**）

> ⚠️ **公开化精简（2026-08-27）**：本节原含具体平台名单（Hetzner / DigitalOcean / Porkbun / WildCard）+ 个人本地路径 + WorldFirst 实测结论。公开化后改为「多账户管理通用框架」，具体平台名由你商业化时按实际联盟伙伴填充。

### 多账户管理通用原则

- 一个 USD 收款账户通常对应一个**指定**收款平台（业内常识，以平台官方文档为准）。
- 后续每个联盟对接时 → 在平台控制台单独申请一个新 USD 账户。
- 战略意义：无需提前批量开通，刚需时再开，零复杂度。

### 多账户管理建议（公开版）

- 平台控制台会给每个 USD 账户起名（建议格式：`USD-<Platform>` 便于识别）
- 每个账户单独保存 4 字段截图到**本地保密目录**（按自己命名习惯，不公开具体路径）
- `hugo.toml` `[params.payout.<platform-slug>]` 段按需扩展，不挤一个段里

---

## ⚠️ Phase 3 决策记录（可选步骤的取舍）

**Phase 3 的设计**：把 4 字段写入 `hugo.local.toml` override 文件，便于未来 Money Page 文章用 `.Site.Params.Payout.<platform>.*` 复用数据。

**省略的代价**（当 Phase 3 跳过时）：
- 未来 Money Page 文章展示「本博客收款走 USD / 合作行 X」类信任标识时，需要**手抄硬编码**（每篇文章贴一次）
- 收款政策变了、合作行变更 → 需要 grep 替换 N 篇文章

**何时回补 Phase 3**：
- 商业化阶段产出 ≥ 3 篇 Money Page 文章后，如果发现硬编码重复成为负担 → 重启此 Phase

**脚手架已就位**：
- 确保 `hugo.local.toml` 在 `.gitignore` 中（避免误 commit）
- §3.2 参数名列表保留在文档中（具体值由你从平台控制台复制）

---

## ⚠️ 避坑提醒（5 条硬约束）

> 与 `docs/think-payment.md` §六 一致。

1. **拼音 / 英文姓名一致性**：平台注册的收款人姓名必须与上游平台 payout name **完全一致**（颠倒字母、错大小写、空格差异 = 拒收或退回）
2. **不要选电商类型**：审核会以「实物贸易」为由要你提供物流单据（数字服务无单 = 失败）
3. **不要大额突然到账**：首次单笔 >$1000 会触发复审，可能冻结 7-15 天
4. **当地年度便利化额度**：每年累计结汇超过当地年度便利化额度需主动申报；具体口径以平台服务贸易代申报逻辑为准
5. **8-12 个月复核**：USD 账户政策会变，每年至少复核一次 Routing/SWIFT 是否仍有效

---

## 🔄 冗余备份（主平台故障时的应急通道）

> **公开化精简（2026-08-27）**：本节原推荐 WorldFirst 多账户为主 + Payoneer/Wise/PingPong/PayPal 备用，含具体启用条件。公开化后改为通用「冗余备份决策框架」——具体平台选择以你主用平台 + 当地合规要求为准。

**通用原则**：
- 主平台故障 ≠ 主平台临时审核慢 → 前者可启动冗余，后者建议等待
- 冗余通道应在主平台运行良好时预先开通并 idle（避免主平台真故障时两手空空）
- 选择冗余通道时优先考虑：跨平台 KYC 资料是否可复用、币种账户开通成本、提现费率

---

## ✅ 完成定义参考（公开版）

> ⚠️ **公开化精简（2026-08-27）**：原 §「完成定义（M3 = 100% 收官标志）」含个人完成日期 + M3 状态 + 本地路径——公开化前删除。本节改为通用「完成度定义参考」。

**Phase 1-2（必做，账户上线）**：
- [ ] USD 收款账户开通成功（控制台状态正常）
- [ ] 4 字段全部记录 + 截图保存至本地保密目录

**Phase 3（可选，前端展示复用）**：
- [ ] `hugo.local.toml` 写入 4 字段（仅在需要 Money Page 信任标识时做）

**Phase 4（推迟到商业化阶段）**：
- [ ] 上游平台（AdSense / 联盟）后台绑定 USD 收款账户
- [ ] 测试款到账验证
- [ ] 首次实际款到账

**Phase 5（按需触发）**：
- [ ] 各联盟平台 USD 账户（按对接顺序逐个申请）

---

## 📞 卡点求助

如遇以下情况，先记录具体报错截图，再问 Claude：

- 控制台看不到 USD 申请入口 → 可能账号类型不对
- 上游平台拒绝绑定 → 检查姓名拼音一致性 + Routing 格式
- 测试款超过 14 天未到账 → 检查 Routing Number 是否填写正确
- 提现时弹出「需补充材料」→ 一般是首次大额触发，按指引补提交即可