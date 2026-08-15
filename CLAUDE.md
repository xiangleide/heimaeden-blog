# CLAUDE.md — HeimaEden Project Auto-Loaded Instructions

> **Auto-loaded by Claude Code on every session start.** This file is the
> **single source of truth for hard constraints**. Soft strategy lives in
> `README.md` §7. Workflow SOP lives in `Content-Agent-ACM.md`.
>
> **Project clock**:
> - Start date = **2026-08-11** (D0, domain registration)
> - This file's authoring = **D3** (2026-08-14)

---

## 1. Project Identity

- **Site**: https://heimaeden.com — Hugo static blog, PaperMod theme
- **Owner intent**: English-language overseas tech blog + affiliate marketing
- **AI combo (OCM)**: OpenClaw gateway ➔ MiniMax (default tier) ➔ Claude (translation / SEO tier)
- **Hard-coded locale**: `locale = "en-us"`, `hasCJKLanguage = false`

---

## 2. Directory Map (do not reorganize without consulting README §7.3)

```
/                       # repo root
├── README.md           # strategic roadmap (do not move sections around)
├── CLAUDE.md           # this file (hard constraints)
├── Content-Agent-ACM.md  # OCM 6-stage SOP
├── hugo.toml           # site config (TOML only)
├── archetypes/default.md
├── assets/css/extended/extended.css   # theme override (geek-green)
├── content/
│   ├── about.md, contact.md, archives.md, search.md
│   ├── legal/                       # privacy/cookie/terms/affiliate
│   └── posts/
│       ├── payment/                # M4 money hook target
│       └── static-site/            # existing 2 long-form posts
├── layouts/partials/footer.html    # custom override
├── static/                         # GSC verify, robots.txt, images root
└── themes/PaperMod/                # TODO: migrate to Hugo Modules
```

---

## 3. HARD CONSTRAINTS (auto-enforced via `/scripts/lint-post.sh` once added)

### 3.1 Front Matter
- **Syntax**: `+++` TOML only. Never YAML (`---` / `title: foo`).
- **Assignments**: use `=`, never `:`.
- **Required fields**:
  - `title` (string)
  - `date` (datetime — **must be in the past**, never future; future dates silently hide the post in production)
  - `draft` (bool, default `false`)
- **Recommended fields**:
  - `description` (≤ 160 chars, used as SEO meta)
  - `tags`, `categories` (arrays)
  - `slug`
  - `toc = true` (any post > 500 words)
  - `cover.image` + `cover.alt` (every post must have a cover image)

### 3.2 Content Body
- **Final-published language**: English only. No CJK characters, no Chinese punctuation in any `.md` body that ships.
- **Per-file exemption (grandfather clause)**: existing pre-rule posts may declare
  ```toml
  lint_allow = ["cjk-body"]
  ```
  to opt out of the CJK check. **New posts must not** add this token — the linter enforces strict English-only going forward. Use HTML-comment fallback in body if TOML is awkward:
  `<!-- lint-allow:cjk-body -->`. Future allow keys: `code-lang`, `image-path`, etc.

### 3.7 PaperMod Toggle-Key Trap (read once, never forget)
- PaperMod's theme-toggle gating reads **`disableThemeToggle`** (inverted), NOT `showThemeToggle`.
- The relevant template predicates are `{{ if (not site.Params.disableThemeToggle) }}` in `header.html`, `footer.html`, and `head.html`.
- **Correct config**: `disableThemeToggle = false` inside `[params]`.
- Setting `showThemeToggle = true` is a NO-OP — PaperMod never consults it.
- Combined with `[params.assets] disableSRI = true` to keep the inline click handler alive across Cloudflare Pages builds.
- **Heading hierarchy**: title is H1 (rendered by theme). Body must start at H2. No orphan H1.
- **Tone**: factual + first-person-conversational. No SEO-spam phrases ("ultimate guide", "you won't believe").
- **Length**: long-form posts ≥ 800 words, contain at least 2 real screenshots or code blocks.

### 3.3 Images
- **Path format**: `/images/<filename>.ext` — leading slash, **never** include `static/`.
- **Alt text**: every image must have non-empty alt.
- **Layout** (preferred): Page Bundles — `content/posts/<slug>/index.md` + colocated images.
- **Source whitelist**: Unsplash, Pexels, self-captured screenshots. Never Google Images hotlink.

### 3.4 Links
- **Internal**: shortcode `{{< ref "path/to/page" >}}`. Never hand-typed absolute paths between own content.
- **External** with `target="_blank"`: must include `rel="noopener"`.
- **Affiliate**: **must** be wrapped — never raw `<a href>`. Use shortcode (to be defined in `data/affiliates.toml`).
- **FTC proximity disclosure**: every affiliate link in body must be immediately followed by inline `(affiliate link)` marker.

### 3.5 Code Blocks
- Always specify language (` ```bash ` not bare ` ``` `).
- Lines > 40: wrap in `<details><summary>Show full output</summary>...</details>`.

### 3.6 Filename Conventions (new files)
- Kebab-case only: `my-new-post.md`. No PascalCase, no spaces, no curly apostrophes in filenames.

### 3.8 Article Writing Collaboration SOP (added 2026-08-15, D4)

Hard rules when writing English long-form posts (≥800 words). Violation = content-farming anti-pattern (Google HCU risk).

1. **AI does not write first-person experience in 初稿**. First-draft tone must be step-by-step 操作清单 ("步骤 1：打开 X..."), NOT "I went through this debugging marathon...". First-person ONLY appears in 第二版, AND only when user has hands-on fact basis to back it up.
2. **Topic recommendation is context-driven**. AI 不凭空选题. Before recommending, must scan: (a) existing `content/posts/*` distribution by category; (b) `think-templates.md` / `think-payment.md` topic coverage; (c) recent 3 posts (avoid consecutive same-topic); (d) Money Hook density vs README §7.3 E1 (≥15 篇长文 → AdSense). 题目库协作产生于 `docs/topic-pool.md` (TBD by separate session).
3. **Real content screenshots only**. AI does NOT use Unsplash/Pexels as content screenshots (those are for cover images only, per §3.3). Content screenshots MUST come from user's hands-on operation. 初稿必须标注截图位（位置 + 脱敏 + 文件命名规范）。
4. **Affiliate placeholders in 初稿, not translation**. 初稿阶段就标 `[联盟-占位 platform]` + 推荐用语模板（按 README §五-3 双向互惠）。不延迟到翻译阶段。
5. **Translation is 字面对应, not 改写**. 第三阶段翻译：AI 不增删任何事实, 不改写用户原话, 仅做字面对应 + 地道英语表达 + SEO 结构。

Full 8-step SOP + 联盟预留格式 + 截图标注格式 + commit 边界：see `docs/article-writing-workflow.md`.

> **D4 lesson**: B1 长文 #1 (`commit 4b8a8ea`) was reverted (`commit bc9a369`) because AI fabricated first-person debugging experience. This SOP exists to prevent recurrence.

---

## 4. FORBIDDEN PATTERNS

- ❌ YAML-style front matter (any `:` in front matter)
- ❌ Future-dated `date` field
- ❌ Direct image references without leading `/` or with `static/` prefix
- ❌ CJK characters in any shipped `.md` body or alt text
- ❌ Affiliate `<a>` without shortcode wrap and proximity disclosure
- ❌ Bypassing the OCM SOP (e.g. manually pushing to `main` without `lint-post.sh` passing)
- ❌ Running `rm -rf public`, `rm -rf resources`, `git push --force`, `git reset --hard` without explicit user instruction

---

## 5. WORKFLOW ANCHORS (look here FIRST)

| Question | Go to |
|---|---|
| "What stage are we in?" | `README.md §7.3 Forward Battle Map` |
| "What just happened?" | `README.md §6 Dynamic Notes` |
| "How do I run OCM stage X?" | `Content-Agent-ACM.md` |
| "How do I write a new long-form post?" | `docs/article-writing-workflow.md` (8-step collaboration SOP) |
| "Is this hard rule?" | this file (§3) |
| "Is this preference?" | `README.md §5 Operational Precautions` |

### Pre-action checklist (every time you produce or modify a `.md`)

1. Confirm the task belongs to current `README.md §7.3` phase; if missing, propose new bullet there first.
2. Apply §3 constraints while writing.
3. Run `/scripts/lint-post.sh <path>` if it exists, or rebuild with `hugo --gc` and verify zero errors.
4. Report output as a structured diff: files changed / constraints checked / lint result.

---

## 6. DESTRUCTIVE OPERATION POLICY

Never run without **explicit user instruction**:

- `rm -rf` on tracked dirs (`public/`, `resources/`, `themes/PaperMod/`)
- `git reset --hard` / `git checkout .` / `git restore .`
- `git push --force` / `git branch -D`
- `wrangler` / Cloudflare dashboard writes (Settings, Custom Domains)
- Editing any file under `themes/PaperMod/` (propose Hugo Modules migration instead)

---

## 7. KNOWN ISSUES (live log, append-only)

Entries get added by `/scripts/ingest-fail.sh` (manual for now) when something breaks.
Format:
```
- [YYYY-MM-DD] symptom → root cause → fix (path:line)
```

Current known issues live in §6 of `README.md`. When triaged, mirror them here with one-line summary for quick scanning.

---

## 8. WHEN UNSIDE

Default order of resolution:

1. Re-read relevant section of `README.md` (strategy) and `Content-Agent-ACM.md` (workflow).
2. Re-read §3 above — does this violate a hard constraint?
3. If still unclear, **ask the user** before any file write. Never assume.
