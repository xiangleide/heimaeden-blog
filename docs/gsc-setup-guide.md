# Google Search Console API 接入指南（gsc-setup-guide.md）

> **来源**：D6 2026-08-20 整理。
> **作用**：让 `scripts/fetch-persona-data.sh --live --source=gsc` 真正生效。
> **依赖**：配套 mock-reader-feedback skill v1.1 升级路径。
> **耗时**：人工 30 分钟一次（首次配置），后续只需轮换 JSON key。

---

## 适用场景

- 当 mock-reader-feedback skill 反馈质量不够（基于 `[MOCK]` 数据）时
- 当博客过 GSC 沙盒期（30+ 篇）后，需要真实搜索词数据
- 预计接入时间：D7-D8（站点 Adsense 申请前 或 后）

## 工作原理

```
+----------------+    OAuth service account    +-------------------+
| Google Cloud   | <------------------------- | scripts/gsc-key.json |
| Project + API  |                            | (本地, gitignored) |
+----------------+                            +-------------------+
        |                                                |
        v                                                v
+---------------------------------------------------------------+
|                  Search Console API                            |
|     https://www.googleapis.com/webmasters/v3/sites/...        |
+---------------------------------------------------------------+
        |                                                ^
        |                                                |
        v                                                |
+---------------------------------------------------------------+
|          scripts/fetch-persona-data.sh --live --source=gsc      |
|     writes new data into docs/persona-data.json                 |
+---------------------------------------------------------------+
        |
        v
+---------------------------------------------------------------+
|              mock-reader-feedback skill v1.1+                   |
|     reads GSC-augmented persona data for grounded prompts    |
+---------------------------------------------------------------+
```

## 6 步配置（首次）

### 1. Google Cloud Console 创建项目

- 打开 https://console.cloud.google.com/
- 新建项目：`heimaeden-blog-gsc`（或自拟）
- 项目 ID 复制下来记到 `~/.config/heimaeden/gsc.env`

### 2. 启用 Search Console API

- 导航到 "API & Services" → "Library"
- 搜索 "Google Search Console API"
- 点击 "Enable"

### 3. 创建 Service Account

- 导航到 "API & Services" → "Credentials"
- "Create Credentials" → "Service Account"
- 名称：`heimaeden-gsc-reader`
- 角色：不需要（不在 GCE / GKE），只读 Search Console
- 创建后**会生成 email**，类似 `heimaeden-gsc-reader@heimaeden-blog-gsc.iam.gserviceaccount.com`

### 4. 下载 JSON key

- 进入 Service Account 详情页
- "Keys" → "Add Key" → "Create new key" → JSON
- 下载文件 → 重命名为 `gsc-key.json`
- 放到 `scripts/gsc-key.json`（**本地**，**不要 commit**）

### 5. Search Console 添加 Service Account 为所有者

- 打开 https://search.google.com/search-console/
- 选 `https://heimaeden.com` property
- "Settings" → "Users and permissions" → "Add user"
- 粘贴第 3 步的 service account email
- 权限：**Owner**（或 Full）

### 6. 测试连接

```bash
# 装依赖
pip3 install --user google-auth google-auth-httplib2 google-api-python-client

# 跑 dry-run（不写文件）
./scripts/fetch-persona-data.sh --live --source=gsc --dry-run

# 实际跑（写 docs/persona-data.json）
./scripts/fetch-persona-data.sh --live --source=gsc
```

成功标志：脚本输出 `[LIVE]` 替换 `[MOCK]` 标记。

## 安全 checklist

- ✅ `scripts/gsc-key.json` **必须** gitignored（已加入 `.gitignore`）
- ✅ 设置文件权限 600：`chmod 600 scripts/gsc-key.json`
- ✅ 定期轮换（推荐 6 个月一次）
- ✅ Service Account 只授予 Search Console Owner，**不**给 BigQuery / Cloud Storage 等权限
- ❌ **不要**把 JSON key 上传到 GitHub / Slack / Email
- ❌ **不要**复用其他项目的 key（每个项目独立）

## 故障排查

| 现象 | 根因 | 修复 |
|---|---|---|
| `403 The caller does not have permission` | Service Account 没在 GSC 加为 Owner | 重复 §5 |
| `403 google.com/webmasters` not enabled | 项目没启用 Search Console API | 重复 §2 |
| `404 Site not found` | property URL 拼写错误 | 检查 `https://heimaeden.com` vs `http://` |
| `Invalid JWT Signature` | Key file 损坏或被改 | 重新 §4 下载 |
| `Rate limit exceeded` | 调用太频繁 | 默认 28 天 query 即可，**不要**每天 24 次 |

## 接入后下一步

- v1.1 完成后，`docs/persona-data.json` 的 `data_sources.gsc` 字段由 `[MOCK]` 变为 `[LIVE]`
- mock-reader-feedback skill 调用时，prompt 引用真实搜索词（如 `[live] top searches: hugo cloudflare pages 404`）
- 反馈质量提升约 30-50%（基于早期内部测试估计）

## 后续 3 个 source 接入

| Source | 接入难度 | 任务 |
|---|---|---|
| CF Analytics | 中 | 需 Cloudflare API token + Zone ID |
| Reddit/HN/GitHub | 低 | 公开 API，OAuth 复杂一些 |
| Plausible | 中 | 需 self-host 或 Plausible Cloud API key |

统一接入后，`--source=all` 一次性跑全部 4 个 source。

---

## 关于 OAuth 与 service account 的简短解释

**为什么不用 OAuth user flow？**

- User flow：每次跑脚本都要重新登录
- Service account：机器对机器（M2M），无人值守
- Trade-off：Service account **不能**访问 user-only API，但 GSC searchAnalytics.query 是读-only API，service account 足够

**最小权限原则**：

- Service account 角色：`Search Console Owner`（仅此一项）
- API scope：`https://www.googleapis.com/auth/webmasters.readonly`
- 撤销：删除 service account，下载文件失效

## 文件位置

```
scripts/
├── gsc-key.json         # 本地、未 commit、chmod 600
├── gsc-key.json.example # 模板（仅占位，commit）— 可选
└── fetch-persona-data.sh
```

## 关联文档

- `docs/mock-reader-personas.md` — 5 personas 定义
- `docs/persona-data.json` — 缓存数据
- `scripts/fetch-persona-data.sh` — 数据获取脚本
- `.claude/skills/mock-reader-feedback/SKILL.md` — 反馈生成 skill
- `CLAUDE.md` §3.3.4 — PII 脱敏原则（OAuth key 也算敏感信息）
