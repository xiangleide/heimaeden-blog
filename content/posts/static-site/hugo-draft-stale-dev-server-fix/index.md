+++
title = "Why My Hugo Draft Still Shows Up After I Moved It to _drafts/"
description = "Hugo dev server fallback serves stale public/ HTML after moving posts to _drafts/. 3-layer root cause + complete cleanup commands."
date = 2026-08-27T00:00:00Z
draft = true
tags = ["Hugo", "Static Site", "Troubleshooting", "Dev Server"]
categories = ["Static-Site"]
prompt_type = "A"

showToc = true
TocOpen = true

[cover]
  # D19 M2 阶段：AI 生成 cover (Variant V1 隐喻插画) 替换 step-6 临时 cover
  # 路径形式：resources path = assets/images/... 去掉 assets/ 前缀，无前导 / (PaperMod cover.html line 22 absURL fallback)
  image = "images/static-site/hugo-draft-stale-dev-server-fix/cover.png"
  alt = "Flat-vector technical illustration: a steel-gray filing cabinet labeled content/posts/ with its draft drawer half-open, spilling green index.html documents into a darker archive below. One spilled document carries a red STALE stamp. A green arrow loops from the archive back to a clean drawer labeled fresh build/ on the right."
  caption = "After the 4-step cleanup + dev server restart, the stale draft article no longer appears in either the URL or the category taxonomy page."

# Draft exemption per CLAUDE.md §3.2 + docs/article-writing-workflow.md §1 (D6 新增 lint_allow 用法)
# 原因：本文件是 [draft] 状态的中文初稿，TCM 阶段 7 英文版 commit 前必须移除此行
lint_allow = ["cjk-body"]
+++

> **TL;DR**：Hugo `draft = true` 文章在本地 dev server 仍展示，根因是 `hugo --gc` 不清理 `public/` + dev server fallback 服务旧 HTML + taxonomy 列表页不 rebuild 这 3 层叠加。修复命令：`rm -rf public/{posts,tags,categories,index.json}` + 重启 dev server。
>
> **作者注（D19）**：我在 D10 那次 commit `581555b` 才真正撞到这个三层叠加 —— commit message 写 `hugo --gc 验证：零 render-image 警告`，我信了 dev server 启动 0 warning，结果浏览器一直在命中 stale `public/` HTML。D17 复盘时 grep 全站才发现 `public/tags/` 4 个子目录 + `public/index.json` 共 5 处残留。

---

## Environment

- Hugo **v0.150.0** (extended)
- PaperMod 2024-Q4 commit
- macOS 14.5 / zsh 5.9
- dev server 命令：`hugo server --baseURL http://localhost:1313 --buildDrafts=false --disableFastRender`
- 真实事故锚点：commit `581555b`（2026-08-21 22:20:43）+ README §6 D10 复盘
- **触发动作**：commit `581555b` 把已发布的 `claude-code-cli-setup-indie-blog` 文章移到 `_drafts/` 子目录 + `front matter draft = true`。commit message 自带 `hugo --gc 验证：零 render-image 警告`，说明当时没识破 stale fallback；D17 复盘才看清完整 3 层根因。

---

## 步骤 0：踩坑搜索（实操前必做）

**英文搜索关键词**：

- `hugo draft still showing site:reddit.com`
- `hugo dev server stale draft`
- `hugo --gc public not cleaned`
- `hugo taxonomy page not rebuild`
- `hugo fallback public html dev server`

**中文踩坑关键词**（P1 强华陆 dev 友好）：

- "Hugo 文章 不显示"
- "Hugo draft 模式"
- "Hugo dev server 缓存"

**来源白名单**：Reddit (r/Hugo, r/CloudFlare, r/webdev) / GitHub Issues (gohugoio/hugo) / Hugo Discourse

### 实操证据（搜索执行快照）

> 📸 *Figure 0：关键词 `hugo --gc public not cleaned` 在 gohugoio/hugo 仓库 Issues 的搜索结果——8 条相关 issue（按 Recently updated 倒序），说明该问题在 Hugo 社区长期有报告，并非孤例。*
>
> ![GitHub Issues search result page in gohugoio/hugo repository for the query 'hugo --gc public not cleaned', showing 8 related issues sorted by Recently updated, confirming this is a long-standing community-reported problem.](/images/static-site/hugo-draft-stale-dev-server-fix/step-0-community-search-github-issues.png)

**预期输出**：3-5 条最常见的踩坑 + 来源链接（[zh-final] 阶段基于搜索结果填充）

---

## 症状

把已发布的 Hugo 文章移到 `_drafts/` 子目录 + front matter 改 `draft = true` 后，启动 `hugo server`：

- 浏览器访问原文章 URL → **页面仍展示**
- 访问 `/categories/<category>/` 分类页 → **该文章仍列出**
- 访问 `/tags/<tag>/` tag 页面 → **该文章仍列出**

**触发条件**：文章已发布过 + 把文章改 draft + 未清理 `public/` 旧产物。三者同时满足即触发。

---

## Error Log（dev server fallback 真实示例）

```bash
# 即使 draft = true，dev server 仍返回 200
$ curl -sI http://localhost:1313/posts/ai-agent/claude-code-cli-setup-indie-blog/
HTTP/1.1 200 OK
Content-Type: text/html

# 分类页仍列出该文章
$ curl -s http://localhost:1313/categories/ai-agent/ \
  | grep "claude-code-cli"
<a href="https://heimaeden.com/posts/ai-agent/claude-code-cli-setup-indie-blog/">

# Hugo 启动日志无 warning（dev server 不知道这是 stale fallback）
$ hugo server --buildDrafts=false
... 0 warnings, 0 errors
```

**关键观察**：Hugo build 0 warnings —— 看起来一切正常，但浏览器看到的不是 source。

---

## 根因分析（3 层叠加）

### 根因 1：`hugo --gc` 不清理 `public/` 旧 HTML

`hugo --gc` flag 仅清理 `resources/` 缓存目录（Hugo v0.150+ 行为），**不清理 `public/` 输出目录**。这是 Hugo 设计如此，不是 bug。

### 根因 2：Hugo dev server 增量构建 fallback

dev server 默认 `--buildDrafts=false`，但当 source page 找不到时（Hugo 把它当作"被排除"），会 **fallback 到 `public/` 旧 HTML**。这是 dev server 的"友好"行为（避免开发时 404），但在 draft 切换场景下变成"友好过了头"。

### 根因 3：Hugo 不触发 taxonomy 列表页 rebuild

Hugo 的 taxonomy 列表页（`/categories/` + `/tags/`）rebuild 触发条件是"有新 page 加入"，**"page 从 published 变 draft" 不触发 rebuild**。结果：taxonomy 页面继续引用 `public/tags/<tag>/index.html` 旧 HTML，里面仍含已 draft 的文章卡片。

---

## Step-by-step 修复

> 📸 *Figure 1：Step 1 启动前 `public/` 目录的 Finder 视图，含 `posts/ai-agent/claude-code-cli-setup-indie-blog/` + `tags/{tutorial, ai-coding-agent, claude-code, indie-blogger}/` 4 个 stale 子目录 + `public/index.json`，全部待清理。*
>
> ![Finder view of public/ directory showing 6 stale items before cleanup: the stale post subdirectory at posts/ai-agent/claude-code-cli-setup-indie-blog/, 4 stale tag subdirectories at tags/{tutorial, ai-coding-agent, claude-code, indie-blogger}/, and the stale public/index.json file at public/ root.](/images/static-site/hugo-draft-stale-dev-server-fix/step-1-public-dir-before-cleanup.png)

### Step 1：列出 draft 文章关联的 public/ 路径

```bash
# 列出所有 draft 文章
grep -rl "draft = true" content/

# 对每个 draft 文章，列出 public/ 中需要清理的路径
# 例：content/posts/static-site/foo.md（draft=true）
#   - public/posts/static-site/foo/
#   - public/categories/<foo-category>/
#   - public/tags/<foo-tag-1>/, public/tags/<foo-tag-2>/
#   - public/images/static-site/foo/（如果有）
```

### Step 2-5：批量清理（**易漏点是 tags/**）

```bash
# 假设 draft 文章 slug = foo
rm -rf public/posts/static-site/foo/
rm -rf public/images/static-site/foo/
rm -rf public/categories/                                    # 重建整层
rm -rf public/tags/<foo-tag-1>/ public/tags/<foo-tag-2>/    # ⚠️ 易漏
rm -f  public/index.json                                     # 站点地图 JSON
```

### Step 6：重启 dev server（强制 rebuild）

```bash
hugo server --baseURL http://localhost:1313 \
            --buildDrafts=false \
            --disableFastRender
```

> 📸 *Figure 2：Step 6 完成后的 `hugo server` 启动日志（左 terminal，0 warnings, 0 errors）+ 浏览器 `/categories/ai-agent/`（右），已不再列出 stale draft 文章。*
>
> ![Terminal output of hugo server restart with --buildDrafts=false --disableFastRender flags showing 0 warnings and 0 errors (left), alongside browser view of /categories/ai-agent/ that no longer lists the previously leaked draft article (right).](/images/static-site/hugo-draft-stale-dev-server-fix/step-6-dev-server-restart.png)

---

## 验证 + 推荐脚本

### 强版 grep（覆盖 5 个目录）

```bash
grep -rl "<draft-title-substring>" public/ \
  | grep -v "editorial-pipeline"   # 排除合法 cross-reference

# 期望输出：空。任意非空 = 仍有 stale fallback
```

### `scripts/check-stale-drafts.sh`（永久防 stale 重建）

```bash
#!/bin/bash
set -e
stale_found=0
for draft_file in $(grep -rl "draft = true" content/); do
  slug=$(basename "$draft_file" .md)
  hits=$(grep -rl "$slug" public/ 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "⚠️  STALE: $draft_file"; echo "$hits" | head -3
    stale_found=1
  fi
done
[ "$stale_found" -eq 1 ] && exit 1
echo "✅ 全站 0 处 stale draft 引用"
```

---

## 已知问题与社区报告

### D17 复盘新发现

> D10 修复序列（`rm 3 个 draft 相关目录` + `rm 整个 categories/`）**实际不完整**——`public/tags/` 目录遗漏。当前 grep 命令可验证 5 处 stale 残留：
>
> - `public/tags/tutorial/` + `index.xml`
> - `public/tags/ai-coding-agent/` + `index.xml`
> - `public/tags/claude-code/` 整个目录
> - `public/tags/indie-blogger/` 整个目录
> - `public/index.json`
>
> **事故范围仅限本地 dev**。CF Pages 部署走 `hugo`（无 flag）默认排除 draft + 从 source 重建 `public/`，线上不会暴露。

### 社区报告（D19 [zh-final] 阶段填 · 5 条 verified）

D19 阶段基于 §0 实操证据（`step-0-community-search-github-issues.png`，commit `c1c2b4e`）的搜索结果，整理出 5 条最相关的社区报告。每条 URL 已 verify（GitHub API / Discourse JSON 取实测）。

1. **[Hugo Discourse #57483](https://discourse.gohugo.io/t/website-builds-successfully-but-published-pages-continue-serving-outdated-generated-content/57483)** · active 2026-08 · 3 posts
   "builds successfully but old content still served" — 用户 joeamanda 报告 + 社区 maintainer iapetus 答："Cache-Control policy 过 long expiry 才是你看到的 stale 现象"。**生产环境对应**：CF Pages 部署也有相同 cache 风险，需要 purge。

2. **[gohugoio/hugo issue #10130](https://github.com/gohugoio/hugo/issues/10130)** · closed auto-locked 2026-01 · 5 comments · opened 2022-07-28
   "Hugo server does not update section pages that are not backed by a file" — toggle `draft` 不触发 section listing 重建，v0.134.3+ 行为变化（不再依赖 `_index.md`）。**对应 S18 §根因 3（taxonomy listing stale）**。

3. **[gohugoio/hugo issue #13998](https://github.com/gohugoio/hugo/issues/13998)** · closed fix v0.162.0 (milestone closed 2026-06-04) · 5 comments · opened 2025-09-23
   "Multilingual content resources are built even if the page is a draft" — 草稿 HTML 抑制但 resources（images）仍 copy 到 `public/`。**对应 S18 §FAQ 4（`rm -rf public/images/...`）**。

4. **[gohugoio/hugo issue #12208](https://github.com/gohugoio/hugo/issues/12208)** · closed fix v0.124.0 (milestone closed 2024-03-18) · opened 2024-03-06
   "Draft status ignored for content parser" — malformed content 触发 draft 被错误忽略。**边角**：S18 §0 fix 命令在 malformed draft 场景下不彻底 —— 修 front matter 优先。

5. **§0 实操证据** — `step-0-community-search-github-issues.png`（commit `c1c2b4e`）
   关键词 `hugo --gc public not cleaned` 在 gohugoio/hugo Issues 搜索返回 8 条结果，可见 4 条（`#12499` / `#11038` / `#10947` / `#10220`）均**非直接命中**——Hugo 官方**不正式 track** `--gc` 是否清理 `public/`。社区共识：手动 `rm -rf public/{posts,tags,categories,index.json}`。

---

## FAQ

**Q: `hugo --gc` 为什么不清 `public/`？**
A: Hugo 设计如此，`--gc` 仅清理 `resources/` 缓存目录，**不清理 `public/` 输出目录**。

**Q: dev server 启动后还会触发增量构建吗？**
A: 会，但找不到 source page 时 fallback 到 `public/` 旧 HTML，不重新构建。

**Q: 生产部署会暴露 draft 吗？**
A: 不会。CF Pages 部署走 `hugo`（无 flag）默认排除 draft，从 source 重建 `public/`。

**Q: 已经有 cover image 的 draft 文章怎么办？**
A: `rm -rf public/images/<category>/<slug>/` 同步清理图片目录。

---

## Fingerprint Tip

⚠️ **关键警告**：`hugo --gc` 不清理 `public/` 是 Hugo **设计行为**，不是 bug。计划 commit 时如未来要把已发布文章改 draft，提前做 `rm -rf public/{posts,tags,categories,index.json}` 三件套准备。不要相信 dev server 启动 0 warnings —— 它不会发现 stale fallback。

**作者注（D19）**：D10 事故之后我写了 `scripts/check-stale-drafts.sh` 脚本片段（见 §验证段，in-article snippet，待入库）——任何 draft 状态切换前后跑一次，0 stale 才 push。

---

## 最终 takeaways（先答案后原因）

1. **`hugo --gc` 只清 `resources/`，不清 `public/`**——换 draft 状态必须手动 rm。
2. **`public/tags/` 是 D10 修复最常被漏的目录**——每次 draft 切换都要全量清理 4 个 tag 子目录。
3. **重启 dev server 必须带 `--disableFastRender`**——避免增量构建走 fallback。
4. **生产部署走 `hugo`（无 flag）默认排除 draft**——线上不会暴露，CF Pages 部署无污染风险。
5. **grep 验证必须覆盖 5 个目录**（posts / categories / tags / index.json / sitemap.xml）——少一个就漏。