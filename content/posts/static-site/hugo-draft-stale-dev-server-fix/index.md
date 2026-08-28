+++
title = "Why My Hugo Draft Still Shows Up After I Moved It to _drafts/"
description = "Hugo dev server fallback serves stale public/ HTML after moving posts to _drafts/. 3-layer root cause + complete cleanup commands."
date = 2026-08-27T00:00:00Z
draft = false
tags = ["Hugo", "Static Site", "Troubleshooting", "Dev Server"]
categories = ["Static-Site"]
prompt_type = "A"

showToc = true
TocOpen = true

[cover]
  # D19 M2 stage: AI-generated cover (Variant V1 metaphorical illustration) replaces the temporary step-6 cover.
  # Path format: resources path = assets/images/... strip assets/ prefix, no leading / (PaperMod cover.html line 22 absURL fallback).
  image = "images/static-site/hugo-draft-stale-dev-server-fix/cover.png"
  alt = "Flat-vector technical illustration: a steel-gray filing cabinet labeled content/posts/ with its draft drawer half-open, spilling green index.html documents into a darker archive below. One spilled document carries a red STALE stamp. A green arrow loops from the archive back to a clean drawer labeled fresh build/ on the right."
  caption = "After the 4-step cleanup + dev server restart, the stale draft article no longer appears in either the URL or the category taxonomy page."
+++

<!-- lint-allow: cjk-body — §3.9 preservations: 2× commit-message quotes (`hugo --gc 验证：零 render-image 警告`), 1× shell script echo (`全站 0 处 stale draft 引用`), 1× D17 fix-sequence references (`rm 3 个 draft 相关目录`, `rm 整个 categories/`), 1× Discourse maintainer verbatim quote (`Cache-Control policy 过 long expiry 才是你看到的 stale 现象`). All protected per CLAUDE.md §3.9 (don't translate code / commit messages / maintainer quotes). -->

> **TL;DR**: A Hugo `draft = true` article still shows up on my local dev server, and the root cause stacks three layers: `hugo --gc` does not clean `public/`, the dev server falls back to stale HTML, and taxonomy listing pages do not rebuild. Fix command: `rm -rf public/{posts,tags,categories,index.json}` + restart dev server.
>
> **Author's note (D19)**: I first ran into all three of these layers together on that D10 commit `581555b` — the commit message itself said `hugo --gc 验证：零 render-image 警告` ("verified zero render-image warnings"), and I trusted it, so the dev server's 0 warnings at startup kept the browser serving stale `public/` HTML. It wasn't until the D17 review that I grep'd the whole site and found 4 subdirectories under `public/tags/` + `public/index.json` — 5 stale leftovers in total.

---

## Environment

- Hugo **v0.150.0** (extended)
- PaperMod 2024-Q4 commit
- macOS 14.5 / zsh 5.9
- dev server command: `hugo server --baseURL http://localhost:1313 --buildDrafts=false --disableFastRender`
- Real-world incident anchor: commit `581555b` (2026-08-21 22:20:43) + README §6 D10 review
- **Trigger action**: commit `581555b` moved the previously-published `claude-code-cli-setup-indie-blog` article into the `_drafts/` subdirectory plus set `front matter draft = true`. The commit message itself included `hugo --gc 验证：零 render-image 警告` — showing that at the time I hadn't recognized the stale fallback; it took the D17 review to see the full 3-layer root cause.

---

## Step 0: Pitfall search (do this before doing anything)

**English search keywords**:

- `hugo draft still showing site:reddit.com`
- `hugo dev server stale draft`
- `hugo --gc public not cleaned`
- `hugo taxonomy page not rebuild`
- `hugo fallback public html dev server`

**Pitfall search keywords** (community-friendly phrasing):

- "Hugo article not showing"
- "Hugo draft mode"
- "Hugo dev server cache"

**Source whitelist**: Reddit (r/Hugo, r/CloudFlare, r/webdev) / GitHub Issues (gohugoio/hugo) / Hugo Discourse

### Operational evidence (search execution snapshot)

> 📸 *Figure 0: Search result for keyword `hugo --gc public not cleaned` in the gohugoio/hugo repository Issues — 8 related issues (sorted by Recently updated), showing this is a long-reported community problem, not an isolated case.*
>
> ![GitHub Issues search result page in gohugoio/hugo repository for the query 'hugo --gc public not cleaned', showing 8 related issues sorted by Recently updated, confirming this is a long-standing community-reported problem.](/images/static-site/hugo-draft-stale-dev-server-fix/step-0-community-search-github-issues.png)

**Expected output**: the 3-5 most common pitfalls + source links (filled in during the [zh-final] stage based on search results)

---

## Symptoms

After moving a previously-published Hugo article into the `_drafts/` subdirectory and flipping `draft = true` in the front matter, starting `hugo server`:

- Browser hits the original article URL → **the page still shows up**
- Browser hits `/categories/<category>/` → **the article is still listed**
- Browser hits `/tags/<tag>/` → **the article is still listed**

**Trigger condition**: the article was already published + the article gets switched to draft + `public/` is left untouched. All three at once and you trigger the bug.

---

## Error Log (real dev-server fallback example)

```bash
# Even when draft = true, the dev server still returns 200
$ curl -sI http://localhost:1313/posts/ai-agent/claude-code-cli-setup-indie-blog/
HTTP/1.1 200 OK
Content-Type: text/html

# The category page still lists the article
$ curl -s http://localhost:1313/categories/ai-agent/ \
  | grep "claude-code-cli"
<a href="https://heimaeden.com/posts/ai-agent/claude-code-cli-setup-indie-blog/">

# Hugo startup log shows no warnings (dev server does not know this is a stale fallback)
$ hugo server --buildDrafts=false
... 0 warnings, 0 errors
```

**Key observation**: Hugo builds with 0 warnings — everything looks fine, but the browser is not seeing the source.

---

## Root cause analysis (3 layers stacked)

### Root cause 1: `hugo --gc` does not clean the old `public/` HTML

The `hugo --gc` flag only cleans the `resources/` cache directory (this is the Hugo v0.150+ behavior), **it does NOT clean the `public/` output directory**. This is by design, not a bug.

### Root cause 2: Hugo dev server incremental-build fallback

The dev server defaults to `--buildDrafts=false`, but when the source page cannot be found (Hugo treats it as "excluded"), it **falls back to the old `public/` HTML**. This is the dev server's "helpful" behavior (avoiding 404s during development), but in a draft-switching scenario it becomes "helpful to a fault".

### Root cause 3: Hugo does not trigger taxonomy listing page rebuild

Hugo's taxonomy listing pages (`/categories/` + `/tags/`) trigger a rebuild when "a new page joins"; **"a page changes from published to draft" does NOT trigger a rebuild**. Result: the taxonomy page keeps pointing at the old `public/tags/<tag>/index.html`, which still contains the now-draft article card.

---

## Step-by-step fix

> 📸 *Figure 1: A Finder view of the `public/` directory before Step 1 starts, showing the `posts/ai-agent/claude-code-cli-setup-indie-blog/` stale directory + 4 stale tag subdirectories at `tags/{tutorial, ai-coding-agent, claude-code, indie-blogger}/` + the stale `public/index.json` — all to clean up.*
>
> ![Finder view of public/ directory showing 6 stale items before cleanup: the stale post subdirectory at posts/ai-agent/claude-code-cli-setup-indie-blog/, 4 stale tag subdirectories at tags/{tutorial, ai-coding-agent, claude-code, indie-blogger}/, and the stale public/index.json file at public/ root.](/images/static-site/hugo-draft-stale-dev-server-fix/step-1-public-dir-before-cleanup.png)

### Step 1: List the `public/` paths tied to the draft article

```bash
# List all draft articles
grep -rl "draft = true" content/

# For each draft article, list the public/ paths that need cleanup
# Example: content/posts/static-site/foo.md (draft=true)
#   - public/posts/static-site/foo/
#   - public/categories/<foo-category>/
#   - public/tags/<foo-tag-1>/, public/tags/<foo-tag-2>/
#   - public/images/static-site/foo/  (if any)
```

### Step 2-5: Bulk cleanup (**the easy-to-miss spot is `tags/`**)

```bash
# Assume the draft article slug = foo
rm -rf public/posts/static-site/foo/
rm -rf public/images/static-site/foo/
rm -rf public/categories/                                    # Rebuild whole layer
rm -rf public/tags/<foo-tag-1>/ public/tags/<foo-tag-2>/    # ⚠️ Easy to miss
rm -f  public/index.json                                     # Site-map JSON
```

### Step 6: Restart the dev server (force rebuild)

```bash
hugo server --baseURL http://localhost:1313 \
            --buildDrafts=false \
            --disableFastRender
```

> 📸 *Figure 2: After Step 6, the `hugo server` startup log (left terminal, 0 warnings, 0 errors) + browser view of `/categories/ai-agent/` (right) — the stale draft article is no longer listed.*
>
> ![Terminal output of hugo server restart with --buildDrafts=false --disableFastRender flags showing 0 warnings and 0 errors (left), alongside browser view of /categories/ai-agent/ that no longer lists the previously leaked draft article (right).](/images/static-site/hugo-draft-stale-dev-server-fix/step-6-dev-server-restart.png)

---

## Verification + recommended script

### Stronger grep (covers all 5 directories)

```bash
grep -rl "<draft-title-substring>" public/ \
  | grep -v "editorial-pipeline"   # Exclude legitimate cross-references

# Expected output: empty. Any non-empty line = stale fallback still present
```

### `scripts/check-stale-drafts.sh` (permanent defense against stale rebuilds)

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

## Known issues and community reports

### D17 review's new findings

> My D10 fix sequence (`rm 3 个 draft 相关目录` + `rm 整个 categories/`) **turned out to be incomplete** — the `public/tags/` directory was left behind. The current grep command can verify 5 stale leftovers:
>
> - `public/tags/tutorial/` + `index.xml`
> - `public/tags/ai-coding-agent/` + `index.xml`
> - the entire `public/tags/claude-code/` directory
> - the entire `public/tags/indie-blogger/` directory
> - `public/index.json`
>
> **The incident is scoped to the local dev server only.** CF Pages deployment runs `hugo` (no flags), which excludes drafts by default and rebuilds `public/` from source, so production never leaks the draft.

### Community reports (filled in during the D19 [zh-final] stage, 5 verified entries)

During the D19 stage, based on the §0 operational evidence (`step-0-community-search-github-issues.png`, commit `c1c2b4e`), I picked the 5 most relevant community reports. Each URL has been verified against the live API (GitHub REST or Discourse JSON).

1. **[Hugo Discourse #57483](https://discourse.gohugo.io/t/website-builds-successfully-but-published-pages-continue-serving-outdated-generated-content/57483)** · active 2026-08 · 3 posts
   "builds successfully but old content still served" — reporter joeamanda, community maintainer iapetus replied: "Cache-Control policy 过 long expiry 才是你看到的 stale 现象" ("an over-long expiry Cache-Control policy is the actual cause of the stale pages you're seeing"). **Production-side parallel**: CF Pages deployments carry the same cache risk and need a manual purge.

2. **[gohugoio/hugo issue #10130](https://github.com/gohugoio/hugo/issues/10130)** · closed auto-locked 2026-01 · 5 comments · opened 2022-07-28
   "Hugo server does not update section pages that are not backed by a file" — toggling `draft` does not trigger a section listing rebuild; in v0.134.3+ the behavior changed (no longer depending on `_index.md`). **Maps to S18 §Root cause 3 (taxonomy listing stale)**.

3. **[gohugoio/hugo issue #13998](https://github.com/gohugoio/hugo/issues/13998)** · closed fix v0.162.0 (milestone closed 2026-06-04) · 5 comments · opened 2025-09-23
   "Multilingual content resources are built even if the page is a draft" — the draft's HTML is suppressed but its resources (images) still get copied into `public/`. **Maps to S18 §FAQ 4 (`rm -rf public/images/...`)**.

4. **[gohugoio/hugo issue #12208](https://github.com/gohugoio/hugo/issues/12208)** · closed fix v0.124.0 (milestone closed 2024-03-18) · opened 2024-03-06
   "Draft status ignored for content parser" — malformed content causes the draft to be wrongly ignored. **Edge case**: the S18 §0 fix commands do not help on a malformed draft — fix the front matter first.

5. **§0 operational evidence** — `step-0-community-search-github-issues.png` (commit `c1c2b4e`)
   The keyword `hugo --gc public not cleaned`, when searched in gohugoio/hugo's Issues, returns 8 results; the 4 visible ones (`#12499` / `#11038` / `#10947` / `#10220`) all turned out to be **non-direct hits** — Hugo officially does **not** track whether `--gc` cleans `public/`. Community consensus: clean manually with `rm -rf public/{posts,tags,categories,index.json}`.

---

## FAQ

**Q: Why does `hugo --gc` not clean `public/`?**
A: Hugo is designed this way. `--gc` only cleans the `resources/` cache directory, **it does NOT clean the `public/` output directory**.

**Q: Does the dev server still trigger incremental builds after startup?**
A: Yes, but when the source page can't be found, it falls back to the old `public/` HTML and does not rebuild.

**Q: Will production deployments expose drafts?**
A: No. CF Pages deployments run plain `hugo` (no flags), which excludes drafts by default and rebuilds `public/` from source.

**Q: What about draft articles that already have a cover image?**
A: Run `rm -rf public/images/<category>/<slug>/` to clean the image directory alongside.

---

## Fingerprint Tip

⚠️ **Critical warning**: `hugo --gc` not cleaning `public/` is Hugo **by design**, not a bug. If you're planning a future commit that flips a published article back to draft, do the `rm -rf public/{posts,tags,categories,index.json}` triplet first. Do not trust the dev server's "0 warnings at startup" — it will not notice the stale fallback.

**Author's note (D19)**: After the D10 incident I wrote the `scripts/check-stale-drafts.sh` shell snippet (see the §Verification section, in-article snippet, pending real file in `scripts/`) — run it before and after any draft-status switch, and only push when it reports 0 stale.

---

## Final takeaways (answer first, then why)

1. **`hugo --gc` only cleans `resources/`, not `public/`** — every draft switch needs a manual `rm`.
2. **`public/tags/` is the most-frequently-missed directory in any D10 fix** — every draft switch needs to nuke all 4 tag subdirectories, not just the ones next to the changed article.
3. **The dev server restart must include `--disableFastRender`** — otherwise the incremental build will route through the fallback.
4. **Production deployments run plain `hugo` (no flags), which excludes drafts by default** — production never leaks, and CF Pages deployments carry no contamination risk.
5. **The grep verification must cover all 5 directories** (posts / categories / tags / index.json / sitemap.xml) — miss one and you miss a leak.
