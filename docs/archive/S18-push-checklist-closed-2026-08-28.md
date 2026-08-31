# S18 Push 后清单（2026-08-28 D19 · 推送 26 commits 完成）

> **关联**：
> - S18 选题 `docs/archive/topic-pool-2026-08-27-archive.md` §S18
> - 上游 TODO `docs/pending/S18-zh-final-todo.md`（已闭环 · TCM 阶段 4 + 7 完成）
> - 推送 hash：`9b52c00..3b79cfa`（26 commits ahead）
> - 关键 commits：
>   - `3b79cfa` [fix] hub 文章 draft=true（避免未完成被渲染）
>   - `ac5ddce` S18 en-final（**线上版本**）
>   - `7a06f55` [zh-final] S18 中文定稿
>   - `332918f` [asset] cover V1 入库
>   - `c1c2b4e` [asset] §0 截图入库
>   - `451e0c3` [draft] S18 起点
>
> **保存日期**：2026-08-28（D19 · push 后即时记录）

---

## 时间线（按优先级排）

### 🔴 立即（push 后 0-30 min）：CF Pages 部署验证

- [ ] **CF Pages build log 监控**
  - 入口：https://dash.cloudflare.com/ → Workers & Pages → heimaeden-blog → 最新 deployment
  - 期望：build status = Success，duration < 90s
  - 失败时：检查 build log 末尾的 render-image warning / shortcode error
- [ ] **线上 URL smoke test**（用 curl 而不是浏览器，避免缓存）
  - [ ] `curl -sI https://heimaeden.com/posts/static-site/hugo-draft-stale-dev-server-fix/` → `HTTP/2 200`
  - [ ] `curl -sI https://heimaeden.com/images/static-site/hugo-draft-stale-dev-server-fix/cover.png` → `HTTP/2 200` + `content-type: image/webp` 或 `image/png`
  - [ ] `curl -s https://heimaeden.com/sitemap.xml | grep hugo-draft-stale-dev-server-fix` → 命中 1 次（说明 Sitemap 已收录）
- [ ] **回归测试**：hub 文章必须**不**出现在生产
  - [ ] `curl -sI https://heimaeden.com/posts/static-site/hugo-troubleshooting-hub/` → `HTTP/2 404`
  - [ ] `curl -s https://heimaeden.com/ | grep hugo-troubleshooting-hub` → 0 命中（首页不显示）
  - 验证目的：fix commit `3b79cfa` 是否生效（避免 hub 半成品泄漏到生产）
- [ ] **首页/分类/标签页刷新**
  - [ ] `https://heimaeden.com/` 首页 → S18 卡片显示在最上方（date 2026-08-27 最新）
  - [ ] `https://heimaeden.com/posts/` → S18 在第 1 位
  - [ ] `https://heimaeden.com/categories/static-site/` → S18 卡片在列首
- [ ] **浏览器人眼验证**（机器 OK 不代表浏览器 OK）
  - [ ] 用 Safari 无痕模式打开 S18 URL
  - [ ] 检查：cover image 显示正常 + 章节 TOC 折叠/展开工作 + 代码块语法高亮

---

### 🟡 同日（D19 内）：状态/文档同步

- [ ] **更新 topic-pool.md S18 状态**
  - 文件：`docs/archive/topic-pool-2026-08-27-archive.md` §S18
  - 现状：🎯 已选 / 待 zh-final
  - 改为：✅ 已发布 · commit `ac5ddce` · en-final 字数 [填入 grep -c `\w+` 后的实际数]
  - 加一行 published URL：`https://heimaeden.com/posts/static-site/hugo-draft-stale-dev-server-fix/`
- [ ] **更新 S18-zh-final-todo.md**：标"已闭环"或 archive 到 `docs/archive/`
  - 选项 A：在顶部加一行「CLOSED 2026-08-28 · 26 commits pushed, see S18-push-checklist.md」
  - 选项 B：`mv docs/pending/S18-zh-final-todo.md docs/archive/S18-zh-final-todo-closed-2026-08-28.md`
- [ ] **README §6 加 D19 状态校准**
  - 位置：`README.md` §6 Dynamic Notes（按时间倒序插入最新一条）
  - 内容模板：
    ```
    ### 2026-08-28 (D19) — S18 en-final pushed
    - 26 commits → origin/main: `9b52c00..3b79cfa`
    - S18: `ac5ddce` en-final + `7a06f55` [zh-final] + 4 个前置 commits
    - Fix: hub 文章 draft=false → draft=true（避免未完成渲染）
    - 待：CF Pages build 验证 + GSC 24-48h 索引监控
    ```
- [ ] **创建本文件**（已完成）：`docs/pending/S18-push-checklist.md`

---

### 🟠 24-48h 后：GSC 索引监控

- [ ] **手动提交索引请求**（push 后 ~30 min 做一次）
  - GSC URL Inspection → 输入 `https://heimaeden.com/posts/static-site/hugo-draft-stale-dev-server-fix/` → "Request Indexing"
  - 目的：缩短发现 → 收录时间
- [ ] **24h 检查**：GSC → Pages → S18 URL
  - 期望：状态 = "Crawled - currently not indexed" 或 "Indexed"
  - 若 = "Discovered - currently not indexed"：正常，再等 24h
  - 若 = "Crawled - 404" / "Soft 404" / "Redirect error"：**立即排查**（sitemap 错 / canonical 错 / 内容空）
- [ ] **48h 复检**：
  - [ ] URL Inspection → "Indexing allowed? Yes" + "User-agent: Googlebot" 可以 fetch
  - [ ] GSC → Performance → 过滤 page = S18 URL → 看是否有 impressions
- [ ] **目标关键词监测**（每周一次，连续 4 周）
  - 主要：`hugo draft still showing public` / `hugo dev server stale draft` / `hugo --gc not clean public`
  - 次要：`hugo taxonomy page stale` / `hugo disableFastRender dev`
  - 工具：GSC Performance → 关键词维度，筛选 page 包含 S18 slug

---

### 🔵 一周内：资产归档 + 后续文章准备

- [ ] **资产入库**（push 时 untracked，本任务外）
  - [ ] `docs/cover-prompts/s18-draft-stale-cover-prompt.md` → 新 commit `[docs] s18-draft-stale-cover-prompt 入档`
    - 含 V1/V2/V3 三种 cover prompt 模板 + 选择决策记录
  - [ ] `docs/archive/blog-writing-prompt.md` → 决定保留/删除/移动
- [ ] **M3 计划**：等 S18 流量数据稳定后，决定是否:
  - 选项 A：用 V2/V3 prompt 重新生成 cover（如果 V1 转化率低）
  - 选项 B：用 M2 阶段产出的 polish commit 调优 title/description（如果 CTR < 2%）
- [ ] **hub 文章后续**（你之前提"还没完成，先不发布"）
  - 现状：`content/posts/static-site/hugo-troubleshooting-hub/index.md` 是 [draft] 骨架 + 占位
  - 下次会话目标：定 §S1-S5 内容（或决定 hub 文章方向调整）

---

### ⚪ 可选：D19-D21 推广 + 外链

> 这些不是必做，但能加速 GSC 收录 + 流量导入

- [ ] **Hacker News 提交**（如果文章流量值得推广）
  - title：英文版（≤ 80 chars），tag = Show HN 或不 tag
  - 期望：分数 ≥ 30 = ~500 UV / 24h，≥ 100 = ~3000 UV / 24h
- [ ] **Reddit r/Hugo 提交**（针对性最强）
  - title 模板：`Why my Hugo draft still showed up after I moved it to _drafts/ [3-layer root cause]`
  - 链接 + 1 段 context（不要复制首段，给 Reddit 友好的开头）
- [ ] **内链审计**：从现有 2 篇 static-site 文章（`static-blog-setup-guide` / `dev-server-baseurl`）反向链接到 S18
  - 位置：文末 "Related reading" 区
  - commit prefix：[polish]（不增删事实）
- [ ] **Twitter / X 推文**
  - 短推 + heimaeden.com URL + 1 张 cover image
  - 时机：周三/周四 美东时间 9-11am 最佳

---

### ⚫ 1-2 周后：健康检查

- [ ] **CF Pages 资源监控**（防止 build time 暴涨）
  - 入口：CF Dashboard → Workers & Pages → heimaeden-blog → Metrics
  - 关注：build duration 中位数（应该 < 30s）、build count（每 push 1 次正常）
- [ ] **GA 流量**
  - GA → Pages → S18 URL → sessions / bounce rate / avg time
  - 期望：bounce rate < 70%，avg time > 90s（说明读者真的在读）
- [ ] **AdSense 合规**（如果已挂广告）
  - 入口：AdSense → Pages → 过滤 URL 包含 hugo-draft-stale-dev-server-fix
  - 检查：广告是否正常显示 + 是否违反"低价值内容"政策（[polish] commit 时机决策）

---

## ⚠️ 触发的硬约束（再检查一遍）

| 约束 | 状态 | 说明 |
|---|---|---|
| CLAUDE.md §6 (HOLD push) | ✓ | 用户已 ack "先吧刚刚的那篇文章发布" |
| CLAUDE.md §3.2 (English body) | ✓ | en-final commit `ac5ddce` 用 HTML-comment allow 而非 front matter `lint_allow` |
| CLAUDE.md §3.8 rule 5 (翻译不增删) | ✓ | 1:1 段落对应 |
| CLAUDE.md §3.8 rule 6 (cross-ref 锚点) | ✓ | verify-cross-refs gate 通过 |
| CLAUDE.md §3.3.2 (≤1440px) | ✓ | 所有截图已优化 |
| CLAUDE.md §3.3.4 (PII 脱敏) | ✓ | 无账户数据 |
| CLAUDE.md §4 forbidden | ✓ | 无 --no-verify / --force / amend |

---

## 🔄 Push 后状态总览（填表用）

| 维度 | 状态 | 备注 |
|---|---|---|
| Git push | ✅ done | 26 commits `9b52c00..3b79cfa` |
| CF Pages build | ✅ done | D20 验证：62 → 59 pages, build < 90s |
| 线上 URL 200 | ✅ done | S18 URL HTTP/2 200, cover image/png |
| hub 文章不渲染 | ✅ done | fix `3b79cfa` 生效: HTTP/2 404 |
| GSC 索引请求 | ✅ done | D20 由用户手动提交 |
| GSC 24h 索引 | ✅ done | D20 由用户确认 Crawled/Indexed |
| GSC 48h 收录 | ⏳ pending | 预计 D21 再检查 |
| topic-pool.md 状态更新 | ⏳ pending | 同日 (#24) |
| README §6 D19 校准 | ⏳ pending | 同日 (#24) |
| 资产归档 | ⏳ pending | 一周内 (#25) |

---

## 📎 相关文件

| 文件 | 用途 |
|---|---|
| `content/posts/static-site/hugo-draft-stale-dev-server-fix/index.md` | S18 en-final 线上版 |
| `content/posts/static-site/hugo-troubleshooting-hub/index.md` | hub 文章（draft=true 不渲染）|
| `assets/images/static-site/hugo-draft-stale-dev-server-fix/cover.png` | S18 V1 隐喻 cover |
| `assets/images/static-site/hugo-draft-stale-dev-server-fix/step-{0,1,6}-*.png` | S18 内容截图 |
| `docs/cover-prompts/s18-draft-stale-cover-prompt.md` | D19 起草的 AI cover prompt（待入库）|
| `docs/archive/topic-pool-2026-08-27-archive.md` §S18 | S18 选题存档（待状态更新 🎯 → ✅）|
| `docs/pending/S18-zh-final-todo.md` | 上游 TODO（待归档到 archive/）|

---

*保存：D19（2026-08-28 push 后即时）/ 下次会话 trigger：「检查 S18 CF Pages 部署 + GSC 索引」*
