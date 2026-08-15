# SEO 索引基础设施搭建 Checklist（seo-setup-checklist.md）

> **用途**：阶段 β B0（前置必做）—— AdSense 审核要求 GSC 已验证 + sitemap 已提交，否则审核自动拒绝。
> **配套**：README §7.3 阶段 β B0 + §四阶段三「SEO 关键词与外部权重累积」。
> **承诺**：完成本 checklist 4 项后，B0 = 100%，可正式进入 B1（内容写作）。

---

## 进度概览

| Phase | 动作 | 状态 |
|---|---|---|
| ⏳ Phase 1 | `hugo.toml` 加 `[sitemap]` 段 | 待办（Claude 执行） |
| ⏳ Phase 2 | `static/robots.txt` 落地 | 待办（Claude 执行） |
| ⏳ Phase 3 | GSC 添加站点 + HTML 文件验证 → 创建 `static/google<hash>.html` | 待办（用户执行） |
| ⏳ Phase 4 | GSC 后台提交 sitemap | 待办（用户执行） |

---

## Phase 1：`hugo.toml` 加 `[sitemap]` 段

**位置**：`hugo.toml` 第 18 行（`[outputs]` 段之后）插入新顶级段。

**完整配置**：
```toml
[sitemap]
    changefreq = "weekly"
    priority = 0.5
    filename = "sitemap.xml"
```

**字段说明**：
- `changefreq = "weekly"` — Hugo 默认值，但对独立博客更精确（每天大量更新会触发 GSC 频繁抓取警报）
- `priority = 0.5` — Hugo 默认值 0.5。首页/About 页可在 front matter 单独覆盖为 1.0
- `filename = "sitemap.xml"` — 默认值，显式写出来避免主题模板冲突

**验证**：
```bash
hugo --gc
ls public/sitemap.xml
```

应输出 `<loc>https://heimaeden.com/...</loc>` 格式的 XML 列表。

---

## Phase 2：`static/robots.txt` 落地

**完整内容**（直接写到 `static/robots.txt`）：
```
User-agent: *
Allow: /

Sitemap: https://heimaeden.com/sitemap.xml
```

**为什么这样写**：
- `User-agent: *` + `Allow: /` = 全爬虫允许索引全站（独立博客不需要隐藏任何东西）
- `Sitemap:` 行让 Google/Bing 主动发现 sitemap，不必等爬虫自己找

**🚨 避坑**：
- ❌ 不要写 `Disallow: /legal/` —— 法务四件套应该被索引（增强 EEAT）
- ❌ 不要写 `Disallow: /posts/` —— 这会把整站内容屏蔽
- ❌ 不要写多个 `Sitemap:` —— GSC 一次只认一个 sitemap.xml

**验证**：
```bash
hugo --gc
curl -s https://heimaeden.com/robots.txt
```

应返回完整 robots.txt（CF Pages 部署后）。

---

## Phase 3：GSC 添加站点 + HTML 文件验证（**用户执行**）

### 3.1 GSC 添加站点

1. 登录 https://search.google.com/search-console/
2. 点击「添加资源」（Add Property）
3. 选 **「网址前缀」（URL Prefix）** 类型
4. 输入 `https://heimaeden.com`
5. 点击「继续」

### 3.2 选 HTML 文件验证方式

1. GSC 给出多种验证方式，选 **「HTML 文件」**（HTML file）
2. GSC 显示：
   - **文件名**：`google<hash>.html`（如 `google1234abcd...html`）
   - **文件内容**：一行 HTML 字符串（一般形如 `google-site-verification: google1234...html`）
3. **复制文件名 + 文件内容** 给 Claude

### 3.3 创建验证文件

Claude 在 `static/google<hash>.html` 创建文件，内容粘贴 GSC 给的字符串。

**为什么放 static/**：
Hugo 会把 `static/` 下所有文件原样拷贝到 `public/` 根目录 → CF Pages 直接 serve → GSC 验证通过。

---

## Phase 4：GSC 后台提交 sitemap（**用户执行**）

1. GSC 左侧菜单 → **「站点地图」**（Sitemaps）
2. 在「添加新的站点地图」输入框填 `sitemap.xml`
3. 点击「提交」
4. 状态显示「成功」即完成

**预期时间**：提交后 24-48h GSC 开始抓取，3-7 天全站大部分 URL 入索引。

---

## ⚠️ 避坑提醒

1. **HTTPS vs HTTP**：GSC 一定要选「网址前缀」+ `https://`，不要选 `http://` 或裸 `heimaeden.com`
2. **www vs 非 www**：本项目用非 www，**不要**同时验证 www.heimaeden.com
3. **验证文件命名严格匹配**：GSC 给的 hash 一个字符都不能改（大小写敏感）
4. **不要用 meta 标签验证**：CF Pages 主题模板可能覆盖 head 区 → 文件验证最稳
5. **不要用 DNS TXT 验证**：CF Pages 项目无独立 DNS 记录权限，需走 CF for SaaS 单独配置，**当前阶段不必要**

---

## ✅ 完成定义（B0 = 100%）

满足以下 4 项即 B0 收官：

1. [ ] `hugo.toml` 已加 `[sitemap]` 段 + `hugo --gc` 后 `public/sitemap.xml` 生成
2. [ ] `static/robots.txt` 已创建 + CF Pages 部署后 `curl https://heimaeden.com/robots.txt` 返回 200
3. [ ] GSC 验证文件已创建 + GSC 后台显示「验证成功」
4. [ ] GSC 已提交 `sitemap.xml` + 24-48h 后抓取报告显示「成功」

满足后，README §7.3 阶段 β B0 标记 ✅，可正式进入 B1（写第二/第三篇图文长文）。

---

## 📞 卡点求助

- GSC 显示「验证失败」→ 检查文件名是否与 GSC 给的**完全一致**（含 `google` 前缀）
- sitemap.xml 提交后状态一直「待处理」→ 检查 `robots.txt` 是否正确指向 sitemap
- Hugo build 后 `public/sitemap.xml` 不存在 → 检查 `[sitemap]` 段是否在 hugo.toml 顶级（不是放在 `[params]` 里）