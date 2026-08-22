# 思考纪要索引（think.md）

> **本目录作用**：存放我与其他 AI 智能体（含境内、境外模型）讨论产生的内容，供 Claude 跨会话快速读取，并与 Claude 当下反馈形成互补。
> **约定**：Claude 不修改这里的原始纪要；如需调用，回复中显式引用文件名 + 段落。

---

## 📁 文件清单

| 文件 | 来源 | 状态 | 关联文章 / 下游 | 用途 |
|---|---|---|---|---|
| `think-strategy.md` | 境内 AI（2026-08-14） | 持续维护 | — | 综合战略纪要：赛道、变现、节奏、最终结论 |
| `think-templates.md` | 境内 AI（2026-08-15） | 持续维护 | 全部文章 | 博客统一文章模板 + 30 条英文长尾关键词 |
| `think-payment.md` | 境内 AI + Claude 整合（2026-08-15） | 持续维护 | `remote-payment/` 集群 | 境外收款模块深度展开 + 35 标题 + 风险规避 |
| `think-x1-claude-code-pipeline.md` | Claude + 用户（2026-08-22, D11） | **规划中** | A2 (X1) / Y1 / Y2 延后 | Claude Code 编辑流水线选题规划（叙事框架 / 关键词 / 节奏决策）|
| `think-issue-rejected-2026-08-19.md` | 境内 AI（D8） | 已拒绝（untracked）| — | 任务书违规归档（违反 §3.8 rule 5/6）|
| `worldfirst-usd-checklist.md` | Claude（2026-08-15） | 持续维护 | M3 收官 / M5 触发 | WorldFirst USD 账户开通现场 checklist（含备份通道、避坑、完成定义）|

> **状态枚举**：`规划中`（讨论产物未触发动作）/ `执行中`（已触发 X1 [draft] 写作）/ `已归档`（关联文章已发布，本次讨论完成历史使命）/ `持续维护`（长期参考文档）/ `已拒绝`（同 think-issue-rejected 样式，untracked）。

---

## 🕐 版本历史

- **2026-08-14**：首次写入综合战略 + 选题模板（合并于 think.md 单文件）
- **2026-08-15**：新增境外收款模块；按"主题拆分"重构为 4 文件结构
- **2026-08-15**：新增 `worldfirst-usd-checklist.md`（D4 进度同步：WorldFirst 实名认证完成 + USD 账户开通操作手册）
- **2026-08-21 (D10)**：新增 `think-issue-rejected-2026-08-19.md`（任务书违规归档，untracked）
- **2026-08-22 (D11)**：新增 `think-x1-claude-code-pipeline.md`（Claude Code 编辑流水线选题规划）；索引表加 `状态` + `关联文章/下游` 两列，建立讨论类纪要归档惯例

---

## 💡 Claude 引用方式

当 Claude 在回复中提到「参见 `think-payment.md` §五标题 #28」时，即指本目录下对应文件的具体段落。
Claude 的工作建议 ≠ 这里的原始纪要；两者互补，不冲突。