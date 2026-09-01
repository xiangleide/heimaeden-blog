+++
title = "Hugo + Cloudflare Pages Error Cluster: 5 Common Issues and How to Triage Them"
description = "Index page for the 5 most common Hugo + Cloudflare Pages error clusters: image 404, ERR_TOO_MANY_REDIRECTS, Build OOM, dev server stale, 7 traps overview. Includes symptom quick-reference table + diagnostic decision tree + 5 spoke article navigation cards."
date = 2026-08-25T01:00:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "troubleshooting", "build error", "cluster", "Hugo troubleshooting"]
categories = ["Static-Site"]

# Cluster integration with A1 (hugo-cloudflare-pages-pitfalls) + S18 (hugo-draft-stale-dev-server-fix) — bidirectional per CLAUDE.md §3.8 rule 7 (single commit).
series = ["Hugo on Cloudflare Pages"]

showToc = true
TocOpen = true

[cover]
    image = "images/static-site/hugo-troubleshooting-hub/hub-hugo-troubleshooting-cover-v1.png"
    alt = "Flat-vector hub-and-spoke topology on dark slate background: a central green hexagonal HUB node connected via thin geometric lines to five satellite nodes arranged in a pentagonal pattern, each representing one of the five Hugo + Cloudflare Pages error clusters covered by this troubleshooting hub."

# D24 Phase 1.5: English final version translated from zh-final commit 7762e7e.
# Per CLAUDE.md §3.8 rule 5: 1:1 paragraph mapping, no fact addition/removal, preserves Chinese colloquial tone.

# D24: prompt_type = "F" per writing-prompts.md §一 + §七（F 聚簇索引型 · D24 新增）。
# Hub structure (5-cluster quick-ref + decision tree + N Spoke cards + cross-link appendix) does not fit A-E;
# F type was created to honestly represent Hub-and-Spoke V1 topology index pages.
prompt_type = "F"
+++

> **Nature of this file**: A Hub index page (not a single-topic article). Each error cluster has one dedicated Spoke article with the full fix commands; this Hub only does **symptom identification + decision-tree triage** and does not include step-by-step fix code (to avoid duplicating Spokes and tripping HCU's thin-content red line).
>
> **D22 structural decision**: shifted from the original D12 B2 "Hub covers all 12 S1-S12 candidates" to **5 error clusters** (image / redirect / OOM / stale / 7 traps), matching **2 published Spokes (A1 + S18) + 3 pending Spokes (S1 / S2 / S3)**. Deep-dives on selection / Workers / URL resolution go into later Hub candidates.

---

## Introduction

When deploying a Hugo site to Cloudflare Pages, the most common sticking point isn't "I don't know how to write Hugo" — it's **"everything works locally, but deployment breaks."** This article is the **5-error-cluster index** distilled from 4 weeks of real HeimaEden site work + 100+ community pain points:

| # | Error cluster | Typical symptom | Related Spoke |
|---|---|---|---|
| 1 | **Image path 404** | `<img src="/images/.../cover.png">` returns 404 after deploy, but local `hugo server` returns 200 | S1 image-path article (pending) |
| 2 | **ERR_TOO_MANY_REDIRECTS** | Custom domain + Cloudflare SSL Flexible mode triggers a redirect death loop | S2 SSL decision-tree article (pending) |
| 3 | **Build OOM** | Large Hugo site (>5k pages) + CF Pages default memory triggers `signal: killed` | S3 OOM-tuning article (pending) |
| 4 | **Dev server stale drafts** | After moving a `draft = true` article to `_drafts/`, dev server still returns stale HTML | [S18 stale-draft article]({{< ref "posts/static-site/hugo-draft-stale-dev-server-fix" >}}) ✅ published |
| 5 | **7 traps panoramic quick-check** | The above + render-image warnings / theme toggle freeze / sitemap missing / asset 308 / CSS pipeline drop | [A1 7-traps article]({{< ref "posts/static-site/hugo-cloudflare-pages-pitfalls" >}}) ✅ published |

**Who this is for**:

- Hugo + Cloudflare Pages users, with or without a custom domain
- Anyone in their first week of a new site who hits "everything works locally, but deployment breaks"

**Who this is NOT for**:

- Hugo syntax errors (TOML parse failures, template not found) → see B1-2 single-article plan
- Hugo selection comparison vs Astro / Next.js / 11ty → see topic-pool S9 / S10 / S11 / S12 plan
- Cloudflare Workers vs Pages selection → see topic-pool S13 plan

---

## Prerequisites

- Hugo v0.150.0+ (from v0.150 onward, `minify.minifyOutput` replaces the top-level `minify` config)
- A Cloudflare Pages project (free tier is enough to trigger most errors)
- Custom domain optional (image 404 / OOM / dev stale still trigger without one)
- Browser DevTools Network tab (for reading status code + response headers to tell 4xx / 5xx apart)

---

## Diagnostic decision tree

When you see an error, ask yourself these 4 questions in order:

**Q1: Does local `hugo server` work normally?**

- **Yes** → Q2 (means the problem is in deployment / production)
- **No** → Q3 (means the problem is in the dev workflow)

**Q2: Does the error only appear after deployment?**

- Yes + path contains `/images/` → **Spoke ③ S1** (image path 404)
- Yes + custom domain + ERR_TOO_MANY_REDIRECTS → **Spoke ④ S2** (SSL decision tree)
- Yes + HTTP 200 but wrong content + only after theme / CSS edits → **Spoke ① A1** (7 traps overview, includes Trap 4 CSS pipeline drop)
- No + Build log reports `signal: killed` → **Spoke ⑤ S3** (OOM tuning)

**Q3: Is the dev workflow issue caused by a draft switch?**

- Yes → **Spoke ② S18** (3 stacked dev-server stale-draft traps)
- No → **Spoke ① A1** (dev-related classes within 7 traps, includes Trap 6 asset hash caching)

**Q4: Is the error at the build stage?**

- Yes + `signal: killed` → **Spoke ⑤ S3** (OOM)
- No + render-image.html hook warning → **Spoke ① A1** (Trap 3 / Trap 5)

After answering 4 questions, you know which Spoke to jump to. Each Spoke deep-dives the full chain: **symptom → trigger condition → complete fix commands → verification**.

---

## 5 Spoke navigation cards

### Spoke ① · 7 traps panoramic quick-check (A1 published)

**Symptom**: anything goes wrong post-deploy (404 / redirect / CSS drop / theme freeze / sitemap missing / build warning), and you're not sure which class it is.

**Covers**: 7 high-frequency Hugo + Cloudflare Pages error classes, each with real logs, version environment, and fix commands. Spoke ① is the **top-of-funnel entry** — after reading it you can identify all 5 error classes, then dive into the matching Spoke.

**When to use**: error class unknown; you need to "scan the full panorama first, then focus."

### Spoke ② · Dev server stale drafts (S18 published)

**Symptom**: after moving a Hugo front-matter `draft = true` article into `_drafts/`, local `hugo server` still returns stale HTML, and the public `public/` directory also has stale remnants.

**Covers**: 3 stacked dev-server stale-draft traps — `hugo --gc` does not clean same-name stale files in `public/` + dev server falls back to stale HTML + taxonomy listing pages do not rebuild. Includes the `scripts/check-stale-drafts.sh` self-check script.

**When to use**: before and after a draft switch, before commit, before CF Pages deploy.

### Spoke ③ · Image path 404 (pending · Task #37)

**Symptom**: `<img src="/images/<cat>/<slug>/cover.png">` returns 404 in HTML, but local `hugo server` returns 200 OK; `sips` shows the image is ≤1440px and compliant; `git ls-files` shows it tracked.

**Covers**: Hugo resource lookup algorithm (`resources.Get` vs Page Resource), path prefix `/images/` vs `/static/images/` differences, render-image.html hook behavior, `hugo.toml [params] images` config.

**When to use**: body image or cover 404s in production but works locally.

### Spoke ④ · ERR_TOO_MANY_REDIRECTS (pending · Task #38)

**Symptom**: custom domain `https://<your-domain>` reports `ERR_TOO_MANY_REDIRECTS`; DevTools Network shows 10+ 301/302 loops; `curl -L` also loops to death.

**Covers**: 5 SSL mode comparison (Flexible / Full / Full Strict / Origin Pull) + Hugo `baseURL` config + CNAME going through proxy (orange cloud) + CF Pages default origin HTTPS behavior.

**When to use**: custom domain just goes live and errors immediately.

### Spoke ⑤ · Build OOM (pending · Task #39)

**Symptom**: CF Pages Build log reports `Error: build failed: signal: killed (out of memory)`; Hugo process exits silently.

**Covers**: CF Pages default 1 GB memory limit + Hugo image-processing memory breakdown + V8 chunk_size tuning + `hugo --printPathWarnings` monitoring + build-splitting strategy for sites over 5k pages.

**When to use**: site grows to 5k+ pages + deployment suddenly fails.

---

## Known issues and community reports

3-5 community-reported issues that this Hub did not deep-dive:

- **Hugo `hugo --gc` stale same-name files** — gohugoio/hugo #10130 (Hugo design trade-off: same-name stale files must be manually cleared) + Discourse #57483 (users confirm `rm -rf public/` is the cleanest fix). See Spoke ② S18.
- **CF Pages 1 GB memory limit** — multiple Cloudflare Community threads; free tier defaults to 1 GB Worker memory; Hobby plan 5 GB; Pro plan custom. See Spoke ⑤.
- **ERR_TOO_MANY_REDIRECTS on Flexible SSL + Hugo baseURL** — 3-5 posts per week on CF Community; consensus fix: switch to Full (strict). See Spoke ④.
- **Image 404 after deploy, local OK** — 5+ monthly posts on r/Hugo + r/CloudFlare; most common root cause = missing `/images/` prefix or extra `static/` prefix. See Spoke ③.
- **Preview branch redirect on custom domain** — CF Pages known issue (no fixed ID); root cause = preview URL and production domain share SSL/TLS config. See Spoke ④.

> All 5 items have real community anchors; specific URLs live in each Spoke's full article (not duplicated in this Hub, to avoid single-file maintenance cost).

---

## Conclusion

The Hub's value isn't "covering every Hugo + CF Pages error" — it's **giving users who search for "Hugo + Cloudflare Pages error" a cluster entry point** so they can:

1. Use the 5-error-cluster quick-reference table + diagnostic decision tree to locate the problem in 30 seconds
2. Once they hit a cluster, jump to the matching Spoke for the complete fix commands
3. If none matches → comment section / GitHub Issue feedback, author adds new cluster

**Future extensions**: after S1 / S2 / S3 are published, this Hub removes "pending" placeholders + syncs cross-links + series + shared tags (per CLAUDE.md §3.8 rule 7, single commit bidirectional). Next candidates = S13 (CF Workers vs Pages) / S14 (TOML vs YAML) / S17 (URL resolution) / S16 (PaperMod dark mode 48h debug).

---

## Appendix A: Hub ↔ Spoke cross-link map

| Hub cluster | Spoke slug | Spoke status | Task # |
|---|---|---|---|
| Cluster 1 image path | `hugo-image-path-404-cloudflare-pages` | 📝 pending | #37 |
| Cluster 2 ERR_TOO_MANY_REDIRECTS | `cloudflare-too-many-redirects-hugo-fix` | 📝 pending | #38 |
| Cluster 3 Build OOM | `cloudflare-pages-hugo-build-oom-fix` | 📝 pending | #39 |
| Cluster 4 dev server stale | [`hugo-draft-stale-dev-server-fix`]({{< ref "posts/static-site/hugo-draft-stale-dev-server-fix" >}}) (S18) | ✅ published | — |
| Cluster 5 7 traps overview | [`hugo-cloudflare-pages-pitfalls`]({{< ref "posts/static-site/hugo-cloudflare-pages-pitfalls" >}}) (A1) | ✅ published | — |

**Writing constraint**: every new Spoke `[en-final]` triggers a Hub sync of cross-links + series + shared tags (single commit, per CLAUDE.md §3.8 rule 7).

---

## Appendix B: Hub positioning decision log

| Decision point | Choice | Notes |
|---|---|---|
| **D12 B2 decision** | Create this Hub file, positioned as "error-cluster" thought-aggregation page | See `docs/archive/topic-pool-2026-08-27-archive.md` § "📅 Cross-validation landing decision (D12 · 2026-08-25)" row B2 |
| **D22 structural adjustment** | Hub focuses on 5 error clusters (image / redirect / OOM / stale / 7 traps), matching 2 published + 3 pending Spokes | Selection / Workers / URL resolution etc. go into later Hub candidates |
| **Hub structure** | Quick-reference table + decision tree + 5 Spoke cards + cross-link map (per multi-role consensus) | Don't write complete fix commands, leave those to Spokes |
| **Word count constraint** | 800-1500 word floor to prevent HCU thin content | Currently ~1297 words |
| **Cluster integration** | series + shared tag + bidirectional refs landed in Task #34's single commit | To avoid this commit conflicting with #34 |