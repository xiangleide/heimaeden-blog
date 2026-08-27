# GEO 写作模块（geo-writing-module.md）

> **目的**：让 HeimaEden 文章在 2026 年 Google AI Overviews / ChatGPT / Perplexity 三类生成式引擎中**被引用**，而非仅被点击。GEO = Generative Engine Optimization，与 SEO 同权重。
>
> **触发决策**：D12（2026-08-25）A1 —— 第一篇按 GEO 模板落地：选题 = **B2 P1 WorldFirst 实战**（`docs/archive/topic-pool-2026-08-27-archive.md` §B2 行 322）。
>
> **数据来源**：`docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 2（AI Overviews > 25% / 零点击 83% / CTR 1%）。

---

## 一、GEO 与 SEO 的区别

| 维度 | SEO（点击导向） | GEO（引用导向） |
|---|---|---|
| **目标** | 用户点进站 | 引擎在摘要里**直接引用**你的句子 |
| **结构信号** | Title / Description / H1-H3 | **结论前置** + **FAQ 区块** + **代码块语义完整** |
| **失败模式** | 排名低 / 收录慢 | 摘要里没你 / 引用了别人 |

---

## 二、GEO 文章的硬结构（5 段式骨架）

> **应用范围**：Money Hook 候选（B2 P1 WorldFirst 等）。报错类集群文章**可选**——报错查询在 AI 摘要里覆盖薄，但代码块语义完整仍是护城河。

### 段 1 — 结论前置（lead 段，80-120 词）

第一段直接给「本文解决 X / 适用 Y / 不适用 Z」。反面教材 = 500 字铺垫才进正题。

```markdown
## TL;DR

本文解决：{1 句问题定义}
适用：{1 句场景 + 1 句前置条件}
不适用：{1 句反向边界}
核心命令：{一行可直接复制的命令或配置}
预计耗时：{X 分钟}
```

### 段 2 — 前提条件（前置块）

列表式，每条 1 行；含版本号（"Hugo v0.164.0+extended" 而非 "新版 Hugo"）+ 账号 / 工具 / OS。

### 段 3 — 步骤 N（主线操作）

每步标题明确动词；代码块语言必标（```bash / ```toml / ```yaml）；注释解释**为什么**（不只**做什么**）；截图标注位保留（与 [draft] SOP 一致）。

### 段 4 — FAQ 区块（**GEO 核心**）

每篇 GEO 试点文必含 ≥ 3 条 FAQ + Schema 标记。

```markdown
## FAQ

### Q1: {模仿真实用户问句，含疑问词}
{2-3 句直答 + 代码块 / 列表}

### Q2: ...   ### Q3: ...
```

**Schema 模板**（V1 简化：front matter 注入 `faq` 数组 + 模板渲染；完整 shortcode `layouts/_shortcodes/faq-schema.html` 待新建）：

```html
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
  {"@type":"Question","name":"{{ .Get "q1" }}","acceptedAnswer":{"@type":"Answer","text":"{{ .Get "a1" }}"}}
]}
</script>
```

### 段 5 — 总结 + CTA

总结 ≤ 100 词 + 1 行 CTA（下一篇预告 / 工具页 / 联盟链接）。

---

## 三、代码块语义完整（被引用的护城河）

| 维度 | ❌ 反例 | ✅ 正例 |
|---|---|---|
| **上下文** | `wrangler pages deploy` | `wrangler pages deploy ./public --project-name=heimaeden-blog --branch=main` |
| **注释** | 无 | `# 输出：Deploying... ✅ Success` |
| **预期输出** | 无 | 代码块后立即给 3-5 行预期输出 |
| **错误兜底** | 无 | "若返回 `Authentication error [code: 10000]`，检查 `.wrangler/config/default.toml` 的 `account_id`" |

---

## 四、可被 AI 引用的「指纹段」（与 E-E-A-T 同源）

每篇 GEO 试点文必须在 §步骤 N 或 §已知问题 出现 ≥ 1 段——AI 引擎偏好引用**第一人称具体场景**而非泛泛描述。

```markdown
> **【指纹段】**
> 我自己在做这件事时，{具体场景}。{踩坑细节，含版本号 / 时间戳 / commit hash}。
> 与 Stack Overflow 最高赞答案不同，本文的方法是 {差异化点}，原因是 {原因}。
```

反面 = 「一些开发者可能会遇到这个问题，建议尝试...」（去人格化，AI 引擎不会引用）。

---

## 五、自检清单（V1，每篇 GEO 试点文 commit 前跑）

- [ ] 段 1 TL;DR ≤ 120 词 + 含核心命令（→ §二段 1）
- [ ] 段 2 前提条件每条 1 行 + 含版本号（→ §二段 2）
- [ ] 段 3 步骤 N 代码块语言全标 + 注释 why + 预期输出（→ §二段 3 + §三）
- [ ] 段 4 FAQ ≥ 3 条 + Schema 标记（→ §二段 4）
- [ ] 段 5 总结 ≤ 100 词 + CTA（→ §二段 5）
- [ ] §四 指纹段 ≥ 1 段
- [ ] 无 SEO-spam 短语（"ultimate guide" / "you won't believe"）
- [ ] hugo --gc 0 errors + lint-post.sh 0/0
- [ ] mock-reader P5 反馈 ≥ 3.5⭐

任一失败 → 回炉对应段，不 commit。

---

**一句话总结**：SEO 是给爬虫看结构，GEO 是给 AI 看可摘录段落。

**参考 / 待办**：详细数据 → `docs/archive/运营方案与交叉验证文档-2026-08-27.md` §二 风险 2；选题详情 → `docs/archive/topic-pool-2026-08-27-archive.md` §B2；CLAUDE.md §3.1（tone 同源）/ §3.8 rule 5（不增删事实）；FAQ Schema shortcode 待新建。