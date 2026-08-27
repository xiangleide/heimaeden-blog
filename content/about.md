+++
title = "About"
date = 2026-08-14T20:00:00Z
lastmod = 2026-08-25T22:00:00Z
draft = false
layout = "single"
hidemeta = true
showToc = false

# Per-file exemption (grandfather clause per CLAUDE.md §3.2):
# about.md references docs/archive/运营方案与交叉验证文档-2026-08-27.md (literal CJK filename).
# Other 2 lines of CJK are minimal cross-references (状态校准 + 交叉验证落地决策) to that doc.
# Future about.md rewrites should still avoid new CJK body text where possible.
lint_allow = ["cjk-body"]
+++

Hi — I'm the person behind HeimaEden.

I'm a developer based in China with **6 years of day-to-day Java backend work**. I'm not a framework author or a tech celebrity — I'm a working developer who spends most of my time on CRUD services, deployment pipelines, and figuring out which tool actually fits the job.

This blog documents the practical things I learn along the way:

- **Tools and setups** — what I tried, what worked, what didn't
- **Deployments and infrastructure** — mostly Cloudflare, Hetzner, and other indie-dev-friendly stacks
- **Cross-border payments** — receiving USD as a Chinese developer (AdSense, affiliate programs, Wise, WorldFirst)
- **Side projects and small SaaS** — experiments with AI coding tools and indie hacking

Most posts are written **after I actually run into the problem myself**, so you'll find real screenshots, real error logs, and honest "this didn't work" notes — not polished marketing copy.

If you spot an inaccuracy, or want to suggest a topic I should try next, drop me a line using the email at the bottom of the page.

---

## Build in Public

I track everything — every commit, every revert, every mock-reader report — in the open. If you want to verify that a real human is writing this blog (not an AI content farm), the commit log is the proof.

**Open artifacts**:

- **Source repo** (this blog, full commit history): [github.com/xiangleide/heimaeden-blog](https://github.com/xiangleide/heimaeden-blog)
- **Published site**: [heimaeden.com](https://heimaeden.com)

**What you'll find in the commit log**:

- Real work-in-progress commits (`[draft]` tags) you can see I didn't fake the final article from a polished draft
- Reverted commits (e.g. `bc9a369` reverted `4b8a8ea` after I caught AI fabricating first-person experience) — yes, mistakes are visible
- Build artifacts (cover images, screenshots, SOP docs) — the same files the site is built from, not post-hoc edited

**Project timeline** (D-day count from domain registration):

| Date | Day | Milestone |
|---|---|---|
| 2026-08-11 | D0 | Domain registered, Hugo repo initialized |
| 2026-08-13 | D2 | First English long-form post published |
| 2026-08-14 | D3 | About page v1 (this page, before build-in-public) |
| 2026-08-15 | D4 | First revert caught — added §3.8 SOP to prevent AI first-person fabrication |
| 2026-08-16 | D5 | Second cross-reference incident caught — added §3.8 rule 6 (no phantom cross-refs) |
| 2026-08-21 | D10 | Draft exposure incident — added 状态校准 to README §6 |
| 2026-08-24 | D11 | X1 retrospective article "How I Cut My Solo Tech Blog Pipeline from 6 Hours to 2 Hours Per Post in 11 Days" published |
| 2026-08-25 | D12 | Multi-AI cross-verification of operating plan — 4 decisions landed (GEO pilot / Hugo error hub / automation timing / this page upgrade) |

As of D12: **96 commits** in the main branch, **6 English long-form articles** published (X1 + 4 existing + 1 SOP-doc-driven), **0 paid placements** (every affiliate mention is a tool I personally use).

---

## What this blog is NOT

To save your time, here's what I won't write:

- **Generic "best X for Y" listicles** — too easy to AI-generate, too hard to keep honest
- **Tutorial rehashes of official docs** — I link to the official doc instead
- **Clickbait headlines** — no "I made $X in Y days", no "you won't believe"
- **Affiliate-first reviews** — every product mentioned is something I actually deploy or pay for; the link comes second, the experience comes first

If a post has an affiliate link, you'll see `(affiliate link)` immediately after it — per FTC proximity disclosure. Most posts don't need any.

---

## Stack behind this site (for the curious)

- **Static generator**: Hugo v0.164.0+extended
- **Theme**: PaperMod (with custom geek-green overrides)
- **Hosting**: Cloudflare Pages (free tier)
- **Domain**: heimaeden.com (registered via Namecheap)
- **Images**: Hugo asset pipeline → WebP via `layouts/_markup/render-image.html`
- **PII redaction**: local Python/Pillow script before every commit
- **Translations**: human-written first → AI-assisted English pass

No analytics beyond Cloudflare's built-in (no Google Analytics, no Plausible, no Fathom yet — V2 plan).

---

## Get in touch

📩 **Email**: [heimaeden@proton.me](mailto:heimaeden@proton.me) — for topic suggestions, factual corrections, or just to say the post helped you debug the same thing

🐙 **GitHub**: [github.com/xiangleide](https://github.com/xiangleide) — issues / PRs / public commit history

If you spot an inaccuracy in any post, the fastest fix is a GitHub Issue linking the post + the offending sentence. I'll patch it within a week.

---

*Last reviewed: 2026-08-25 (D12) — D2 build-in-public upgrade landed alongside GEO pilot (B2 P1 WorldFirst) per `docs/archive/运营方案与交叉验证文档-2026-08-27.md` §「📅 交叉验证落地决策」.*