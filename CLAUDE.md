# CLAUDE.md — HeimaEden Project Auto-Loaded Instructions

> **Auto-loaded by Claude Code on every session start.** This file is the
> **single source of truth for hard constraints**. Soft strategy lives in
> `README.md` §7. Workflow SOP lives in `Content-Agent-TCM.md`.
>
> **Project clock**:
> - Start date = **2026-08-11** (D0, domain registration)
> - This file's authoring = **D3** (2026-08-14)
> - Last revision = **D5** (2026-08-16) — added §3.9 中文会话铁律

---

## 1. Project Identity

- **Site**: https://heimaeden.com — Hugo static blog, PaperMod theme
- **Owner intent**: English-language overseas tech blog + affiliate marketing
- **AI combo (TCM)**: MiniMax-M3 (default tier) ➔ Claude Opus 4.6 (translation / SEO tier)
- **Hard-coded locale**: `locale = "en-us"`, `hasCJKLanguage = false`

---

## 2. Directory Map (do not reorganize without consulting README §7.3)

```
/                       # repo root
├── README.md           # strategic roadmap (do not move sections around)
├── CLAUDE.md           # this file (hard constraints)
├── Content-Agent-TCM.md  # TCM 6-stage SOP
├── hugo.toml           # site config (TOML only)
├── archetypes/default.md
├── assets/
│   ├── css/extended/extended.css   # theme override (geek-green)
│   └── images/                     # CONTENT screenshots (Hugo-processed → WebP)
│       └── <category>/             # e.g. static-site/, remote-payment/
│           ├── <shared>.png        # cross-article in same category
│           └── <article-slug>/     # e.g. static-blog-setup-guide/
│               └── <purpose>.png   # article-specific screenshots
├── content/
│   ├── about.md, archives.md, search.md
│   ├── legal/                       # privacy/cookie/terms/affiliate
│   └── posts/
│       ├── remote-payment/         # M4 money hook target
│       └── static-site/            # existing 2 long-form posts
├── layouts/
│   ├── _markup/render-image.html   # image render hook (WebP + lazy + dimensions)
│   ├── _partials/header.html       # custom override
│   └── partials/extend_head.html   # OG fallback tags
├── scripts/
│   ├── lint-post.sh                # front matter / body constraint linter
│   ├── optimize-image.sh           # MUST run before staging screenshots (§3.3.2)
│   └── redact-image.sh             # MUST run on screenshots with PII (§3.3.4)
├── static/                         # GSC verify, robots.txt, _redirects
│   └── images/og-default.png       # OG card ONLY — never content screenshots
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
- **Path format**: `/images/<filename>.ext` — leading slash, **never** include `static/`. Article-specific images **must** be prefixed with category and article slug (see §3.3.1).
- **Alt text**: every image must have non-empty alt.
- **Source whitelist**: Unsplash, Pexels, self-captured screenshots. Never Google Images hotlink.

#### 3.3.1 Storage layout (added 2026-08-16, D5) — put the file in the right place

| Kind | Directory | Why |
|---|---|---|
| **OG / social card** (`og-default.png`) | `static/images/` | Social scrapers handle WebP unreliably and need a stable, non-fingerprinted URL. **Never move this to assets/.** |
| **Content screenshots** | `assets/images/<category>/<article-slug>/` | Hugo can only read dimensions / re-encode files under `assets/`. Per-article subdirectory keeps ownership unambiguous (delete article → delete folder → zero orphans). |

**Path naming convention** (apply to both directory layout and Markdown reference):

| Scope | Directory | Markdown reference |
|---|---|---|
| **Article-specific** (default) | `assets/images/<category>/<article-slug>/<purpose>.png` | `/images/<category>/<article-slug>/<purpose>.png` |
| **Shared across articles in same category** | `assets/images/<category>/<purpose>.png` | `/images/<category>/<purpose>.png` |

`<category>` is the lowercase-hyphenated form of the front-matter `categories[0]` value. `<article-slug>` matches the article's directory name under `content/posts/`.

**Example**: an image used only by `content/posts/static-site/static-blog-setup-guide.md` lives at `assets/images/static-site/static-blog-setup-guide/foo.png` and is referenced as `![alt](/images/static-site/static-blog-setup-guide/foo.png)`.

The render hook (`layouts/_markup/render-image.html`) does a straight `resources.Get` lookup — no category inference. If the article references a path that doesn't exist under `assets/`, the build will warn and serve the image unprocessed (no WebP, no `width`/`height`). **A build with `render-image` warnings is broken — fix the path, don't ignore it.**

Do **not** hand-write `<img>` tags in Markdown.

#### 3.3.2 MANDATORY: optimize before `git add`

**Any new screenshot MUST pass `./scripts/optimize-image.sh` before being staged.** Width ceiling **1440px** (2× PaperMod's ~720px content column; anything beyond is invisible to every user).

```bash
./scripts/optimize-image.sh            # resize assets/images/ in place
./scripts/optimize-image.sh --check    # verify only, exit 1 if oversized
```

**Rationale — this rule is non-negotiable**: Git cannot delta-compress binaries. Every commit of an oversized PNG stores a **full new blob permanently**; screenshot posts get re-cropped often, so the waste compounds. Unlike a bad line of code, this **cannot be fixed by a later commit** — only by rewriting history (`git filter-repo`). Optimize up front or pay forever.

**Claude Code duty**: when the user says screenshots are in place, run `optimize-image.sh` **automatically before staging** — do not wait to be asked.

#### 3.3.3 Do NOT hand-optimize for the web

WebP conversion, `width`/`height`, `loading="lazy"`, and `fetchpriority` are all emitted at build time by `layouts/_markup/render-image.html`. Never duplicate this in Markdown, in the script, or via external tools. `sips` cannot output WebP anyway; Hugo extended does it natively.

Build-time warnings from that hook (`render-image: "..." not found under assets/`) mean a **broken image link** — treat as an error, not noise.

#### 3.3.4 MANDATORY: redact PII before commit (added 2026-08-16, D5)

Any screenshot containing UI that surfaces account-level data MUST pass `./scripts/redact-image.sh` **before `git add`**. Once PII (email, ID number, card tail, phone, full name, account number) reaches the public CDN, there is **no recall** — the value is permanently in the wild.

**Workflow** (two-step — AI cannot paint pixels directly):

1. **User** saves the raw screenshot locally and tells Claude Code "needs redaction for: <concerns>" (e.g. *email, card last 8, full name*).
2. **Claude Code** `Read`s the image, identifies pixel coordinates of every region that looks like PII, and reports a list of `--box x,y,w,h` flags. Mark every region with a confidence tag (🔴 likely PII / 🟡 could be / ⚪ UI element). **The user makes the final call** — AI redacts conservatively, not aggressively.
3. **User** runs:
   ```bash
   ./scripts/redact-image.sh raw.png clean.png \
     --box 340,52,180,18 \    # email
     --box 220,180,260,22 \   # card tail
     --box 50,300,150,20      # full name
   ```
   Coordinates are pixels relative to the image's natural dimensions. Use `sips -g pixelWidth -g pixelHeight <file>` to confirm size before drafting boxes.
4. **User** visually verifies `clean.png` (Preview / Quick Look) **before** moving it into `assets/images/<category>/<article-slug>/`.

**Defaults**: opaque black fill `RGB(0,0,0)`, PNG container (lossless — WebP conversion is the render hook's job, not this script's). The script refuses to overwrite the source, rejects out-of-bounds and zero/negative-dimension boxes, and exits non-zero on any validation failure.

**Dependencies**: `python3` + Pillow (`pip3 install --user Pillow`). The script detects missing Pillow and prints the install command.

**Anti-patterns**:
- ❌ **Cropping instead of overlaying**. `sips -c H W` destroys surrounding context. Black overlay keeps it.
- ❌ **"Just blur lightly"**. Edge pixels leak. Black is forever; blur is forever-ish.
- ❌ **Skipping redaction for "internal-looking" UIs** (Spaceship dashboard, PayPal wallet). Anything showing *your* account is still PII.

**Claude Code duty**: when the user says "需要脱敏" / "needs redaction", **automatically** read the image, propose `--box` flags with confidence markers, and wait for user confirmation before they run the script — do not skip the user-review step.

#### 3.3.5 MANDATORY: pre-publish file-size audit (added 2026-08-29, D20)

**Every image committed to `assets/images/` MUST pass `./scripts/check-image-size.sh` before `git push`.** Width (≤1440px, §3.3.2) and file-size are **two separate ceilings**: `sips` can resize a PNG without re-compressing it, leaving a 1440px image weighing 1.3MB — exactly what happened to S18's cover before D20 (`132KB source → 1.3MB after resize-only optimize`).

**Thresholds** (single source of truth — `scripts/check-image-size.sh` enforces the same numbers):

| Asset kind | Warn at | **ERROR at** |
|---|---|---|
| `cover.*` (hero / OG image) | 150 KB | **200 KB** |
| body screenshots | 350 KB | **500 KB** |

**Rationale**:

- **Cover** is loaded eagerly on every page view AND embedded as the OG share card. The PaperMod `cover.html` template (line 37) uses `Resize "%sx"` with **no format flag**, so the srcset fallback is the SOURCE asset — a 1.3MB source produces a 1.3MB largest variant. Affects LCP and Twitter/LinkedIn preview load.
- **Body** images are lazy-loaded (`render-image.html` line 52 sets `loading="lazy"`), so the budget is higher. 500KB is still painful on 4G; prefer ≤ 350KB when possible.
- **Hugo's build pipeline does NOT re-compress source PNGs**. Only resizing happens. Compression must happen at the SOURCE asset layer — exactly the layer this rule targets.

**Workflow**:

```bash
# 1. Run the gate (exit 1 if any image over error threshold)
./scripts/check-image-size.sh

# 2. If something fails, compress the listed PNG in place:
python3 -c "from PIL import Image; import sys
img = Image.open(sys.argv[1])
img.quantize(colors=256, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE
    ).save(sys.argv[1], 'PNG', optimize=True, compress_level=9)" path/to/file.png

# 3. Re-run the gate until clean.
./scripts/check-image-size.sh
```

256-color palette quantization is **visually lossless** for flat-vector illustrations and AI-generated covers (verified on S18 cover, see `96a48f2`). For dense UI screenshots where 256 colors introduce visible banding, fall back to `lossless=True` optimize + `compress_level=9` (gives ~15-20% reduction) — but this is the exception, not the default.

**Dependencies**: `python3` + Pillow (`pip3 install --user Pillow`). Already required by `redact-image.sh` (§3.3.4), so no new install.

**Claude Code duty**: when adding a new image to `assets/images/`, run `check-image-size.sh` **automatically before staging** — do not wait to be asked. Mirror the same duty for `optimize-image.sh` (§3.3.2). The two scripts are **complementary, not redundant**: `optimize-image.sh` enforces pixel width, `check-image-size.sh` enforces file size.

#### 3.3.6 NOTE: `hugo --gc` does NOT clean stale files in `public/` (added 2026-08-29, D20)

`hugo --gc` cleans the `resources/` cache AND removes **fingerprint-derived** assets in `public/` that no current page references (e.g. `cover_hu_<oldhash>.png`). It does **NOT** remove **same-named** assets whose URL path is now unused — a file renamed or deleted in `assets/` leaves a stale copy in `public/` that dev server / production will keep serving until manually purged.

**Concrete failure mode** (hit on D20): renamed `cover.png` → `cover.jpg` for the `claude-code-editorial-pipeline` article. After `hugo --gc`, `public/images/.../cover.jpg` was the new 84 KB asset, but `public/images/.../cover.png` (898 KB old) was **still served with HTTP 200** by `hugo server`. Old `cover.png` had no current page referencing it, but it was not fingerprinted — it was a direct copy of the source file — so `--gc` had nothing to garbage-collect on it.

**Symptoms of this gotcha**:

- `curl` to the old asset path returns 200 OK after a rename, even though `assets/` no longer contains the source.
- `hugo --gc` build log shows zero warnings (it cannot see its own stale output).
- Production (CF Pages) keeps the old asset on its CDN until the next full rebuild re-syncs `public/` — or never, if your deploy hook doesn't clear stale files.

**Fix** — when renaming or deleting any `assets/` file, **before** running the dev-server / `hugo --gc` validation that gates commit-with-prefix:

```bash
rm -rf public/ resources/        # clean slate; nothing in git, both are build artifacts
hugo --gc                          # rebuild from scratch — no stale carry-over
```

`public/` and `resources/` are `.gitignore`-d build outputs; deleting them is safe and local-only (no remote impact). This is the **same rule as §6** for `rm -rf public` / `rm -rf resources` — the difference is §6 requires explicit user instruction for live deploys, while this §3.3.6 rule is *self-authorized* for local pre-commit validation.

**Trigger history**: D20 cover.png → cover.jpg rename surfaced this; without the explicit `rm -rf public/`, the local smoke test reported a false-positive 200 on the deleted path and would have hidden a CDN-level stale-asset leak on the next CF Pages deploy.

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
2. **Topic recommendation is context-driven**. AI 不凭空选题. Before recommending, must scan: (a) existing `content/posts/*` distribution by category; (b) `docs/archive/think-templates-2026-08-27.md` / `docs/archive/think-payment-2026-08-27.md` topic coverage; (c) recent 3 posts (avoid consecutive same-topic); (d) Money Hook density vs README §7.3 E1 (≥15 篇长文 → AdSense). 题目库协作产生于 `docs/archive/topic-pool-2026-08-27-archive.md` (TBD by separate session).
3. **Real content screenshots only**. AI does NOT use Unsplash/Pexels as content screenshots (those are for cover images only, per §3.3). Content screenshots MUST come from user's hands-on operation. 初稿必须标注截图位（位置 + 脱敏 + 文件命名规范）。
4. **Affiliate placeholders in 初稿, not translation**. 初稿阶段就标 `[联盟-占位 platform]` + 推荐用语模板（按 README §五-3 双向互惠）。不延迟到翻译阶段。
5. **Translation is 字面对应, not 改写**. 第三阶段翻译：AI 不增删任何事实, 不改写用户原话, 仅做字面对应 + 地道英语表达 + SEO 结构。
6. **Cross-reference facts must have explicit anchors** (added 2026-08-16, D5). AI 起草时, 凡涉及**跨文章 / 跨工具 / 跨阶段**的事实性 cross-reference (e.g. "AdSense 收款可直接复用 PayPal 通道"), 必须能在以下任一锚点直接验证: (a) 用户本会话口述; (b) `CLAUDE.md` / `README.md` / `docs/*.md` 已有记录. **无锚点 → 必须用占位语**（如 "详见 XXX 文章" / "[待确认：YYY]"）, **绝不写结论句**. Violation = 凭空添加 cross-reference 关系, 与 rule 5 同等严重 (内容农场反模式).
7. **Cluster integration before [zh-final]** (added 2026-08-30, D21). Before [zh-final] commit, scan existing articles in same `categories` + last 30 days for cluster opportunity. If ≥2 articles share topic (keyword / persona / workflow 连续性):
   - (a) Mutual `{{< ref "posts/<cat>/<slug>" >}}` cross-references in body — only where narrative relationship actually exists (no decoration-only refs)
   - (b) `series = ["<Series Name>"]` front matter on **BOTH** articles
   - (c) Shared tag on **BOTH** articles (e.g. `"Claude Code Pipeline"`)
   - (d) **Bidirectional** — partner article updated in same `[polish]` commit; a one-sided cluster is a hidden bug

   Verify: `hugo --gc --buildDrafts` 0 errors. Production `hugo --gc` with cluster partner still in `draft = true` is acceptable during [zh-final] → en-final transition; resolves when draft flips to false. Integration SOP: see `docs/article-writing-workflow.md §5.2.2`.

Full 8-step SOP + 联盟预留格式 + 截图标注格式 + commit 边界：see `docs/article-writing-workflow.md`.

> **D4 lesson**: B1 长文 #1 (`commit 4b8a8ea`) was reverted (`commit bc9a369`) because AI fabricated first-person debugging experience. This SOP exists to prevent recurrence.
> **D5 lesson**: A3 扩写 (D5 第七次 commit 序列) 文末 AI 写了 "AdSense 收款可直接复用同一 PayPal 通道" — 这是无锚点 cross-reference 凭空结论, 实际收款走 WorldFirst (万里汇) 不是 PayPal. 用户当场指出后修正 + 加模糊化 6 处凭印象数字. 触发本条 rule 6 建立.
> **D21 lesson**: Y1 ↔ A2 聚簇集成时发现 — A2 §2.4 / §6 早有 mock-reader-feedback skill narrative 提及（commit `7d2cdee` D10 已建立），但**正文用 plain text 而非 `{{< ref >}}` shortcode** — 渲染后是 broken link（HTML 看不到 `[claude-code-editorial-pipeline]` 这种 anchor）。同时 Y1 + A2 front matter 都缺 `series = [...]` + 共用 tag。集群信号存在但缺失形式化集成。触发本条 rule 7 建立。

### 3.9 会话默认语言 (added 2026-08-16, D5) — 铁律

与用户的所有对话、AskUserQuestion 选项、说明性 prose、错误消息默认使用**中文**。这是 Claude Code 与用户交互的硬约束，**与文章 body 语言无关**（§3.2 仍然要求 ship 的 `.md` body 是英文）。

**适用范围**：
- ✅ Claude Code 回复、提问、解释 → 中文为主
- ✅ AskUserQuestion 选项 label / description → 中文
- ✅ 错误诊断、验证报告、commit 建议 → 中文
- ✅ 工作区状态汇报、文件改动总结 → 中文

**保留英文**（专业术语按惯例）：
- 技术名词：Hugo, PaperMod, Cloudflare, PaperMod toggle key, WebP, lazy-loading, fetchpriority, TOML, front matter, PII, CSP, SRI 等
- 代码块、文件路径、commit message、git 命令
- 引用官方英文文档片段时保持原文
- 用户口述的英文术语（如 "lint-post" 之类的脚本名）保持原名

**触发历史**：用户于 D5 2026-08-16 明确要求 "转化成中文选项，后续与你的对话都以中文为主，记录到铁律中"，此前 Claude 一直默认英文造成用户阅读成本。

---

## 4. FORBIDDEN PATTERNS

- ❌ YAML-style front matter (any `:` in front matter)
- ❌ Future-dated `date` field
- ❌ Direct image references without leading `/` or with `static/` prefix
- ❌ Committing a screenshot wider than 1440px (see §3.3.2 — irreversible repo bloat)
- ❌ Committing an image over the file-size ceiling (cover > 200 KB / body > 500 KB; see §3.3.5)
- ❌ Putting content screenshots in `static/images/`, or moving `og-default.png` out of it (see §3.3.1)
- ❌ Hand-written `<img>` tags in Markdown (bypasses the render hook → loses WebP/lazy/dimensions)
- ❌ Committing a screenshot with visible PII (see §3.3.4 — no recall once public)
- ❌ CJK characters in any shipped `.md` body or alt text
- ❌ Affiliate `<a>` without shortcode wrap and proximity disclosure
- ❌ Bypassing the TCM SOP (e.g. manually pushing to `main` without `lint-post.sh` passing)
- ❌ Running `rm -rf public`, `rm -rf resources`, `git push --force`, `git reset --hard` without explicit user instruction

---

## 5. WORKFLOW ANCHORS (look here FIRST)

| Question | Go to |
|---|---|
| "What stage are we in?" | `README.md §7.3 Forward Battle Map` |
| "What just happened?" | `README.md §6 Dynamic Notes` |
| "How do I run TCM stage X?" | `Content-Agent-TCM.md` |
| "How do I write a new long-form post?" | `docs/article-writing-workflow.md` (8-step collaboration SOP) |
| "Is this hard rule?" | this file (§3) |
| "Is this preference?" | `README.md §5 Operational Precautions` |
| "Local `hugo server` shows 404 for newly-added images?" | `docs/dev-server-baseurl.md` — `--baseURL http://localhost:1313/` override required |

### Pre-action checklist (every time you produce or modify a `.md`)

1. Confirm the task belongs to current `README.md §7.3` phase; if missing, propose new bullet there first.
2. Apply §3 constraints while writing.
3. Run `/scripts/lint-post.sh <path>` if it exists, or rebuild with `hugo --gc` and verify zero errors.
4. **Image audit** (added D20): if the diff includes any `assets/images/...` file, run `./scripts/check-image-size.sh` **before staging**. If a body image exceeds 500 KB or a cover exceeds 200 KB, compress in place with the PIL palette-quantize snippet in §3.3.5 and re-run until clean. This complements `optimize-image.sh` (width ceiling, §3.3.2) — the two scripts are not redundant.
5. Report output as a structured diff: files changed / constraints checked / lint result.

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

1. Re-read relevant section of `README.md` (strategy) and `Content-Agent-TCM.md` (workflow).
2. Re-read §3 above — does this violate a hard constraint?
3. If still unclear, **ask the user** before any file write. Never assume.
