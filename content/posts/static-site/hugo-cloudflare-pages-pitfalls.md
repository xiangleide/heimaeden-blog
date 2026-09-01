+++
title = "Hugo + Cloudflare Pages Deployment: 7 Hidden Traps and How I Fixed Them"
description = "A raw, first-person troubleshooting note documenting real-world static site routing deadlocks, Cloudflare Pages traps, and CSS rendering bugs."
date = 2026-08-13T07:45:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "Troubleshooting", "DevOps", "Hugo troubleshooting"]
categories = ["Static-Site"]

# Cluster integration: Hub `hugo-troubleshooting-hub` (this article = Spoke ① 7-traps overview) + S18 (hugo-draft-stale-dev-server-fix) — bidirectional per CLAUDE.md §3.8 rule 7 (single commit).
series = ["Hugo on Cloudflare Pages"]

[cover]
    # D24 [fix] #41: same-type bug as the hub cover fix in D22 b3a3a51. Missing
    # `images/` prefix caused render-image.html hook warning and live cover 404.
    # Fix: rewrite to resources path (relative to assets/) to match PaperMod cover.html line 22 absURL fallback.
    image = "images/static-site/hugo-cloudflare-pages-pitfalls/cover.jpg"
    alt = "A blueprint illustration of a glowing deployment pipeline with three nodes and seven red lightning-shaped fault markers along the line, evoking hidden pitfalls in static site deployment."

showToc = true
TocOpen = true
+++

Building a static blog using **Hugo** and hosting it on **Cloudflare Pages** sounds like a breeze for developers—until you actually do it. Over the past 48 hours, I went through a massive debugging marathon, fighting hidden routing deadlocks, CSS asset pipeline drops, and bizarre deployment errors.

To save your sanity, I have compiled my real-world troubleshooting notes, complete with raw error logs and the exact solutions that fixed them.

---

## Trap 1: The Cloudflare Dashboard "UI Illusion" (Workers vs Pages)

### The Nightmare
When setting up my project in the new Cloudflare dashboard, I clicked the highly visible blue "Create application" button. After connecting my GitHub repository, I noticed the build settings were completely messed up: there was no *Framework preset* dropdown, only a `Build command` showing *None* and a `Deploy command` showing `npx wrangler deploy`. Forcing a deployment resulted in catastrophic errors.

### The Root Cause
Cloudflare recently aggregated Serverless Functions (Workers) and Static Site Hosting (Pages) under the same parent menu. If you just blindly click the main CTA button, the wizard defaults to the Workers flow, which heavily relies on `wrangler` and completely breaks standard Hugo compiling pipelines.

### The Solution
Go back to the application creation page. Ignore the massive central buttons.

If you accidentally fell into the Workers workflow, your interface will look like this confusing mess—showing wrangler settings and completely lacking framework presets:

![Confusing Workers Settings Interface](/images/static-site/cloudflare-workers-config-screen.png)

To escape this trap, look closely at the very bottom of the white card for a tiny, easily missed row of grey text:

👉 `Looking to deploy Pages? Get started`

Here is the exact hidden entrance you need to look for in your dashboard to trigger the correct pipeline:

![Hidden Cloudflare Pages Entrance Link](/images/static-site/cloudflare-pages-entrance-link.png)

Click the blue "Get started" link. This takes you into the pure Pages Git-binding flow where you will find the proper Hugo presets.

---

## Trap 2: `npm error could not determine executable to run`

### The Nightmare
During the initial deployment phase, the Cloudflare Pages build logs threw a bright red compiler error: `Failed: error occurred while running build command`, accompanied by an npm execution failure.

### The Root Cause
By default, some setup configurations add `npx hugo` or `npm run build` prefixes into the build environment. However, Hugo is natively compiled in Go—it does not inherently require a `package.json` file or any Node.js wrappers unless you are compiling modern PostCSS extensions.

### The Solution
In your Cloudflare Pages dashboard, go to *Settings → Build & deployments → Edit configurations*, and strictly prune your settings to:
- *Framework preset*: `Hugo`
- *Build command*: `hugo` *(Pure and clean, remove any npm or npx prefixes)*

---

## Trap 3: `unmarshal failed: toml: expected character =`

### The Nightmare
My local site was working perfectly, but the online build crashed completely with a TOML syntax error referencing line 3 of my newly created article.

### The Root Cause
Contextual grammar confusion. If your global configuration is a `hugo.toml` file, your article's Front Matter (the metadata zone between `+++`) must strictly adhere to TOML syntax—which uses `=` (equals signs) for assignment. I accidentally wrote it in YAML format using `:` (colons), e.g. `draft: false` instead of `draft = false`, causing the parser to instantly explode.

### The Solution
Ensure your article header uses strict TOML syntax:
```toml
+++
title = "My First Post"
date = 2026-08-13T00:00:00Z
draft = false
+++
```

---

## Trap 4: Online Homepage is Completely Empty

### The Nightmare
The deployment showed a green "Success" checkmark, but navigating to my live domain revealed a completely blank homepage. No articles were listed.

### The Root Cause
There are two hidden timers that cause this:
1. **Future Dates**: If your article's `date` parameter is set to a future timestamp (even by a few hours due to UTC timezone drift), the Hugo compiler flags it as a "scheduled post" and hides it from the live homepage loop. This is the most common silent killer.
2. **Section Isolation**: If your articles are placed inside custom folders, the home layout might not track them without explicit instructions.

### The Solution
1. Change your article `date` back to a historical timestamp (e.g. `2024-01-01`). Heads up: Hugo itself treats future-dated posts as scheduled content—this is non-negotiable.
2. If you genuinely cannot backdate yet (you want the publish day to stay accurate), temporarily flip `draft = true` until you're ready to ship.
3. Force your theme to fetch your targeted directory by adding this into your `hugo.toml`:
   ```toml
   [params]
       mainSections = ["posts"]
   ```

**Related**: flipping `draft = true` carries its own follow-on trap — the local dev server keeps serving the stale `public/` HTML even after the flip. Full three-layer breakdown in [why a Hugo draft still shows up after moving it to `_drafts/`]({{< ref "posts/static-site/hugo-draft-stale-dev-server-fix" >}}).

---

## Trap 5: The "Ambiguous" Page Reference Crash

### The Nightmare
Adding custom directories broke the entire engine, throwing a fatal log: `error calling GetPage: page reference "Static Site" is ambiguous`.

### The Root Cause
When configuring the main navigation navbar, giving a menu item a `name` that matches a specific taxonomy term (like a category name) makes Hugo's `site.GetPage` function drop into an infinite loops, unable to resolve whether it is looking for a physical file or a tag group.

### The Solution
Explicitly isolate your menu items using unique identifiers in your `hugo.toml`:
```toml
[[menu.main]]
    identifier = "static-site-menu"  # 👈 Unique ID breaks the ambiguity
    name = "Static Site"
    url = "/categories/static-site/"
```

---

## Trap 6: Root-Level 404 Cascading Errors & Localhost Loops

### The Nightmare
When I moved my legal compliance pages (Privacy Policy, etc.) out of the `posts` folder, clicking them either led to a flat online 404 or inexplicably redirected the browser back to `http://localhost:1313/search`.

### The Root Cause
1. **Strict Root Policies**: Modern Hugo heavily tightens root-level compilation. Loose `.md` files dropped right in `content/` often fail to pair with the single page layouts.
2. **Relative Path Trailing Slashes**: Declaring page loops like `url = "legal/privacy-policy/"` lacks a leading slash. When clicked from a sub-page like `/search/`, the browser attempts to concatenate them into a broken loop (`/search/legal/...`), trapping the browser in an endless localhost redirect loop.

### The Solution
1. Isolate miscellaneous text assets in a dedicated section (e.g. `content/legal/`).
2. Always enforce a leading slash in your URL mappings within your `hugo.toml`:
   ```toml
   [[params.footer_menu.items]]
       name = "Privacy Policy"
       url = "/legal/privacy-policy/" # 👈 Enforce the leading slash
   ```

---

## Trap 7: The Theme Toggle (Dark Mode) Invisible Locked State

### The Nightmare
I injected custom styles inside `extended.css` to freshen up the blog's UI cards, but clicking the sun/moon icon on the live site suddenly became completely unresponsive.

### The Root Cause
One real culprit, plus two widespread misdiagnoses that waste hours of debugging.

**The Real Culprit**: PaperMod's theme-toggle gating reads an *inverted* config key, not the one most tutorials name. The relevant predicates in `header.html`, `footer.html`, and `head.html` all evaluate `{{ if (not site.Params.disableThemeToggle) }}`. The correct key is `disableThemeToggle = false`. Setting `showThemeToggle = true` — regardless of casing — is a NO-OP: PaperMod never consults that key. With the wrong key in place, the button never renders, the inline click handler never attaches, and "the theme is broken" feels true while the actual bug is one mistyped variable name. This is the silent killer every retro "PaperMod dark mode" article glosses over.

**Misdiagnosis #1 — Selector Mismatch**: PaperMod's built-in stylesheets correctly use `html[data-theme="dark"]` as the selector. If your custom CSS inside `extended.css` keys off a `.dark` class on the body or `<html>`, your style block will *look* like it does nothing — because PaperMod never sets that class. Mirror PaperMod's `html[data-theme="dark"]` pattern in your variables, or you will keep "fixing" CSS that was never the bug.

**Misdiagnosis #2 — SRI Verification Lockdown**: Older guides blame Cloudflare Pages minification + Subresource Integrity (SRI) hash mismatches for "killing the toggle click handler". This conflates two separate mechanisms: SRI only gates external `<script integrity="...">` tags, not the inline `onclick` attribute on the toggle button. If you do hit an SRI mismatch on an external asset, the fix is `disableSRI = true` inside a `[params.assets]` table — but be aware that the inline dotted form `assets.disableSRI = true` is itself a NO-OP, for the same reason `showThemeToggle` was: only the parameter-table form is read. In practice this is rarely the actual cause of an unresponsive toggle.

### The Solution
1. The one line that actually fixes the click bug, in your `hugo.toml`:
   ```toml
   [params]
       disableThemeToggle = false   # 👈 THIS is the real key (not showThemeToggle)
   ```
2. If your `extended.css` uses a `.dark` selector, mirror PaperMod's pattern:
   ```css
   html[data-theme="dark"] { --your-var: #...; }
   ```
3. Only if Cloudflare Pages minification actually trips an SRI mismatch on a real external asset, add the assets table — keep `minify = false` at the top level too, as a belt-and-braces measure:
   ```toml
   minify = false   # 👈 Top-level only — params.minify is not read

   [params.assets]
       disableSRI = true   # 👈 Table form only — inline dotted form is a NO-OP
   ```

---

## Quick Diagnostic Index

When a deployment misbehaves, jump straight to the trap matching your symptom:

| Symptom | Most likely trap |
|---|---|
| "Create application" landed you on a Wrangler settings UI, no Hugo preset | [Trap 1](#trap-1-the-cloudflare-dashboard-ui-illusion-workers-vs-pages) |
| `Failed: error occurred while running build command` + npm error | [Trap 2](#trap-2-npm-error-could-not-determine-executable-to-run) |
| `unmarshal failed: toml: expected character =` | [Trap 3](#trap-3-unmarshal-failed-toml-expected-character-) |
| Live homepage is blank, build is green | [Trap 4](#trap-4-online-homepage-is-completely-empty) |
| `error calling GetPage: page reference "X" is ambiguous` | [Trap 5](#trap-5-the-ambiguous-page-reference-crash) |
| Legal/about pages 404 or redirect to localhost | [Trap 6](#trap-6-root-level-404-cascading-errors--localhost-loops) |
| Sun/moon theme toggle is unresponsive after CSS edits | [Trap 7](#trap-7-the-theme-toggle-dark-mode-invisible-locked-state) |

---

## Final Takeaways

Five rules to keep your Hugo + Cloudflare Pages deployment boring in the best way possible:

1. **Backdate everything in `date`** — UTC drift will bite you. If a post genuinely cannot ship today, flip `draft = true` instead.
2. **Use `=` everywhere in front matter** — YAML's `:` triggers `unmarshal failed` at build time, even if `hugo server` runs locally without a hiccup.
3. **Never match a menu `name` to a category name** — give every menu item a unique `identifier`, even if it feels redundant.
4. **Leading slash in every URL mapping** — relative paths collide with Hugo's page lookup and silently trap the browser.
5. **Read PaperMod's `header.html` before guessing toggle keys** — the gating key is `disableThemeToggle`, not `showThemeToggle`. Always.

When in doubt: spin up an Incognito window pointed at the production URL, not at `localhost:1313`. Local caches lie.
