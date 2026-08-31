# S18 [zh-final] 待办（明天继续 · 2026-08-28）

> **关联**：S18 选题 `docs/archive/topic-pool-2026-08-27-archive.md` §S18
> **当前状态**：[draft]（commit `451e0c3` 创建 + `47c9a01` 真实截图入库）
> **触发 skill**：`zh-final-refactor`（阶段四）
> **下一步目标**：[zh-final] → 触发 `translate-zh-to-en` → [en-final] → commit + push
> **保存日期**：2026-08-27（D18 / 仓库公开化同日）· **预计重启**：2026-08-28（D19）

---

## 用户决定（2026-08-27 已确认 · 不要重新问）

| 维度 | 决定 | 备注 |
|---|---|---|
| **实操事实** | 现有事实足够（基于 D10 / D17 复盘）| 不用重新跑复现 |
| **first-person 范围** | 混合：intro 段 + 结尾 Fingerprint Tip 加第一人称，正文保持 step-by-step | 不用全篇重写 |
| **cover image** | 加 cover（复用 step-6-dev-server-restart.png 或新建）| 翻译前完成 |

---

## [zh-final] 阶段具体 TODO

### 1. 填补占位段（必做）

- [ ] **§0 踩坑搜索**：AI 联网搜索 3-5 条社区踩坑
  - 关键词：`hugo draft still showing site:reddit.com` / `hugo dev server stale draft` / `hugo --gc public not cleaned` / `hugo taxonomy page not rebuild` / `hugo fallback public html dev server`
  - 来源白名单：Reddit (r/Hugo, r/CloudFlare, r/webdev) / GitHub Issues (gohugoio/hugo) / Hugo Discourse
  - 输出：3-5 条踩坑 + 来源链接
- [ ] **§已知问题与社区报告**：基于 §0 搜索结果填充，**保留** D17 复盘新发现段（5 处 stale 残留 + 事故范围仅限本地 dev）

### 2. Front matter 修补（必做）

- [ ] **加 cover**：
  - 选项 A：复用 `step-6-dev-server-restart.png`（commit `47c9a01` 已入库）→ `cover.image = "static-site/hugo-draft-stale-dev-server-fix/step-6-dev-server-restart.png"`
  - 选项 B：新建一张带文字标签的 cover image（更适配 1200×630 OG 卡需求）
- [ ] **加 cover.alt**（每篇必带，符合 §3.1 硬约束）
- [ ] **description 字数复核**：当前 140 chars（合规 ≤ 160），不动

### 3. first-person 重构（混合方案）

- [ ] **§TL;DR 段**：加入「我在 D10 那次 commit `581555b` 修复时才意识到...」叙述（基于 D17 复盘事实）
- [ ] **§Environment 段**：保留事实清单（v0.150.0 / PaperMod / macOS 14.5）+ 在末尾加一行「本次事故由我 D10 commit `581555b` 触发 + D17 复盘发现 5 处遗漏」
- [ ] **§Fingerprint Tip 段**：在末尾加「我后来把这个教训固化成 `scripts/check-stale-drafts.sh`（见 §验证段）——任何 draft 切换前后跑一次，0 stale 才 push」
- [ ] **正文 step-by-step 段**：**保持清单语气，不加 first-person**（CLAUDE.md §3.8 rule 1）

### 4. lint + commit + push（必做 · 阶段六）

- [ ] `./scripts/lint-post.sh content/posts/static-site/hugo-draft-stale-dev-server-fix/index.md` → 0 errors
- [ ] `hugo --gc` → 0 errors
- [ ] 移除 `lint_allow = ["cjk-body"]`（**关键**：CLAUDE.md §3.2 要求，最终发布英文版 .md body 必须英文）
- [ ] `verify-image-paths` + `verify-cross-refs`（commit-with-prefix skill 内置 gates）
- [ ] commit 前缀：`[zh-final]`（per CLAUDE.md 规范）
- [ ] commit message 模板：`[zh-final] hugo-draft-stale-dev-server-fix + 用户实操整合`
- [ ] **不自动 push**（CLAUDE.md §6，等用户确认）

---

## ⚠️ 触发的硬约束（再检查一遍）

1. **CLAUDE.md §3.1** front matter 必带 cover.image + cover.alt ✓ 在 TODO #2
2. **CLAUDE.md §3.2** 发布英文版 .md body 必须英文 → `[zh-final]` 是中文但保留 `lint_allow` 豁免（draft / zh-final 阶段）；`[en-final]` 翻译时移除
3. **CLAUDE.md §3.8 rule 1** first-person ONLY in zh-final + only with hands-on fact basis → 已确认（D10/D17 事实）
4. **CLAUDE.md §3.8 rule 6** cross-reference 必须有锚点 → §Fingerprint Tip / §D17 复盘新发现 段引用 commit `581555b`（commit log 可验证）✓
5. **CLAUDE.md §3.3.2** 截图 ≤ 1440px → commit `47c9a01` 已优化至 1440×558 ✓
6. **CLAUDE.md §3.3.4** PII 脱敏 → draft 内无个人账户信息 ✓

---

## 📎 相关文件 + commit 锚点

| 文件 / commit | 状态 | 用途 |
|---|---|---|
| `content/posts/static-site/hugo-draft-stale-dev-server-fix/index.md` | [draft] 当前 | 待 zh-final 重构 |
| `assets/images/static-site/hugo-draft-stale-dev-server-fix/step-1-public-dir-before-cleanup.png` | 已入库 | Step 1 截图（待复用为 cover 选项 B 素材） |
| `assets/images/static-site/hugo-draft-stale-dev-server-fix/step-6-dev-server-restart.png` | 已入库 | Step 6 截图（**cover 选项 A 推荐**） |
| commit `451e0c3` | [draft] 创建 | draft 文件 + topic-pool 同步 |
| commit `0200161` → `fafac94`（revert）→ `47c9a01` | [asset] 截图迭代 | 最终 commit `47c9a01` 真实还原入库 |
| commit `581555b` | D10 修复（不完整）| S18 真实事故锚点（draft §Environment 已引用） |
| `docs/archive/topic-pool-2026-08-27-archive.md` §S18 | 选题存档 | S18 来源 + 推荐理由 |

---

## 🔄 阶段六完成后流程

[zh-final] commit push 后：

1. 触发 `translate-zh-to-en` skill（阶段五）
2. 翻译完成后 commit `[asset] / [post] hugo-draft-stale-dev-server-fix + 英文版`
3. CF Pages rebuild → heimaeden.com 线上生效
4. 24-48h 后 GSC 监控索引状态
5. topic-pool.md S18 状态从 🎯 推荐中 → ✅ 已完成（commit hash + 字数）
6. README §6 加 D19 状态校准（zh-final + en-final 完成记录）

---

*保存：D18（2026-08-27）/ 用户决定：实操足够 + first-person 混合 + 加 cover / 下次会话 trigger：「继续 S18 zh-final」*
