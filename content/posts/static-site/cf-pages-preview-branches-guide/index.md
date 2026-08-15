+++
title = "Cloudflare Pages Preview Branches: Zero-Downtime Blog Workflow with GitHub Actions"
description = "Set up Cloudflare Pages Preview Branches with GitHub Actions for instant per-branch previews. Real traps from a 3-day CI/CD debugging marathon."
date = 2026-08-15T22:00:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "GitHub Actions", "CI/CD", "Preview Deploys"]
categories = ["Static-Site"]
showToc = true
TocOpen = true
cover.image = "cover.jpg"
cover.alt = "Terminal showing CI/CD build pipeline and htop process monitoring on a dark background"
+++

## Why Preview URLs Matter for Solo Bloggers

If you maintain a static blog alone, you have probably hit this loop at least once: edit a draft post, push to `main`, watch the production deploy, notice a typo in the rendered HTML, fix it, push again, repeat. Each cycle burns five minutes of waiting for a Cloudflare Pages build to finish. When you are trying to compare three different table layouts for a Money Page, that is twenty minutes wasted per iteration.

What changed my workflow was switching to **Preview Branches** — a Cloudflare Pages feature that automatically deploys every non-production branch to its own isolated URL, prefixed with the branch name. Combined with a small GitHub Actions orchestrator, every draft post gets a clickable preview link the moment I push a feature branch, and production only updates after I merge to `main`.

This post walks through the exact setup, the YAML I use, and three traps I hit on the way — including a build-cache leak that briefly served a half-baked draft to my live site.

## The "Push to Main" Anti-Pattern

For my first two weeks of running heimaeden.com, my workflow was embarrassingly naive: write the post, commit directly to `main`, push, watch the deploy, refresh the browser, find the broken table, fix it, commit, push again. I treated `main` like a personal scratch branch.

The incident that forced me to fix this was a three-line CSS change that I thought was scoped to one post. I pushed it. Two hours later a reader DM'd me saying the navigation menu had shifted 14 pixels to the right across the whole site. The CSS selector I had used was not as scoped as I believed, and the production deploy had faithfully shipped my mistake.

The fix was not "be more careful." The fix was to make it impossible for an unverified change to touch production in the first place.

## What Cloudflare Pages Preview Branches Actually Do

Once enabled in your Cloudflare Pages dashboard, every branch that does not match your production branch name automatically gets:

1. **An isolated build** — Hugo runs in a fresh container against that branch's tree
2. **A unique preview URL** — `https://<hash>.<project-name>.pages.dev` for production, `https://<branch>.<project-name>.pages.dev` for non-production
3. **A dedicated GitHub commit status check** — green when the build passes, red when it fails, surfaced on the PR
4. **Automatic teardown** — when you delete the branch, the preview URL stops serving within a few minutes

You can either let Cloudflare Pages do this entirely on its own (it watches the connected GitHub repo) or layer a GitHub Actions workflow on top to control exactly which branches get built and to inject custom environment variables per branch.

I use the second approach because I want different `HUGO_ENV` values for production vs preview, and I want a few extra gates before any branch hits the Pages build pipeline.

## Step 1: Enable Preview Branches in the Dashboard

Open Cloudflare Dashboard, go to **Workers & Pages**, click into your Pages project, then **Settings → Builds**. You are looking for three controls:

- **Production branch name** — leave as `main`. Do not change this.
- **Preview branch inclusion** — leave at the default `All branches`. If you switch this to "Only specific branches" you will forget to whitelist a branch six months from now and silently lose previews.
- **Preview branch exclusion** — add nothing here yet, but know that you can blacklist `dependabot/*` or `renovate/*` if their noisy PRs start spamming your build quota.

That is the entire dashboard setup. The rest of the work happens in your repository.

## Step 2: Wire Up GitHub Actions for Branch-Aware Builds

Cloudflare's own documentation tells you to stop here and let the integration handle everything. I add a thin GitHub Actions layer for two reasons: I want to fail fast on lint errors before wasting a Cloudflare build cycle, and I want to set `HUGO_ENV=preview` for non-production branches so my PaperMod config can render draft-only widgets during preview.

Here is the workflow file I use, committed at the repo root as `.github/workflows/preview-deploy.yml`:

```yaml
name: Preview Deploy

on:
  push:
    branches-ignore: [main]
  pull_request:
    branches: [main]

concurrency:
  group: preview-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.164.0'
          extended: true

      - name: Lint front matter
        run: |
          for f in content/posts/*/*.md; do
            head -1 "$f" | grep -q '^+++' || {
              echo "FAIL: $f missing TOML front matter"
              exit 1
            }
          done

      - name: Build (preview env)
        if: github.ref != 'refs/heads/main'
        env:
          HUGO_ENV: preview
        run: hugo --buildDrafts --buildFuture --gc

      - name: Build (production env)
        if: github.ref == 'refs/heads/main'
        run: hugo --gc

      - name: Comment preview URL
        if: github.event_name == 'pull_request'
        uses: marocchino/sticky-pull-request-comment@v2
        with:
          header: cf-pages-preview
          message: |
            Preview URL: https://${{ github.head_ref }}.heimaeden-blog.pages.dev
            Note: this URL is publicly accessible. Do not link to it from external places until merged.
```

A few things worth highlighting:

- `concurrency` cancels in-flight builds when you push a new commit on the same branch. Without this, three rapid pushes generate three sequential five-minute builds.
- `branches-ignore: [main]` plus `pull_request: branches: [main]` means production builds skip this workflow entirely — Cloudflare Pages' built-in integration handles `main` directly.
- The `Lint front matter` step is a 30-second regex that catches the most common authoring mistake. It is not a full linter — for that I would reach for `lychee` or `markdownlint-cli2` — but it stops the obvious typos.

## Trap 1: Hugo's Build Cache Bleeding Across Branches

My first Preview Branch deploy looked perfect. The second deploy, on a different branch, served a post from the first branch in the post list. Stale content from a different feature branch had leaked into the new build's HTML output.

The cause: Hugo keeps a `resources/` cache directory between builds. When the GitHub Actions runner does not get cleaned between jobs, the cache from build N is read by build N+1. The `--gc` flag (which I had added based on advice from a Stack Overflow thread) only garbage-collects the cache during the build itself, not between jobs.

The fix is one line in the workflow:

```yaml
      - name: Build (preview env)
        run: hugo --buildDrafts --gc --cleanDestinationDir
```

`--cleanDestinationDir` wipes the output directory before each build, and the `actions/checkout@v4` step implicitly clears `resources/` between runs. If you are using a self-hosted runner with persistent cache, you also need to manually delete `resources/_gen` at the start of each job — the build cache lives there and persists across runs.

After that one-line change, I have not seen a single cross-branch leak in six weeks.

## Trap 2: HUGO_VERSION Race Condition

This one only bit me once, but it cost me an entire evening. Cloudflare Pages' default Hugo version is, at the time of writing, 0.111.3. Hugo 0.150+ deprecates the top-level `minify` config and several `.Language.LanguageDirection` references inside the PaperMod theme. If your GitHub Actions workflow builds with `hugo-version: '0.164.0'` but Cloudflare Pages still builds `main` with 0.111.3, your preview succeeds and your production deploy silently produces different HTML.

Two fixes, do both:

1. In Cloudflare Pages **Settings → Environment variables**, set `HUGO_VERSION` to `0.164.0` for production. This forces the CF Pages build to match your Actions build.
2. Pin the version inside `config.toml` using `module.hugoVersion` so that an accidental environment-variable deletion still gets caught at parse time:

```toml
[module]
  [module.hugoVersion]
    extended = true
    min = "0.164.0"
```

If a future contributor installs a different Hugo version, the build refuses to start with a clear error instead of producing subtly different output.

## Trap 3: Public Preview URLs Leak Drafts

Cloudflare Pages preview URLs are **public** by default. Anyone with the link can view your unpublished content. For an early-stage blog where I am the only author, this is fine — drafts contain personal research notes, not customer-sensitive data. For a team blog or a blog where drafts include paid content, this is a problem.

If you fall into the second camp, the cleanest fix is Cloudflare Access:

1. Cloudflare Dashboard → **Access → Applications**
2. Add an application, type **Self-hosted**
3. Application domain: `<your-pages-subdomain>.pages.dev`
4. Path: `/*`
5. Policy: require a specific email address or a one-time PIN

This adds a login page in front of every preview URL. The setup takes ten minutes and survives preview teardowns automatically.

For my solo blog, I instead use a second tactic: I name preview branches with a non-guessable prefix so the URL itself is hard to discover. Branch names like `post/2026-08-15-payment-flow` end up at `post-2026-08-15-payment-flow.heimaeden-blog.pages.dev`, which is findable via search engines but not brute-forceable. Combined with `noindex` meta tags on drafts, this has been enough.

## Pre-Merge Checklist

Before I merge a feature branch into `main`, I run through this short list:

- [ ] Preview URL opens and matches the expected draft
- [ ] All internal links resolve (no 404s in the rendered page)
- [ ] Cover image renders at the correct size (Page Bundle images sometimes revert to the page-level image if the path is wrong)
- [ ] Mobile viewport tested — PaperMod's TOC floats right on desktop but stacks on mobile, which can hide the navigation
- [ ] GSC preview commit status is green (Cloudflare Pages pushes a `cloudflare-pages` status check to the PR)
- [ ] Branch is rebased on current `main` to avoid merge-conflict surprise

The list looks tedious, but each item catches a real bug at least once a month.

## Closing Notes

The whole workflow — Preview Branches, GitHub Actions, lint step, environment pinning — adds maybe 200 lines of YAML to the repo and saves me roughly an hour per week of deploy-watching. More importantly, it makes me willing to experiment with the site layout, because every experiment lives on a branch with its own URL until I decide to ship it.

If you only run a single-author static blog, the Cloudflare Pages built-in Preview Branches toggle is the only piece you actually need. The GitHub Actions layer is worth adding once you have at least three posts in flight at once and find yourself losing track of which preview URL corresponds to which draft.

Sources:
- [Unsplash cover image](https://unsplash.com/photos/a-computer-screen-with-a-lot-of-text-on-it-IxTyLj7d4aa)