---
name: mock-reader-feedback
description: Generates structured reader feedback report for a HeimaEden blog post by role-playing one of 5 personas (P1-P5) defined in docs/mock-reader-personas.md. Default reads docs/persona-data.json cache (mock data) and writes YAML feedback report to docs/feedback/. Use when user says "模拟读者反馈" / "mock reader feedback" / "P1 反馈" / "试读一下" / "pretend to be a reader".
---

# mock-reader-feedback

HeimaEden 文章试读 SOP：基于 5 个 persona 角色 + persona 数据（cache 或 live）生成结构化反馈，输出到 `docs/feedback/<article-slug>-<persona-id>.md`。

## 触发场景

- 用户说："模拟读者反馈" / "mock reader feedback" / "P1 反馈" / "试读一下" / "pretend to be a reader"
- 任何一篇已发布长文（≥500 词）需要审稿时
- 翻译前 → zh-final-refactor 阶段后 → 翻译前用 persona 找出问题
- 翻译后 → translate-zh-to-en 阶段后 → 验证英文版对海外读者的接受度

## 不要做的事

- ❌ **不要把 persona 写成"我自己"** — 破坏 prompt 通用性（见 `docs/mock-reader-personas.md` 反 pattern）
- ❌ **不要把反馈当作用户验收** — 这是辅助 AI 审稿，最终决策由用户根据真实反馈 + 直觉判断
- ❌ **不要写"完美无缺"反馈** — 每个 persona 必须给出至少 1 个具体修改建议；5⭐全赞 = 角色失真
- ❌ **不要修改原文** — 输出 YAML 报告，不动 `.md` 源文件
- ❌ **不要自动 commit feedback 报告** — 留给用户决定是否归档

## 工作流（7 步）

### 1. 读取必备文件

```bash
# 必读：persona 与数据
docs/mock-reader-personas.md    # 5 persona prompt 模板
docs/persona-data.json          # MVP=MOCK 数据 / V1.1+=real data

# 必读：目标文章
content/posts/<category>/<article-slug>.md
```

**自查**：
- `persona-data.json` 存在 → 用 `python3 -c "import json; json.load(open('docs/persona-data.json'))"` 验证
- `mock-reader-personas.md` 存在 → 5 个 persona 完整
- 文章存在 → 读取 front matter + body

### 2. 选择 persona

用户可指定：
- `--persona=P1`（P1-P5 显式）
- `--persona=P5`（默认：选型决策者，最挑剔）

未指定时**默认 P5**（反馈质量最高，强迫发现真正问题）。

可选 `--multi`（V2 实现）一次性跑 P1-P5 多 persona 对比。

### 3. 加载数据（默认 cache / 显式 --live）

**默认（推荐）**：直接读 `docs/persona-data.json`。
```bash
./scripts/fetch-persona-data.sh    # 验证 cache 状态
```

**--live 模式**：用户主动要求刷新数据（不是默认 — 防 API quota）。
```bash
./scripts/fetch-persona-data.sh --live --source=gsc
```

**GSC 接入前**：cache 全是 `[MOCK]`，prompt 必须明确 "[MOCK]" 标签，不假装真实。

### 4. 构造 persona 角色 prompt

将以下 3 块拼接为 system prompt：

```
你是 HeimaEden 博客 <P1-P5 人格标签>。背景：<docs/mock-reader-personas.md 中 P1-P5 描述>。

实时数据（来自 docs/persona-data.json 中的 <persona-id>）：
- 地理分布：<geo_distribution>
- 设备分布：<device_split>
- 典型搜索词：<top_search_queries>
- 优先阅读：<top_pages_visited>
- 社区活跃：<community_signals>

阅读场景：<primary_intent>（如 deploy-fixing / selection-decision）

你的反馈风格：<feedback_style>（如 direct_technical / reddit-grade / one-liner）

阅读 [文章标题] 后，按下面的 YAML schema 输出反馈。
```

**重要**：
- 必须明确"你的反馈风格"——避免 P3 写成长文（one-liner）或 P4 写评论（silent）
- 如果数据是 `[MOCK]`，在 prompt 中显式标注 `[MOCK]`，避免假装真实地理数据

### 5. 运行 persona 模拟

**输入**：上面 4 拼接的 prompt + 完整文章正文（不读 front matter）

**思考过程**（thinking 块）：
1. 这个 persona 在这种 `primary_intent` 下，是不是会真的点开这篇文章？
2. 文章的 hook / 标题 / lead 是否匹配 `<top_search_queries>`？
3. 看到第 3 屏时，会不会有"太长了 / 跑题了"的退订冲动？
4. 反馈的"修改建议"必须落到具体段落（不是泛泛"加更多例子"）

**输出 YAML schema**（必须严格遵守）：

```yaml
persona_id: P1
article_slug: <article-slug>
read_at: <ISO timestamp>
intent: <primary_intent>
data_source: MOCK | GSC | CF | REDDIT | PLAUSIBLE
rating: 1-5
verdict: stay | skim | bounce
key_points:
  - …（3-5 条，正面 + 负面）
friction_points:
  - paragraph: "§3 第四段"
    issue: "报错例子没有完整堆栈"
    suggested_fix: "补 stack trace 头部 5 行"
quote_feedback: |
  "如果我是搜索这个报错进来，我希望在 3 屏内看到 root cause。"
session_signals:
  - 估算停留时长
  - 估算是否收藏
  - 估算是否订阅
```

### 6. 写到 feedback 目录

```bash
# V1: 直接写，不创建长期目录（先放 tmp，commit 时再决定归档）
docs/feedback/<article-slug>-<persona-id>.md
```

**文件 front matter**（YAML inside the report, not TOML — 这是 markdown body）：

```markdown
---
schema: mock-reader-feedback/v1
persona_id: P1
article_slug: <article-slug>
read_at: 2026-08-20T22:30:00Z
intent: deploy-fixing
data_source: MOCK
rating: 4
verdict: stay
---

<!-- 上面 YAML block + 完整 persona 思考过程 + 关键 quote + 修复建议 -->
```

**不要 commit**（默认）——GIT 用户主动 git add 才入仓库。

### 7. 自检 + 输出

- ✅ 5 个 key_points 至少 1 负面？
- ✅ friction_points 至少 1 条具体段落？
- ✅ rating < 5？（避免全赞人设）
- ✅ YAML 严格遵循 schema？
- ✅ 写到了 docs/feedback/？
- ✅ **多样性自检（D12 SOP）**：跑 `grep -h '^prompt_type' content/posts/**/*.md | tail -5`（最近 5 篇 prompt_type 分布）；若 ≥ 4 篇同类型 → 在 persona 反馈里加一句「近 N 篇同 prompt_type，Scaled Content 风险」警告（参考 `docs/writing-prompts.md` §一）

输出到用户：
- 简短的 1-2 句话总评（如 "P4 觉得报错部分太薄，需要补 stack trace"）
- 反馈文件路径
- 是否建议 commit（用户决定）

## 案例（典型 P1 强华陆 dev 反馈，节选）

```yaml
persona_id: P1
article_slug: hugo-cloudflare-pages-pitfalls
read_at: 2026-08-20T22:30:00Z
intent: deploy-fixing
data_source: MOCK
rating: 4
verdict: stay
key_points:
  - "实测 7 个坑 + 真实复现 — 不像 AI 农场"
  - "ERR_TOO_MANY_REDIRECTS 修复段命令可直接复制"
  - "封面用的是 Unsplash 概念图，§7 才出现真实截图 — 顺序有点违和"
  - "缺少 §3.4 'redact-image' 工具的 install 命令（只引用了文档）"
friction_points:
  - paragraph: "§3 ERR_TOO_MANY_REDIRECTS"
    issue: "截图前少了 PII 脱敏命令的实际调用"
    suggested_fix: "在 §3.4 后补 `pip3 install --user Pillow` + 红框坐标示例"
  - paragraph: "§6 Pros & Cons 表格"
    issue: "Hetzner 列价格是 2024 数据，2026 已涨价"
    suggested_fix: "加 [已停办] 标注或更新到 2026 实测价"
quote_feedback: |
  "如果我是搜 ERR_TOO_MANY_REDIRECTS 进来的，标题已经有命中词。但读到 §3 之前
  要点 3 屏 Intro — 建议 Intro 砍到 200 词。"
```

## 触发后置动作

- 用户说"提交反馈" → 用 commit-with-prefix skill，prefix=`[docs]`，scope `feedback`
- 用户说"基于反馈改文章" → 走 zh-final-refactor skill（CM 阶段 4）
- 用户说"再跑 P1/P3 对比" → 重复 5-7 步，输出对比表

## 依赖与已知限制

- **依赖**：`docs/mock-reader-personas.md`、`docs/persona-data.json`、`scripts/fetch-persona-data.sh`
- v1 限制：单 persona，无 multi-persona 对比、无 A/B 测试
- v1.1 计划：GSC live 接入（OAuth service account 完成后）
- v1.2 计划：CF Analytics（访问 + 设备 + referrer）
- v1.3 计划：Reddit / HN / GitHub 公开 API
- v1.4 计划：Plausible / Umami 博客原生
- v2 计划：multi-persona 对比、自动 highlight friction points

## 反 pattern（已踩坑）

- ❌ 把反馈写得"完美无缺"——5⭐ + 0 friction = persona 失真
- ❌ 让 P3 写"长篇技术评论"——P3 是 one-liner 人格
- ❌ 反馈里用 testimonial 营销腔（"Would highly recommend..."）— P1/P4 反感
- ❌ 反馈报告 commit 进 content/posts/（污染文章目录）
- ❌ 改动原文后没存档 persona 反馈（无法回溯"为什么改"）

## 完整示例：用户说"对 hugo-cloudflare-pages-pitfalls 跑 P1 反馈"

1. 读 `docs/mock-reader-personas.md` → 找到 P1 描述
2. 读 `docs/persona-data.json` → P1 块的 geo / device / queries
3. 读 `content/posts/static-site/hugo-cloudflare-pages-pitfalls.md` → 全文
4. 构造 P1 prompt（中国大陆 dev + 部署优先 + 直白技术反馈）
5. 输出 YAML 报告
6. 写到 `docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md`
7. 输出："P1 对本文打分 4/5，主要反馈 §3 缺 PII 脱敏命令行 + §6 表格价格过期。报告已写，未 commit。"
