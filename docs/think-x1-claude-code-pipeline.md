# X1 Claude Code 编辑流水线：选题规划纪要（think-x1-claude-code-pipeline.md）

> **来源**：Claude Opus 4.6 + 用户（2026-08-22，D11）
> **状态**：规划中
> **关联文章**：A2（X1 主文章，状态从「待选」升级为「推荐中」）/ Y1 / Y2 标题延后敲定
> **配套**：`docs/article-writing-workflow.md`（标准 TCM SOP）
> **索引**：`docs/think.md`（思考纪要索引）

---

## 1. 决策摘要

- **叙事框架**：编辑流水线（主轴是「我的工作流」，AI 在背后；非「AI 帮我写」）
- **主关键词**：Claude Code workflow（避开 "AI writing" 红海）
- **节奏**：拆 2 篇（X1 主文章 + Y1/Y2 系列单篇）
- **mock-reader 时机**：写完 [draft] 后跑（标准 SOP）

---

## 2. 背景与触发

用户在 2026-08-22 D11 会话中提出选题：「想写一篇关于自己博客写作 SOP 的长尾文章」。提出 5 个要点：

1. 与 about.md 隐性叙事的兼容
2. 联网验证主题热度 + mock-reader 反馈预演
3. SOP 内容 + 演进史 + 未来方向
4. skills 单拆成系列放 ai-agent
5. 请专业站长视角补充

本次会话已完成：① 事实校准（用户误以为有「未使用 AI」声明，实际无）；② 5 个要点的逐项分析；③ 10 个站长视角盲点补充；④ 3 方角色模拟；⑤ AskUserQuestion 决策确认。

---

## 3. 关键事实校准

| 项 | 用户假设 | 实际真相 | 处理 |
|---|---|---|---|
| about.md「未使用 AI」声明 | 用户认为有 | **实际无直接声明**；但有「实操导向」隐性契约 | 通过选 A 框架（编辑流水线）兼容 |
| privacy-policy.md "zero-AI-training stance" | 易被误读为「作者不用 AI」 | 实际是数据不喂 AI 训练 | 不动；本文 §方法论边界 显式区分 |
| affiliate-disclosure.md "personally used" | 不涉及本文 | 仅作为基调参考 | 不动 |

---

## 4. 风险与边界

### 4.1 SEO 风险

- **Google HCU 持续打击 "AI 内容自白" 主题**：避免 "AI wrote my content" 措辞，改用 "AI-augmented editorial pipeline" / "human-in-the-loop content production"。
- **"AI tools" 类话题 AdSense 审核风险高**：在文章内显式 first-hand evidence（commit hash、mock-reader 报告链接），EEAT 拉满。

### 4.2 叙事风险

- **about.md 隐性契约**：文章开头不写「我用 AI」，写「我用 11 天把自己从一周一篇变成两天一篇」；文末 §方法论边界 主动披露 AI 协助 vs 人工把控。
- **时间窗口太短（11 天）的演进史**：坦诚，标题可加 "11-day experiment" 或抽象化为 "6 次主要迭代"。

### 4.3 内容架构

- **主轴 = 演进史**，不是 SOP 6 阶段本身（避免与网上同质内容撞车）
- **差异化点**：「为什么这 6 阶段是这样、不是那样」的决策故事（不是「6 阶段怎么跑」的操作手册）

### 4.4 affiliate 定位

- **本文不是 Money Hook**：无联盟植入价值
- 定位：品牌资产 + AI-Agent 集群流量入口 + 站内互链中心

---

## 5. 主文章 X1 章节骨架

```
1. §Intro（150 词）：11 天、6 次主迭代、从 6 小时到 2 小时/篇
2. §现状：当前 6 阶段 TCM SOP（每阶段 50 字，简洁不展开）
3. §演进史（核心章节）：4-5 个迭代节点
   - D0-D3：纯人工时代，Stack Overflow 排错
   - D4：第一次引入 AI + commit bc9a369 撤销事件（具体踩坑）
   - D5：双篇并行 + lint_allow 临时方案
   - D10：mock-reader-feedback skill 引入（commit 7d2cdee）
4. §当前已知问题：3-5 个痛点（呼应「反完美」）
5. §未来 6 个月方向：2-3 个待调整（呼应「持续演进」）
6. §方法论边界：诚实声明 AI 做什么 / 我做什么
7. §结语 + 系列预告（指向 Y1 / Y2）
```

**目标字数**：1,400-1,800 词
**联盟预留**：否
**分类**：AI-Agent（部署类）
**对应 topic-pool.md 位置**：复用 A2 entry（A2. How to integrate Claude Code with Hugo blog for auto content publishing）

---

## 6. 系列单篇 Y1/Y2 决策延后

**用户决策**（2026-08-22 D11）：Y1/Y2 标题暂不确定，**等 X1 完成后再讨论**。

候选（仅占位，不敲定）：

- Y1 候选：mock-reader-feedback deep dive
- Y2 候选：pre-commit gates OR redact-image PII 脱敏流程

未来决策产物另起：`docs/think-y1-*.md` / `docs/think-y2-*.md`。

---

## 7. 下游动作清单

| 序 | 动作 | 触发条件 | 关联 commit 前缀 |
|---|---|---|---|
| 1 | 更新 topic-pool.md A2 entry 加反向链接 + 状态升级 | ✅ 本次会话已完成（待用户 ack） | `[docs]` |
| 2 | 更新 think.md 索引页加新列 + 本次 entry | ✅ 本次会话已完成（待用户 ack） | `[docs]` |
| 3 | 写 X1 [draft] | 用户 ack 存档 + 敲定 X1 主标题 | `[draft] X1-claude-code-pipeline` |
| 4 | 跑 mock-reader P1/P3/P5 | [draft] 完成 | `[docs]` |
| 5 | 消化 mock-reader → [zh-final] | mock-reader 反馈完成 | `[zh-final]` |
| 6 | 翻译 + 发布 | 用户 ack | （无前缀） |
| 7 | 决策 Y1/Y2 标题 | X1 已发布后新会话 | 新 `think-{y1/y2-slug}.md` |

---

## 8. mock-reader 预期反馈（基于 P1/P3/P5 persona 历史报告预判）

| Persona | 预期关注 | X1 应该给的内容 |
|---|---|---|
| P1（强华陆 dev） | 命令行截图 / EACCES 排错 / 国内网络踩坑 | §演进史 D5 节点补「EACCES 类具体排错」 |
| P3（西方 indie hacker） | 30 秒决策 / ROI / 选型表 | §选型表 + §对比表格优先放首屏 |
| P5（选型决策者） | TCO 量化 / 退出成本 | §演进史 + §当前已知问题 |

**历史教训**：claude-code-cli-setup-indie-blog 已被 P3 反馈「标题 AI 农场味 + 首屏错位 + dev marker 泄漏」——X1 必须避开这些坑：

- 标题不带 "2026" / "AI" 等农场味词
- §引言不写「读者分流框架」
- 翻译 commit 前清所有 dev-internal marker

---

## 9. 引用来源

- 用户原始讨论：[本会话上下文 D11]
- `docs/think-strategy.md` §三-5 四集群约定
- `docs/article-writing-workflow.md` 标准 TCM SOP
- `docs/topic-pool.md` A2 entry（复用）+ AI-Agent 集群现状
- `docs/feedback/claude-code-cli-setup-indie-blog-{P1,P3,P5}.md` 历史 mock-reader 报告
- `docs/mock-reader-personas.md` persona 定义
- `README.md §6 D10 状态校准条目
- `CLAUDE.md §3.8` 协作 SOP / `§3.9` 中文会话铁律

---

## 📝 版本历史

- **2026-08-22 (D11)**：首次创建。本会话讨论决策入档。