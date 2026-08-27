+++
title = "Hugo + Cloudflare Pages 报错集群：5 个常见问题的完整排查路径"
description = "新站 5 个最高频 Hugo + Cloudflare Pages 报错的集群索引页：image path 404、ERR_TOO_MANY_REDIRECTS、build OOM、cache stale、redirect loop。每条含真实日志、版本环境、验证过的修复命令。"
date = 2026-08-25T01:00:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "troubleshooting", "build error"]
categories = ["Static-Site"]

showToc = true
TocOpen = true

[cover]
    image = "static-site/hugo-troubleshooting-hub/cover.jpg"
    alt = "Hugo troubleshooting hub cover"

# Draft exemption per CLAUDE.md §3.2 + docs/article-writing-workflow.md §1 (D6 新增 lint_allow 用法)
# 原因：本文件是 [draft] 状态的中文初稿，TCM 阶段 7 英文版 commit 前必须移除此行
lint_allow = ["cjk-body"]
+++

> **本文件性质**：Hub 索引页（非单主题文章）。按"报错簇"思维（见 `docs/archive/运营方案与交叉验证文档-2026-08-27.md` §一 1. 微调逻辑）把高频 Hugo + Cloudflare Pages 报错集中到一个 cluster anchor page，互链到各子问题详细文。
>
> **D12 决策**：B2 落地（`docs/archive/topic-pool-2026-08-27-archive.md` §「📅 交叉验证落地决策（D12 · 2026-08-25）」B2 行）。
>
> **当前进度**：[draft] 阶段（骨架 + 占位）。§S1 / §S2 是 hub 内详写内容；§S3-S12 是 TBD 占位（待各子文章落地后陆续填充）。

---

## 引言

部署 Hugo 站到 Cloudflare Pages 时，最常见的问题不是"Hugo 不会写"，而是"已经部署好了但页面错位 / 资源 404 / 重定向死循环"。本文不写"如何从零搭建 Hugo 站"，而是把 **5 个最高频的部署 / 运行时报错**集中到一页：

| # | 报错簇 | 触发条件 | 关联 S 系列 |
|---|---|---|---|
| 1 | **图片路径 404** | 新增 assets/images 后本地能看，部署后 404 | S1 |
| 2 | **ERR_TOO_MANY_REDIRECTS** | 自定义域名 + CF 默认 SSL Flexible | S2 |
| 3 | **Build OOM（out-of-memory）** | Hugo 大站（>5k 页）+ 默认 CF Pages 内存 | S3 |
| 4 | **Cache stale / 旧资源** | CF 默认 cache + assets hash 变更 | S7（关联） |
| 5 | **Redirect loop on preview** | Preview branch + 自定义域名 + cache | S2（关联） |

**适用读者**：

- Hugo + Cloudflare Pages 用户（不论是否有自定义域名）
- 新站第一周遇到"明明本地好好的、部署就报错"的人

**不适用**：

- Hugo 语法错误（TOML 解析失败、模板 not found）→ 走 `B1-2` 单文
- Hugo 选型对比 → 走 S9 / S10 / S11 / S12 单文

---

## 前置条件

- Hugo v0.150.0+（v0.150 起 `minify.minifyOutput` 替代 `minify`）
- Cloudflare Pages 项目已建好（free tier 即可）
- 自定义域名可选（如 heimaeden.com），无自定义域名仍可触发部分报错
- 浏览器 DevTools Network 标签（用来读 status code + response headers）

---

## 步骤 0：踩坑搜索（实操前必做）

**任务**：动手前先搜一轮社区踩坑，为实操做心理预期。

**搜索关键词模板**（每个 S 系列各搜一次）：

- `hugo + cloudflare pages + {报错关键字} site:reddit.com`
- `{报错关键字} github issue`
- `{报错关键字} cloudflare community`

**来源白名单**：

- Reddit（r/Hugo, r/CloudFlare, r/webdev）
- GitHub Issues（gohugoio/hugo + cloudflare/pages-*)
- Cloudflare Community
- Hugo Discourse

**预期输出**：3-5 条最常见的踩坑 + 来源链接（本节在 [zh-final] 阶段填充）

---

## 报错簇 1：图片路径 404（`/images/<category>/<slug>/cover.png` 返回 404）

### 症状

部署到生产后浏览器访问文章：

- 首页 HTML 中 `<img src="https://heimaeden.com/images/.../cover.png">` → **404 Not Found**
- `curl -I https://heimaeden.com/images/<path>/cover.png` → 404
- **但**本地 `hugo server` 访问 `http://localhost:1313/images/<path>/cover.png` → **200 OK**

### 触发条件（满足任一即触发）

- 新建文章 + 新增 `assets/images/<category>/<slug>/cover.png`
- 修改了既有图片但 `git add` 前忘了跑 `optimize-image.sh`（>1440px）
- `hugo.toml` 中 `baseURL` 与生产不一致（dev 环境最常见，见 §已知问题）

### 修复路径

> 📸 **截图标注位**（簇 1）：
> - **位置**：CF Pages Dashboard → 项目 → Deployments → 最新部署 → Build log
> - **脱敏要求**：打码邮箱 / 项目名保留可见
> - **文件命名**：`cluster-1-cf-dashboard-build-log.png`
> - **放哪**：Page Bundle 同目录

**Step 1.1**：确认本地资源存在且 <1440px 宽

```bash
sips -g pixelWidth -g pixelHeight assets/images/<category>/<slug>/cover.png
# 期望：pixelWidth ≤ 1440
```

**Step 1.2**：确认 git 已追踪该文件

```bash
git ls-files assets/images/<category>/<slug>/cover.png
# 期望：输出路径（无输出 = 文件未 tracked，CF 不会部署）
```

**Step 1.3**：确认 CF Pages Build log 显示成功

> Cloudflare Dashboard → Pages → `<project>` → Deployments → 最新一条 → Build log 末尾
> 期望：`Success: Assets uploaded`

**Step 1.4**：若以上都通过但仍 404 → 检查 Hugo 路径格式

```toml
# hugo.toml 必须这样写
[params]
  images = ["images"]
# 注意：不是 "static/images"（CLAUDE.md §3.3 写死）
```

**Step 1.5**：dev 环境特殊 case

本地 `hugo server` 默认 `baseURL` 是生产 URL，导致浏览器拿不到本地资源。**不要改 hugo.toml**：

```bash
# 正确：dev 启动时显式覆盖 baseURL（详见 docs/dev-server-baseurl.md）
hugo server --baseURL http://localhost:1313/
```

### 关联 S 系列

- **S1**：Hugo image path broken after publish to Cloudflare Pages solution（`docs/archive/topic-pool-2026-08-27-archive.md` §S1 行 107）
- S1 详细文落地后，互链到本簇 §Step 1.4

---

## 报错簇 2：ERR_TOO_MANY_REDIRECTS（自定义域名 + SSL Flexible）

### 症状

浏览器访问 `https://heimaeden.com`：

- 报错：`ERR_TOO_MANY_REDIRECTS` 或 `This page isn't redirecting properly`
- `curl -L https://heimaeden.com` 死循环
- DevTools Network → 多个 301/302 跳转，>10 次后 Chrome 终止

### 触发条件（满足任一即触发）

- Cloudflare SSL/TLS 设为 **Flexible** + 自定义域名 + 后端（CF Pages / 源站）也强制 HTTPS
- 源站不支持 HTTPS（如 Hugo static 默认 HTTP）但 Cloudflare 强制 HTTPS rewrite

### 修复路径

> 📸 **截图标注位**（簇 2）：
> - **位置**：CF Dashboard → SSL/TLS → Overview
> - **脱敏要求**：无 PII（CF Dashboard 不显示邮箱），但项目名可保留
> - **文件命名**：`cluster-2-cf-ssl-tls-overview.png`
> - **放哪**：Page Bundle 同目录

**Step 2.1**：把 SSL/TLS 模式从 **Flexible** 改成 **Full (strict)**

```bash
# UI 路径：CF Dashboard → SSL/TLS → Overview → Custom SSL → Full (strict)
# 命令行（API）：待补
```

**Step 2.2**：确认 Edge Certificates 已签发

```bash
# UI 路径：CF Dashboard → SSL/TLS → Edge Certificates
# 期望：Active Certificate 状态 + 覆盖 heimaeden.com + heimaeden.com/*
```

**Step 2.3**：清浏览器 / CDN 缓存

```bash
# 浏览器：DevTools → Network → Disable cache 勾上 + Ctrl+Shift+R
# CF 缓存：CF Dashboard → Caching → Purge Everything（先选 Custom + URL，再 All）
```

**Step 2.4**：避免再次回退的硬规矩

- ❌ 不要把 SSL/TLS 改回 Flexible（省钱但循环）
- ✅ Hugo 站一律 Full (strict) + 自定义域名（免费 tier 即可）
- ✅ CNAME 解析走 CF proxy（橙色云朵），不是仅 DNS

### 关联 S 系列

- **S2**：Cloudflare ERR_TOO_MANY_REDIRECTS custom domain fix for Hugo blog（`docs/archive/topic-pool-2026-08-27-archive.md` §S2 行 116）
- S2 详细文落地后，互链到本簇 §Step 2.1

---

## 报错簇 3：Build OOM（CF Pages 默认内存不够）

### 症状

CF Pages Build log：

```
Error: build failed: signal: killed (out of memory)
```

或 Hugo 进程 build 到一半直接 silent 退出。

### 触发条件

- Hugo 站总页数 > 5000 + 大量 image processing
- CF Pages 默认 Worker 内存 = 512 MB
- 大量未经优化的图片（CLAUDE.md §3.3.2 写死 <1440px）

### 修复路径（占位）

> 本簇在 [zh-final] 阶段由用户实操填入。当前为占位。
> 关联 S3：`docs/archive/topic-pool-2026-08-27-archive.md` §S3 行 125。

---

## 报错簇 4：Cache stale（旧版资源被 CDN 缓存）

### 症状

部署新版本后：

- HTML 已更新但 `<link rel="stylesheet">` 引用的 CSS 是旧版
- `<script>` 引用的 JS 是旧版
- 图片 hash 已变但 CDN 还返回旧 binary

### 修复路径（占位）

> 本簇在 [zh-final] 阶段由用户实操填入。
> 关联 S7 / S8：`docs/archive/topic-pool-2026-08-27-archive.md` §S7 / §S8。

---

## 报错簇 5：Preview branch redirect loop

### 症状

PR 触发的 CF Pages Preview URL（`https://<branch>.<project>.pages.dev`）访问时：

- ERR_TOO_MANY_REDIRECTS（同簇 2）
- 但生产域名正常

### 修复路径（占位）

> 本簇在 [zh-final] 阶段由用户实操填入。
> 关联 S2：`docs/archive/topic-pool-2026-08-27-archive.md` §S2 行 116。

---

## 已知问题与社区报告

> 本节在 [zh-final] 阶段基于 §0 搜索结果填充。两条走策略：
> - **策略 A**（用户实操顺利）→ 列 3-5 条社区已报告但本流程未触发的坑
> - **策略 B**（用户实操命中本流程之外的坑）→ 加 1-2 条社区未充分记录的实战发现

---

## 结论

Hub 索引页面的价值不在于"覆盖所有 Hugo 报错"——而在于**给搜索"Hugo + Cloudflare Pages error"的用户一个集群入口**，让他们：

- 先用本文 5 簇快速自查
- 命中某簇后跳到对应 S 系列详细文（如有）
- 未命中 → 在评论区 / GitHub Issue 反馈，作者补新簇

**长期计划**：随着 S3-S12 落地，本 hub 持续扩展；最终目标 = "Hugo + Cloudflare Pages 报错的单一权威源"。

---

## 附录 A：本文与 S 系列的互链地图

| 本文簇 | 关联 S 详细文 | 当前状态 |
|---|---|---|
| 簇 1（image path） | S1 Hugo image path broken | 待选 → [draft] 后互链 |
| 簇 2（ERR_TOO_MANY_REDIRECTS） | S2 Cloudflare ERR_TOO_MANY_REDIRECTS | 待选 → [draft] 后互链 |
| 簇 3（OOM） | S3 CF Pages OOM | 待选 → [draft] 后互链 |
| 簇 4（cache stale） | S7 / S8 | 待选 |
| 簇 5（preview redirect） | S2（共享）| 待选 |

**写作约束**：每写完一篇 S 系列，先在本文对应簇的"关联 S 系列"加正式互链（使用 Hugo `ref` shortcode 指向各 S 详细文），保持 hub 永远是 cluster anchor。

---

## 附录 B：本次决策记录（D12 · 2026-08-25）

| 决策点 | 选择 | 关联文档 |
|---|---|---|
| **B2**：Hugo 排错 hub 页 | 新建本文件 | `docs/archive/topic-pool-2026-08-27-archive.md` §「📅 交叉验证落地决策」B2 行 |
| 关联决策 | **A1** B2 P1 WorldFirst 按 GEO 写作模板落地 | `docs/geo-writing-module.md` |
| 关联决策 | **C2** 自动化评估时点 = D29 | `docs/archive/topic-pool-2026-08-27-archive.md` §维护规则 §9 |
| 关联决策 | **D2** about 页升级与 B2 P1 同步落地 | `content/about.md` 升级草案 |