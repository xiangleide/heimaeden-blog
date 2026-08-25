# GEO 写作模块（geo-writing-module.md）

> **目的**：让 HeimaEden 文章在 2026 年 Google AI Overviews / ChatGPT / Perplexity 三类生成式引擎中**被引用**，而非仅被点击。GEO = Generative Engine Optimization，与 SEO 同权重。
>
> **触发决策**：D12（2026-08-25）A1 决策 —— 第一篇按 GEO 模板落地：选题 = **B2 P1 WorldFirst 实战**（`docs/topic-pool.md` §B2 行 322）。
>
> **数据来源**：`docs/heimaeden.com运营方案与交叉验证文档.md` §二 风险 2 —— AI Overviews 已出现在 > 25% 的 Google 搜索；触发时零点击率 83%；Pew 调研摘要内引用链接 CTR 仅 1%；2026 前 4 个月美国 68% Google 搜索零点击。

---

## 一、GEO 与 SEO 的区别（写入每篇 [draft] 时的自检表）

| 维度 | SEO（点击导向） | GEO（引用导向） |
|---|---|---|
| **目标** | 用户点进站 | 引擎在摘要里**直接引用**你的句子 |
| **衡量** | GSC 展示量 / 点击 / 排名 | 被 ChatGPT / Perplexity 引用次数（V1 mock：mock-reader P5 反馈含 "是否值得被摘要" 评分） |
| **结构信号** | Title / Description / H1-H3 | **结论前置** + **FAQ 区块** + **代码块语义完整** |
| **失败模式** | 排名低 / 收录慢 | 摘要里没你 / 引用了别人 |

---

## 二、GEO 文章的硬结构（5 段式骨架）

> **应用范围**：所有 Money Hook 候选（B2 P1 WorldFirst 实战 / 后续高商业意图文章）。报错类集群文章**可选**——报错类查询在 AI 摘要里覆盖薄，但代码块语义完整仍是护城河。

### 段 1 — 结论前置（lead 段，80-120 词）

**结构**：第一段直接给出"本文解决 X / 适用 Y / 不适用 Z"。

**模板**：

```markdown
## TL;DR

本文解决：{1 句问题定义}
适用：{1 句场景 + 1 句前置条件}
不适用：{1 句反向边界}
核心命令：{一行可直接复制的命令或配置}
预计耗时：{X 分钟}
```

**反面教材**：

```markdown
## 引言

在当今快速发展的技术世界中，我们常常需要面对各种各样的挑战...
（500 字铺垫后才进入正题）
```

### 段 2 — 前提条件（前置块）

- 列表式，每条一行
- 含版本号（"Hugo v0.164.0+extended" 而非 "新版 Hugo"）
- 含账号 / 工具 / 操作系统

### 段 3 — 步骤 N（主线操作）

- 每步标题明确动词
- 代码块语言必标（```bash / ```toml / ```yaml）
- 代码块注释解释**为什么**（不只**做什么**）
- 截图标注位保留（与 [draft] SOP 一致）

### 段 4 — FAQ 区块（**GEO 核心**）

**硬规矩**：每篇 GEO 试点文必须含 ≥ 3 条 FAQ，**且**带 Schema 标记。

**结构**：

```markdown
## FAQ

### Q1: {模仿真实用户问句，含疑问词}

{2-3 句直答 + 代码块 / 列表}

### Q2: ...

### Q3: ...
```

**Schema 模板**（Hugo shortcode，待新建 `layouts/_shortcodes/faq-schema.html`）：

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "{{ .Get "q1" }}",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "{{ .Get "a1" }}"
      }
    }
    // ... Q2, Q3
  ]
}
</script>
```

**V1 简化**：如果短代码未落地，可在 front matter 注入 `faq` 数组 + 模板渲染。详见 §五 待办。

### 段 5 — 总结 + 触发下一动作（CTA）

- 1 段总结（≤ 100 词）
- 1 行 CTA：下一篇预告 / 工具页链接 / 联盟链接

---

## 三、代码块语义完整（被引用的护城河）

**GEO 引用偏好**：能"复制即用"的完整代码块优先于"看个大概"的截断示例。

| 维度 | ❌ 反例 | ✅ 正例 |
|---|---|---|
| **上下文** | `wrangler pages deploy` | `wrangler pages deploy ./public --project-name=heimaeden-blog --branch=main` |
| **注释** | 无 | `# 输出：Deploying... ✅ Success` |
| **预期输出** | 无 | 代码块后立即给 3-5 行预期输出 |
| **错误兜底** | 无 | "若返回 `Authentication error [code: 10000]`，检查 `.wrangler/config/default.toml` 的 `account_id`" |

---

## 四、可被 AI 引用的"指纹段"（与 E-E-A-T 同源）

> 每篇 GEO 试点文必须在 §步骤 N 或 §已知问题 出现至少 1 段"指纹段"——AI 引擎偏好引用**第一人称具体场景**而非泛泛描述。

**模板**：

```markdown
> **【指纹段】**
> 我自己在做这件事时，{具体场景}。{踩坑细节，包含版本号 / 时间戳 / commit hash}。
> 与 Stack Overflow 最高赞答案不同，本文的方法是 {差异化点}，原因是 {原因}。
```

**反面教材**：

```markdown
> 一些开发者可能会遇到这个问题，建议尝试...
（去人格化，AI 引擎不会引用）
```

---

## 五、待办与依赖

### 待新建文件

- `layouts/_shortcodes/faq-schema.html` —— FAQ Schema 自动渲染
- `data/faq-template.json`（可选）—— FAQ 模板数据驱动

### 与 SOP 衔接

- `docs/article-writing-workflow.md` §5.2.1 已 reference 本模块
- `docs/topic-pool.md` §B2 行 321-322 已标注 "GEO 试点"
- `docs/mock-reader-personas.md` P5 — 增加 "GEO 引用友好度" 维度评分

### V1 验证流程（MOCK）

1. AI 按本模块写完 B2 P1 WorldFirst 实战
2. 跑 `mock-reader-feedback` skill（persona=P5），在 `docs/feedback/<slug>-P5-GEO.md` 产出报告
3. 自检清单（§七）跑一遍，任一失败回炉

---

## 六、与 SEO 的边界（**不要把 SEO 思维套进 GEO**）

| SEO 思维 | GEO 反向 | 原因 |
|---|---|---|
| "标题前置关键词" | "结论前置 + 疑问词 FAQ" | AI 引擎偏好 Q&A 结构 |
| "加内部链接锚文本" | "FAQ 答案直接完整" | 摘要窗口一次只引用一段，锚文本无用 |
| "堆 meta description" | "首段就是 meta" | GEO 引擎直接读首段作引用源 |

**简言之**：SEO 是给爬虫看结构，GEO 是给 AI 看可摘录段落。

---

## 七、自检清单（V1，每篇 GEO 试点文 commit 前跑）

- [ ] **段 1（TL;DR）存在 + ≤ 120 词 + 含核心命令**
- [ ] **段 2（前提条件）每条 1 行 + 含版本号**
- [ ] **段 3（步骤 N）代码块语言全标 + 注释解释 why + 预期输出**
- [ ] **段 4（FAQ）≥ 3 条 + Schema 标记**
- [ ] **段 5（总结 + CTA）≤ 100 词**
- [ ] **指纹段 ≥ 1 段**（含具体场景 + 差异化点）
- [ ] **无 SEO-spam 短语**（"ultimate guide" / "you won't believe"）
- [ ] **hugo --gc 通过 + lint-post.sh 0/0**
- [ ] **mock-reader P5 反馈 ≥ 3.5⭐**（V1.1 引入 GEO 引用友好度评分后门槛拉高）

任一失败 → 回炉对应段，不 commit。

---

## 八、参考

- `docs/heimaeden.com运营方案与交叉验证文档.md` §二 风险 2（GEO 数据来源）
- `docs/topic-pool.md` §B2（P1 WorldFirst 实战选题详情）
- `docs/article-writing-workflow.md` §5.2.1（GEO 优先试点 mention）
- `CLAUDE.md` §3.1（tone: factual + first-person-conversational，与 GEO 指纹段同源）
- `CLAUDE.md` §3.8 rule 5（翻译不增删事实 —— GEO 试点时同样适用）