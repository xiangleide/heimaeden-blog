+++
title = "Why My Hugo Draft Still Shows Up After I Moved It to _drafts/"
description = "Hugo dev server fallback serves stale public/ HTML after moving a post to _drafts/. 3-layer root cause + complete cleanup commands covering posts, categories, tags, index.json, and sitemap.xml."
date = 2026-08-27T00:00:00Z
draft = true
tags = ["Hugo", "Static Site", "Troubleshooting", "Dev Server"]
categories = ["Static-Site"]
prompt_type = "A"

showToc = true
TocOpen = true

# Draft exemption per CLAUDE.md §3.2 + docs/article-writing-workflow.md §1 (D6 新增 lint_allow 用法)
# 原因：本文件是 [draft] 状态的中文初稿，TCM 阶段 7 英文版 commit 前必须移除此行
lint_allow = ["cjk-body"]
+++

> **TL;DR**：Hugo `draft = true` 文章在本地 dev server 仍展示，根因是 `hugo --gc` 不清理 `public/` + dev server fallback 服务旧 HTML + taxonomy 列表页不 rebuild 这 3 层叠加。修复命令：`rm -rf public/{posts,tags,categories,index.json}` + 重启 dev server。

---

## Environment

- Hugo **v0.150.0** (extended)
- PaperMod 2024-Q4 commit
- macOS 14.5 / zsh 5.9
- dev server 命令：`hugo server --baseURL http://localhost:1313 --buildDrafts=false --disableFastRender`
- 真实事故锚点：commit `581555b`（2026-08-21 22:20:43）+ README §6 D10 复盘

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

> 本节在 [zh-final] 阶段基于 §0 搜索结果填充。
>
> **D17 复盘新发现**：D10 修复序列（`rm 3 个 draft 相关目录` + `rm 整个 categories/`）**实际不完整**——`public/tags/` 目录遗漏。当前 grep 命令可验证 5 处 stale 残留：
>
> - `public/tags/tutorial/` + `index.xml`
> - `public/tags/ai-coding-agent/` + `index.xml`
> - `public/tags/claude-code/` 整个目录
> - `public/tags/indie-blogger/` 整个目录
> - `public/index.json`
>
> **事故范围仅限本地 dev**。CF Pages 部署走 `hugo`（无 flag）默认排除 draft + 从 source 重建 `public/`，线上不会暴露。

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

---

## 最终 takeaways（先答案后原因）

1. **`hugo --gc` 只清 `resources/`，不清 `public/`**——换 draft 状态必须手动 rm。
2. **`public/tags/` 是 D10 修复最常被漏的目录**——每次 draft 切换都要全量清理 4 个 tag 子目录。
3. **重启 dev server 必须带 `--disableFastRender`**——避免增量构建走 fallback。
4. **生产部署走 `hugo`（无 flag）默认排除 draft**——线上不会暴露，CF Pages 部署无污染风险。
5. **grep 验证必须覆盖 5 个目录**（posts / categories / tags / index.json / sitemap.xml）——少一个就漏。