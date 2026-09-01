+++
title = "Zero-Cost Static Blog Deployment with Cloudflare Pages and Hugo"
description = "How to deploy a blazing-fast, secure, and completely free static tech blog using GitHub and Cloudflare's global edge network."
date = 2026-08-10T15:00:00Z
draft = false
tags = ["Hugo", "Cloudflare Pages", "Static Site"]
categories = ["Static-Site"]
# D24-B backfill: prompt_type per writing-prompts.md §一 + D24-B word soft advisory (3500 ceiling). 1351 words body — within B soft ≤1800 + 3500 ceiling (step-by-step deployment tutorial w/ toolchain comparison; not a strict horizontal review but closest fit among 5 prompt types).
prompt_type = "B"

# 👇 PaperMod display toggles
ShowToc = true
TocOpen = true
hidemeta = false
comments = true
disableShare = false

[cover]
    # D24 [fix]: same-type bug as A1 cover fix e54c7f0 + Hub fix b3a3a51. Missing
    # `images/` prefix caused render-image.html hook warning and live cover 404.
    # Fix: rewrite to resources path (relative to assets/) to match PaperMod cover.html line 22 absURL fallback.
    image = "images/static-site/static-blog-setup-guide/cover.jpg"
    alt = "Developer at a dual-monitor workstation writing code in dark theme, representing the hands-on static blog setup process."
+++

## Zero-Cost, Fully Automated Static Blog Setup with Cloudflare Pages + Hugo

As a developer, once you've locked down your domain name, **don't** burn money on a generic overseas VPS — and don't sink hours into configuring Nginx or patching Linux CVEs. Pair GitHub for source hosting with Cloudflare Pages' global edge network, and you can ship a serverless, millisecond-load, malware-proof geek static tech blog at zero cost.

---

## 1. Static vs Dynamic: A Quick Comparison

Before committing, I weighed static blogs head-to-head against the traditional WordPress stack. For a technical audience, static is a decisive win:

### Static Blog vs Dynamic Blog (WordPress)

| Dimension | Static Blog (my pick) | Dynamic Blog (typical WordPress) |
| :--- | :--- | :--- |
| **Server cost** | 💰 **\$0 — fully free** | 💵 \$5–\$20 / month fixed |
| **Global access speed** | 🚀 **Blazing** (posts cached at hundreds of CDN edge POPs worldwide — instant open) | 🐢 **Slower** (constrained by origin DC location and bandwidth; needs elaborate cache tuning) |
| **Security** | 🔒 **Bulletproof** (no database, no server-side code execution — nothing for attackers to exploit) | ⚠️ **Exposed** (plugin vulnerabilities are rampant; easy to get defaced or hit with grey-hat ad injection) |
| **Maintenance** | ☕ **Zero ops** (no Linux patching, no SSL certificate renewal) | 🛠️ **Heavy** (regular backups, plugin updates, constant malware vigilance) |
| **My one caveat** | Tweaking layout or going deep on theme customisation requires touching code — not for non-developers. | As content grows the site becomes bloated and database queries slow down. |

---

## 2. Step 1: Take Over DNS Resolution (Free Cloudflare Shield)

1. Go to the **Cloudflare website** (`https://cloudflare.com`) and sign up for a free account.
2. After logging in, on the dashboard home click **Websites** in the left-hand main menu.
3. Click **Add a site** (or **Get Started**), then enter your domain (e.g. `heimaeden.com`).
4. The plan picker will pop up — **scroll all the way to the bottom** and select the **Free** plan (\$0/mo), then continue.
5. Cloudflare will auto-scan your existing DNS records — just click continue.
6. The page will prominently show two Cloudflare-assigned **Nameservers** (e.g. `xxx.ns.cloudflare.com` / `yyy.ns.cloudflare.com`). Copy both.
7. Log into your **Spaceship dashboard** ➔ click **Domains** ➔ find your domain ➔ click **Nameservers** ➔ choose **Custom DNS** ➔ paste those two addresses in, delete the old ones, and save.

---

## 3. Step 2: Initialise Hugo Locally + Push to GitHub

1. **Install Hugo locally**: open a terminal. macOS users run `brew install hugo`; Windows users run `scoop install hugo`.
2. **Scaffold the project**: from a clean directory, run:

   ```bash
   hugo new site heimaeden-blog --format toml
   cd heimaeden-blog
   git init
   ```
3. **Download the de-facto geek theme (PaperMod)**: cloning the Git submodules from inside China tends to time out, so I sidestep that with a manual download:
   * Paste this direct URL into your browser: [PaperMod ZIP download](https://github.com/adityatelange/hugo-PaperMod/archive/refs/heads/master.zip)
   * Extract the ZIP; you'll get a `hugo-PaperMod-master` folder — **rename it to `PaperMod`**.
   * Drag the entire `PaperMod` folder into your project's `themes/` directory. Confirm the layout is `heimaeden-blog/themes/PaperMod/theme.toml`.
4. **Update the global config**: open `hugo.toml` at the project root and append `theme = "PaperMod"` at the bottom.
5. **Create your first post**: in the terminal:

   ```bash
   hugo new posts/my-first-tech-post.md
   ```

   Open the new file and flip `draft = true` to `draft = false` in the front matter.
6. **Push to GitHub**: create a new repo named `heimaeden-blog` on GitHub, then run the standard git commit/push flow to ship your local code.

---

## 4. Step 3: One-Click Deploy on Cloudflare Pages

1. Log in to the Cloudflare dashboard and click **Compute (Workers & Pages)** in the left sidebar.
2. **Critical step**: don't click the big blue button in the top-right corner! I got lost here the first time. Look at the screenshot below — at the very bottom of the white card you'll find a tiny grey line: 👉 **`Looking to deploy Pages? Get started`**. Click the blue **Get started** link.
3. After the page jumps, click **Connect to Git** and authorise + select your `heimaeden-blog` repo from GitHub.
4. **Configure build settings**:
   * **Framework preset**: in the dropdown, precisely select **Hugo**.
   * **Build command**: once you pick Hugo, the field auto-corrects to plain **`hugo`** (no `npx` prefix).
5. **Add an environment variable** (to avoid build failures from an outdated Hugo version): expand Environment variables and click add:
   * Variable name: `HUGO_VERSION`
   * Value: `0.120.0`
6. Click **Save and Deploy** at the bottom. Wait about a minute for the green progress bar to finish, then click **Custom domains** to attach your apex `heimaeden.com`. You're live!

---

## 5. The Heavyweight Pitfalls I Hit While Building

### Pitfall 1: Accidentally Creating a Cloudflare Workers Project (Can't Find Pages)

* **Real screenshots from the moment I got stuck**:

  * Screenshot 1 — the Workers configuration screen I was misdirected into (no framework preset, only wrangler fields):

    ![Cloudflare Workers configuration screen — wrangler-style fields with no framework preset dropdown](/images/static-site/cloudflare-workers-config-screen.png)

  * Screenshot 2 — the deeply hidden grey-text entrance to Pages:

    ![Cloudflare Pages entrance link — the grey "Looking to deploy Pages? Get started" row at the bottom of the card](/images/static-site/cloudflare-pages-entrance-link.png)

* **What happened**: I reflexively clicked the most prominent blue button in the top-right — `Create application`. After binding GitHub, I realised the configuration screen had no Framework preset dropdown — only `Build command` (showing None) and `Deploy command` (showing `npx wrangler deploy`). Forcing a deploy produced an endless stream of errors.
* **How I fixed it**: I discovered that the new Cloudflare console is an aggregated flow. After clicking `Create application`, you default into the **Workers (serverless functions)** flow — but a static blog must go through the **Pages** flow. I clicked Back, scrolled to the bottom of the create-page card, and spotted that tiny grey line `Looking to deploy Pages? Get started` (see Screenshot 2). Clicking **Get started** finally switched me into the clean Pages flow and banished the `wrangler` errors for good.

### Pitfall 2: Build Fails with the Red `unmarshal failed: toml: expected character =`

* **What happened**: my first deploy came back with a red error in the Cloudflare Pages log — a TOML parsing failure at line 3 of `/content/posts/my-first-tech-post.md`.
* **Root cause**: my global config file is `hugo.toml` (TOML format), so the front matter of every post must follow TOML syntax too. I had accidentally written the new post's front matter in YAML (with `:` assignments, e.g. `draft: false`), which crashed the online Hugo compiler.
* **How I fixed it**: I opened the Markdown file locally, wrapped the front matter in `+++`, and converted every assignment to the standard `=` form:

  ```toml
  +++
  title = "My First Tech Post"
  date = 2026-08-11T14:30:00Z
  draft = false
  +++
  ```

  After saving and `git push`, Cloudflare compiled successfully in seconds and `heimaeden.com` lit up worldwide!

---

<!-- 📸 截图位 #1: sitemap-xml-browser.png (域名已 redact-image.sh 打码) -->
![sitemap.xml in browser — URL list of every published post](/images/static-site/static-blog-setup-guide/sitemap-xml-browser.png)

## 6. Three Things to Do Right After First Deploy

First deploy is just the starting line. Skip any one of these three and your blog will be treated as an "orphan page" by search engines — they'll never find it.

### 6.1 Submit sitemap.xml (Tell Search Engines You Have Pages)

1. **Confirm the sitemap exists**: Hugo auto-generates `/sitemap.xml` on every build. After deployment, browse to `https://your-domain.com/sitemap.xml` and you should see the full XML listing every published post URL.

<!-- 📸 截图位 #1 — 在此处插入截图 -->

2. **If it's missing**: check whether `hugo.toml` accidentally disabled it:

   ```toml
   [sitemap]
       changefreq = "weekly"
       priority = 0.5
       filename = "sitemap.xml"
   ```

   Any commented-out or missing field makes Hugo skip sitemap generation by default.

### 6.2 Submit Your Domain to Google Search Console

1. Visit [Google Search Console](https://search.google.com/search-console/) and sign in with your Google account.
2. Click **Add property** in the top-left, choose **URL prefix**, and paste your full domain (including `https://`).
3. Pick **HTML tag** for verification (recommended — zero ops):
   * Google will give you a `<meta>` tag like:

     ```html
     <meta name="google-site-verification" content="xxxxxxxx" />
     ```

   * In your Hugo project, create `googlexxxxxx.html` under `static/` (use the exact filename Google gives) and put just the `content="xxxxxxxx"` string into it.

<!-- 📸 截图位 #2: gsc-verification-html-file.png (GSC 令牌已 redact-image.sh 打码) -->
![Google Search Console verification HTML file served from the site root](/images/static-site/static-blog-setup-guide/gsc-verification-html-file.png)

4. After submission, Cloudflare Pages will publish the file to the root path on the next build and Google auto-verifies.
5. Once verified, in the left menu go to **Sitemaps** ➔ type `sitemap.xml` ➔ submit.

### 6.3 Set Cloudflare SSL/TLS Mode to Full (strict)

1. Back in the Cloudflare dashboard, select your domain in the left menu ➔ **SSL/TLS**.
2. The default is **Flexible** — **this is wrong**: the browser ↔ Cloudflare leg is HTTPS, but the Cloudflare ↔ origin (your Pages) leg is HTTP. A man-in-the-middle could tamper with it.
3. Switch to **Full (strict)**: Cloudflare validates the origin certificate, and the entire chain becomes end-to-end encrypted.

<!-- 📸 截图位 #3: cloudflare-ssl-full-strict.png (域名 + 账户已 redact-image.sh 打码) -->
![Cloudflare SSL/TLS set to Full (strict) — end-to-end encryption enabled](/images/static-site/static-blog-setup-guide/cloudflare-ssl-full-strict.png)

4. Cloudflare Pages ships with a valid certificate out of the box — no manual upload needed.

---

✅ Once that's done your blog has the "sitemap + GSC indexing + end-to-end HTTPS" trio, and search engines will start crawling naturally within 1–2 weeks.