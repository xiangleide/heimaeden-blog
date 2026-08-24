# Dev Server baseURL Override

> **Gotcha discovered**: D11 2026-08-24 — when starting `hugo server` for
> local visual check, the homepage rendered `<img src="https://heimaeden.com/...">`
> even when the browser was at `http://localhost:1313/`. New `cover.png`
> looked missing in the browser even though `curl localhost:1313/.../cover.png`
> returned 200 OK locally.

## Why

`hugo.toml` declares:

```toml
baseURL = 'https://heimaeden.com'   # 确保末尾带有标准斜杠
```

This is the **production canonical URL**. Without an override, `hugo server`
emits all asset `src` / `href` / canonical tags using this absolute URL — so
your local browser fetches `https://heimaeden.com/images/<path>/cover.png`
which only exists on Cloudflare Pages after deploy. **Until you `git push`
+ Cloudflare builds, every new image you add will 404 in local browser
preview** (and the article body text + 5 already-deployed screenshots will
still work because they exist on the CDN).

## Fix

Always start dev server with explicit dev baseURL:

```bash
hugo server --baseURL http://localhost:1313/
```

Equivalent results (whichever you prefer):

```bash
hugo server --baseURL http://localhost:1313   # trailing slash optional
hugo server -b http://localhost:1313/         # short flag
```

After restart, verify the rendered HTML now points at localhost:

```bash
curl -s http://localhost:1313/ | grep -oE 'src="[^"]*cover\.png[^"]*"'
# expected: src="http://localhost:1313/images/<category>/<slug>/cover.png"
```

## Why not just edit `hugo.toml` temporarily?

Tempting to change `baseURL` to `http://localhost:1313/` for the session,
then revert. **Don't.** The risk:

- Forget to revert → next `git add hugo.toml` accidentally stages it →
  commit message "fix: dev preview" pollutes history with a no-op revert.
- Multiple `hugo server` processes racing on the same `hugo.toml` is fine
  but humans racing on the same file is not.

The `--baseURL` flag is scoped to the dev server lifetime, never touches
the tracked config, and rebuilds identically to production except for the
URL prefix.

## When this matters

| Scenario | Needs `--baseURL` override? |
|---|---|
| Just edited an existing image (already deployed) | No — old CDN URL works |
| Added a **new** image (cover, screenshot, asset) before `git push` | **Yes** — CDN 404 |
| Editing only `.md` body text / front matter | No — text has no asset deps |
| Browsing an old post whose assets are deployed | No |

Rule of thumb: **any commit that adds new files under `assets/images/`**
should be followed by `hugo server --baseURL http://localhost:1313/`
before visual verification, until the commit reaches `origin/main`.

## Related

- `CLAUDE.md §3.3` — image source whitelist + path format
- `CLAUDE.md §3.3.2` — MANDATORY optimize before `git add` (covers the
  repo-bloat reason, not this URL mismatch)
- `layouts/_partials/cover.html` — custom override that adds `assets/`
  lookup on top of PaperMod's page-bundle + global-resources chain
- `themes/PaperMod/layouts/_partials/cover.html` — upstream behavior