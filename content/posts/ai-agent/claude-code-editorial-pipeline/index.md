+++
title = "How I Cut My Solo Tech Blog Pipeline from 6 Hours to 2 Hours Per Post in 11 Days"
description = "Solo dev cut blog pipeline from 6h to 2h per post in 11 days with Claude Code. Includes the day AI wrote first-person content and I had to revert it."
date = 2026-08-22T01:30:00Z
draft = false
tags = ["Claude Code", "editorial pipeline", "indie blogger", "content automation", "workflow"]
categories = ["AI-Agent"]

showToc = true
TocOpen = true

[cover]
    image = "ai-agent/claude-code-editorial-pipeline/cover.png"
    alt = "Laptop glowing mint-green on a dark developer desk at night, code editor and commit graph on screen, mechanical keyboard in foreground, faded six-stage pipeline loop in background"
+++

## Introduction: 11 Days, 4 Major Iterations, from 6 Hours to 2 Hours per Post

Eleven days ago I grabbed heimaeden.com on NameCheap. At the time I only wanted to set up a Hugo + Cloudflare Pages pipeline — I had no plan to use AI to write articles. Today (D11) I have published 3 English long-form posts, evolving from "6 hours per post, Stack Overflow debugging" to "2 hours per post, AI pair debugging." In between, there was 1 incident where AI ghostwrote for me and I reverted it on the spot (commit `bc9a369`), and I crystallised 6 hard rules into CLAUDE.md §3.8. Most recently I introduced a mock-reader skill to run P1/P3/P5 feedback, which surfaced several blind spots I had not noticed.

> **Section fact baseline** (already anchored, no rewrite needed):
> - Project start date = 2026-08-11 (D0)
> - Current date = 2026-08-22 (D11)
> - Actual posts published = 3 long-form (A1 / A2 / A3)
> - Evolution history source = `README.md §6 (Dynamic Notes)` + `CLAUDE.md §3.8` lessons-learned entries + `docs/think-x1-claude-code-pipeline.md`

---

## §1 Current State: 6-Stage TCM SOP (50-word stage description each)

**Stage 1: Topic gating + Money Hook confirmation** — AI scans candidates via web search, returns 3 with SEO / differentiation / compliance comparisons, lands on the Money Hook (affiliate slot). The 0th gate at the narrative endpoint.

**Stage 2: Local file creation + Chinese first draft injection** — AI auto-writes .md + front matter (lint_allow / cover / pre-flight community search), [draft] commit, hold push.

**Stage 3: Hands-on operation + Agent real-time debug** — user runs commands + captures screenshots; Agent reads error logs end-to-end and pairs to fix local config. This is the tight-coupling zone where AI does the work and provides context.

**Stage 4: Second-pass Chinese polish** — AI integrates hands-on feedback / errors / screenshots, drops the step-by-step scaffolding, introduces first-person, [zh-final] commit. Subtraction over addition.

**Stage 5: English translation + compliance cleanup** — AI word-for-word correspondence + idiomatic English + SEO + remove lint_allow; translation must not add or remove facts (CLAUDE.md §3.8 rule 5).

**Stage 6: Local build + manual final review** — `hugo --gc` + browser visual + PII redaction check; on user ack, `git push`, loop back to Stage 1. The human gate stays last.

Stage overview (aligned to Content-Agent-TCM.md 6 stages):
1. **Stage 1: Topic gating + Money Hook confirmation** (AI web search + recommend 3 candidates → user picks 1)
2. **Stage 2: Local file creation + Chinese first draft injection** (AI auto-writes .md + draft commit + hold push)
3. **Stage 3: Hands-on operation + Agent real-time debug** (user runs commands + Agent pairs to fix local config)
4. **Stage 4: Second-pass Chinese polish** (AI integrates debugging experience + hands-on feedback + screenshots)
5. **Stage 5: English translation + compliance cleanup** (AI word-for-word + idiomatic English + SEO structure)
6. **Stage 6: Local build + manual final review** (hugo --gc + browser visual + git push)

![Six-stage editorial pipeline (draw.io). Stage 1 Topic Pick + Money Hook, AI web search recommends 3 candidates, user picks 1. Stage 2 Local File + Chinese Draft, AI writes .md, draft commit, hold push. Stage 3 Hands-on Operation + Agent Debug, user runs commands, agent pairs to fix local config. Stage 4 Second-pass Chinese Polish, AI integrates debugging + feedback + screenshots, zh-final commit. Stage 5 English Translation + Cleanup, AI word-for-word + idiomatic English + SEO, remove lint_allow. Stage 6 Local Build + Manual Review, hugo --gc, browser visual, git push on user ack. Loops from Stage 6 back to Stage 1 labeled 'commit'.](/images/ai-agent/claude-code-editorial-pipeline/pipeline-overview.png)

### §1.5 Measured time (D4-D11 data / 7-post cumulative)

| Stage | Measured time | Main failure mode | Cumulative share |
|---|---|---|---|
| Stage 1 Topic pick | ~5 min/post | AI recommendation misses Money Hook (fallback to manual pick) | 5% |
| Stage 2 Chinese first draft | ~10 min/post | lint_allow false positives + front matter TOML syntax | 8% |
| Stage 3 Hands-on operation | ~30 min/post | Hugo theme switch JS handler loss / screenshot redaction decision | 25% |
| Stage 4 Second-pass Chinese polish | ~15 min/post | first-person hands-on paragraph filling (user-must-write) / mock-reader feedback digestion | 13% |
| Stage 5 English translation | ~40 min/post | 6 numbers-from-memory instances / dev-internal marker leakage | 34% |
| Stage 6 Build + review | ~10 min/post | browser visual delay / category page fallback exposure | 8% |
| **Total** | **~2 h/post** | — | **100%** |

> **Baseline comparison**: in the D0-D3 manual era, ~6 h/post — main bottlenecks were translation (~2 h) + Hugo theme config (~1 h) + multilingual SEO (~0.5 h). After introducing Claude Code, Stages 3/4/5 each shortened 50-67%, but Stage 5 translation cost barely moved (still 34%) — that's the biggest future optimisation target.

### §1.6 Tool comparison (Claude Code vs Cursor vs pure-manual)

| Dimension | Claude Code (this article's main line) | Cursor | Pure-manual handbook |
|---|---|---|---|
| **Time per post** | **~2 h** (measured at D11) | ~4 h (industry estimate, no first-hand measurement) | ~6 h (D0-D3 measured baseline) |
| **Main bottleneck** | Translation cost (Stage 5 at 34%) + mock-reader feedback digestion | Editor acclimation cost | Hugo theme + multilingual SEO |
| **Onboarding cost** | skills + SOP learning (CLAUDE.md §3.8 + docs SOP) | Editor migration + habit rebuild | 0 (no AI dependency) |
| **first-person risk** | High (**D4 revert incident**) | Medium (in-editor AI does not write .md directly) | None |
| **Maintenance cost** | CLAUDE.md + docs SOP sync / mock-reader report archiving | Editor upgrades / subscription renewal | Hugo theme upgrades |
| **Applicable scale** | Solo dev + heavy AI collaboration | Solo dev + heavy IDE usage | Any |
| **Exit cost** | Medium (skill file rewrite + SOP migration) | Medium (editor habit rebuild) | 0 |

> **Selection recommendation**: If you already know Hugo + are willing to maintain CLAUDE.md / SOP, and want the 6h → 2h 67% time savings → Claude Code. If you only want IDE-native AI assistance without SOP maintenance → Cursor. If the D4 revert-style risk makes you not want to touch it → the pure-manual 6h baseline is acceptable.

---

## §2 Evolution history (core section): 4 iteration nodes

### §2.1 D0-D3: Pure-manual era, Stack Overflow debugging

#### 2.1.1 Origin: D0 domain grab + D3 first long-form publish

At 2026-08-11 21:36 (`8cf52ea` first commit) I grabbed the heimaeden.com domain. Three days later, at 2026-08-13 22:50 (`504d0d1` "feat: complete (with rich illustrations) hugo deployment traps guide with elite screenshots"), the Hugo + Cloudflare Pages pipeline + first English long-form post went live. The work in between: DNS / Cloudflare Pages dashboard / Hugo theme config / theme-switch SVG rendering / font optimisation / deploy hook — all manual.

At 2026-08-11 (D0) 21:36 I grabbed heimaeden.com — at that moment I only wanted to set up a Hugo + Cloudflare Pages pipeline, I wasn't thinking too far ahead. Over the next 3 days (D0 → D3 = 2026-08-11 → 2026-08-13), DNS / Cloudflare NS handoff / Hugo theme mounting / PaperMod template config / Cloudflare Pages dashboard / HUGO_VERSION pinning / Legal four-piece set / About / Archives / Search / Contact page-ification… I configured each one by hand. That moment at D3 dawn when I pushed the first long-form post live, looking back at git log — from first commit `8cf52ea` to first long-form `504d0d1` was only 3 calendar days apart, and the sense of achievement just exploded.

#### 2.1.2 6 hours/post: the most time-consuming / painful parts back then

During D0-D3 and for a while after, each article averaged ~6 hours: looking up Hugo / PaperMod docs + Stack Overflow debugging + writing + screenshots + Chinese → English translation + multilingual SEO setup. These 6 hours were scattered across all my daily waking time, with no AI acceleration — just github issue trawling and self-debugging.

What ate the most time within those 6 hours was **translation + multilingual SEO setup + Hugo theme-switch SVG rendering / font optimisation** — these three pieces are not "writing the article" itself, but each one could single-handedly eat half a day. During D0-D3 there was no AI acceleration, and the only thing I could do was flip through github issues + self-debug on stack overflow + run `hugo --gc` over and over locally + refresh the browser preview again and again.

![Hugo Cloudflare Pages dashboard from the manual era (D0-D3) before Claude Code automation. Shows DNS, Hugo theme, and Cloudflare Pages settings before the editorial pipeline existed.](/images/ai-agent/claude-code-editorial-pipeline/d3-manual-era-hugo-cf.png)

### §2.2 D4: First time introducing AI + commit bc9a369 revert incident

#### 2.2.1 Origin

On D4 morning, I decided to have AI ghostwrite the first English long-form post in the A series. When handing the task off to AI, what I gave was not "my real hands-on notes" but **topic keywords + expected word count + a single-sentence copy frame**.

AI output a 1787-word English troubleshooting long-form post, commit `4b8a8ea` (2026-08-15 22:00:49 +0800):

```
D4: B1 long-form #1 — Cloudflare Pages Preview Branches guide
... 10 H2 sections ... 3 trap write-ups sourced from real config drift I hit ...
```

Notice the "I hit" wording at the end of the commit message — **AI had already polluted its description of its own work**, which is a self-contamination phenomenon, not just the body text.
My original intent was to try having AI write the article entirely for me. At first I assumed AI would mirror the style of my previous three posts to quickly fill up the article count on the live blog, but the final result was terrible.

#### 2.2.2 Self-check triggered after publish

In the evening the article was already live on Cloudflare Pages. I started re-reading the article I had just posted…

When I got to the passage "For my first two weeks of running heimaeden.com ..." I realised something was off — the time of writing this article was less than two weeks from when I had just started building the blog, and AI had fabricated that section from my perspective, which set off my alarm bells. Once I finished reading the whole article, I found things were far worse than I had thought — AI had fabricated a lot of content that did not match reality.

#### 2.2.3 Revert

I immediately ran `git revert 4b8a8ea` → commit `bc9a369` (2026-08-15 22:03:43 +0800):

```
Revert "D4: B1 long-form #1 — Cloudflare Pages Preview Branches guide"
This reverts commit 4b8a8ea9858a55637c9f0388badfcc832fa4b40b.
```

Revert done, I checked online to confirm the article was gone, and only when my fingers left the keyboard did the cold sweat break out. After handling the most urgent things at hand, my mind was full of thoughts — alert, disappointment, and more than anything else the consideration of how to prevent similar problems going forward. I had to add some hard rules for Claude.

#### 2.2.4 That night: don't patch SOP, cool down overnight

That night I did not touch `CLAUDE.md`. Since the scene was preserved and the live blog was at its initial stage with basically no readers likely to see the failed article, I decided to first quit the Claude session and cool down overnight — deciding which hard rules needed careful thought. I needed to calm down, and only after getting enough rest could I make more precise judgement and decisions.

#### 2.2.5 D5 afternoon: systematised 6 rules

On D5 2026-08-16 (the next day) afternoon, I systematised 6 rules into `CLAUDE.md §3.8`: using the D4 revert incident as the lessons-learned anchor, I worked through "AI writes first-person / topic context / real screenshots / affiliate draft marker / translation word-for-word / cross-ref anchor" as the 6 hard rules. Same day I added `docs/article-writing-workflow.md Appendix E` "D4 lessons" as the detailed case study.

#### 2.2.6 Three self-check questions (echoing §5.4)

The D4 incident could be reverted in time because three objective conditions held simultaneously:

1. ✅ When I delegated the writing I handed off "topic + copy frame", **not real first-person experience** — I didn't give source material, so AI had to fabricate (this is the premise that let me audit the cause)
2. ✅ I could audit `4b8a8ea` against git history to check whether it had a real source
3. ✅ AI output was an intermediate commit, revertible — D4's "luck" came entirely from this point

If any condition had not held (for example AI pushed directly to main, or I was in a private repo), revert time would have stretched out significantly. **The core of the D4 lesson**: keeping AI output bounded inside intermediate commits, where I hold the revert right, is the physical prerequisite for this human boundary to hold.

![git log -p output showing bc9a369 reverting commit 4b8a8ea. Two minutes fifty-four seconds between the AI-generated post landing at 22:00:49 and the human-driven revert at 22:03:43 on 2026-08-15.](/images/ai-agent/claude-code-editorial-pipeline/d4-revert-commit-diff.png)

### §2.3 D5: Dual-post in parallel + lint_allow temporary workaround

#### 2.3.1 Three-commit context

On D5 2026-08-16 I made 3 mutually independent commits:

- `800d460` 22:30:52 — D5: infra (cover assets lookup + external link rel=noopener + img responsive CSS)
- `a5bb839` 22:31:01 — D5: content (A2/A3 long-form polish, covers / captions / alt text / blockquote cleanup)
- `b751bdb` 22:50:39 — Translate A2 + A3 to English (final)

The three commits landed in succession within ~20 minutes. This was the first bulk polish / publish attempt on the full content cluster after the D4 `bc9a369` revert incident.

It was neither a "batch publishing strategy" nor "sense of safety" — on D5 I had just filled in three pieces of infrastructure at once: `cover.html` / `render-link.html` / responsive CSS, and both A2 + A3 needed these. So I shipped both posts simultaneously. If I had only shipped one, the next post would still need to re-run compatibility tests for these three hooks; launching both at once validated that both worked in one pass, saving total work time. In the end all 3 commits landed within ~20 minutes.

#### 2.3.2 lint_allow temporary workaround

11 HTML-comment CJK entries kept — why did I use `lint_allow = ["cjk-body"]` as the compromise rather than immediately modifying `lint-post.sh` to exempt HTML comments from CJK checks?

All 11 entries were dev-internal screenshot-position markers (`<!-- 📸 screenshot-marker #N ... -->`); Hugo does not render comments to the page, and the dev-trace is only visible at the source level. Modifying the script touches CLAUDE.md §3.2 hard constraints, and waiting for D10 to trigger then fixing them in one batch was more stable; `lint_allow = ["cjk-body"]` was the minimum-cost choice to "keep lint passing + leave SOP untouched."

![Git log graph showing three D5 commits 800d460, a5bb839, b751bdb pushed within twenty minutes. Two infrastructure commits plus the content polish commit, then the English translation commit at 22:50:39.](/images/ai-agent/claude-code-editorial-pipeline/d5-three-commit-graph.png)

### §2.4 D10: mock-reader-feedback skill introduced (commit 7d2cdee)

#### 2.4.1 mock-reader skill trigger

On D10 2026-08-20 I realised "AI picks + AI writes" still lacked a third-party perspective — AI does not audit its own output in reverse, so a persona-simulated reader was needed. On D10 that evening I landed 3 commits within 17 minutes:

- `7d2cdee` 22:24:14 mock-reader-feedback skill MVP + GSC wiring
- `8dedff0` 22:33:57 add 3 P5-driven selection backlog entries (S10-S12)
- `ee25372` 22:41:16 archive 4 mock-reader reports (P1/P3/P5 + P1-vs-P3)

4 reports archived at `docs/feedback/claude-code-cli-setup-indie-blog-{P1,P3,P5,P1-vs-P3}.md`. Key findings: positioning drift (dev-internal marker leakage) / above-the-fold misalignment / title AI-farm smell.

The 5 personas are not designed out of thin air — they are the 5 typical user types of Claude Code: strong-China-mainland dev / Western indie hacker / selection decision-maker / content-farm sniffer / overseas mentor. After AI picks + AI writes, a third-party perspective is still missing — AI does not audit its own output in reverse, so a persona-driven reader needs to run through it. This is why I built `mock-reader-feedback` as a skill rather than a script: persona-driven has audit value; simply "having AI re-read once" is zero incremental value.

#### 2.4.2 Most counter-intuitive feedback from P1/P3/P5

P1 (strong-China-mainland dev) / P3 (Western indie hacker) / P5 (selection decision-maker) three personas generated 4 reports of feedback. One of the biggest blind spots was "dev-internal marker leakage" — I thought notes written into the background description were self-evident and harmless, but for P3 this was completely counter-intuitive.

What struck me most in the P3 feedback was neither "title farm smell" nor "above-the-fold misalignment" — it was **"dev-internal marker leakage."** I thought self-evident notes in the background description (such as "field-self-fill" / "config placeholder" / "phase marker") were invisible to readers, but for P3 this was completely counter-intuitive: they read from the description that "the author is clearly still in build phase," and trust drops instantly. P1, on the other hand, gave a counter-confirmation: "the command-line EACCES section is too short — should add 2-3 more concrete error screenshots" — this was a blind spot I had not been aware of before running mock.

![ls docs/feedback/ output listing four mock-reader reports for claude-code-cli-setup-indie-blog: P1, P3, P5, and P1-vs-P3. Three commits on 2026-08-20 within 17 minutes archived the persona-driven feedback trail.](/images/ai-agent/claude-code-editorial-pipeline/d10-mock-reader-reports.png)

---

## §3 Known issues: 3-5 pain points

1. **`lint-post.sh` does not exempt HTML-comment CJK** — 11 dev-internal screenshot-position markers repeatedly false-positive; every time I have to manually add `lint_allow`; future M5-phase output of ≥15 posts will be slowed by lint noise.
2. **mock-reader feedback "positioning drift" not yet rooted out** — the `claude-code-cli-setup-indie-blog` post once tried to serve P1 + P3 + P5 simultaneously, leaving neither side deep enough. X1 must hard-cut at the narrative architecture, single-persona served all the way.
3. **Translation commit has no prefix** — A2/A3's `b751bdb` lacks `[translate]` / `[zh→en]` markers; git log cannot easily identify translation-stage nodes; cross-session traceability cost is high.
4. **CLAUDE.md §3 / docs SOP sync lagging** — D5-added 4 hard constraints (`cover.html` / `render-link.html` / translation commit no-prefix / dev server baseURL) + D10 mock-reader SOP + 11 HTML-comment exemptions are all not yet written into a new section after §3.8.
5. **Y1 / Y2 series single-post decisions deferred** — cluster first-release cadence is dragged by X1 completion status; mock-reader / pre-commit gates / redact-image PII three posts all sit in the pending backlog.

---

## §4 Next 6 months direction: 2-3 to-be-adjusted items

1. **CLAUDE.md §3 SOP major-version sync** — pull the 6 hard constraints accumulated at D5 / D10 (`cover.html` override / `render-link` hook / translation commit no-prefix / dev server baseURL convention / lint_allow HTML-comment exemption / mock-reader SOP) into a new section after §3.8 in one pass; avoid hard constraints scattered across multiple places causing future session misreads.
2. **`lint-post.sh` enhancement + cross-ref automatic verification** — add `<!-- ... -->` HTML-comment CJK exemption (CLAUDE.md §3.2 extension); integrate the `verify-cross-refs` skill into lint-post.sh as the §3.8 rule 6 hard validation step; prevent "anchor-less cross-reference phantom conclusions" from happening again.
3. **Theme migration PaperMod → Hugo Modules** — current `themes/PaperMod/` whole-directory tracking hits 3 upstream deprecations (`.Language.LanguageDirection` / `.Language.LanguageCode` / built-in minify top-level config) as hard blockers; must convert to Hugo Modules form (CLAUDE.md §6 already forbids editing theme source), decoupling the theme-upgrade path.

---

## §5 Methodology boundary: what AI does / what I do

One-line mantra: **AI is the assistant, not the replacement**.

Anything that carries first-person hands-on experience, externally visible identity information, or final-publish-decision content, I gate; anything that is "process-bound, revertible, verifiable" intermediate output, AI drafts. This is the ratchet settled after the D4 revert incident, not degradable.

### 5.1 Human-gated items (4 items, hard constraints)

1. **first-person hands-on experience**: all "I ..." sentences must be written by me personally. AI drafts may generate the step-by-step framework, but does not fabricate subjective experiences on my behalf. (Basis: D4 revert incident; see §2.2 + CLAUDE.md §3.8 rule 1)
2. **Screenshot selection**: which screenshot goes into the article body is decided by me. AI can suggest "a screenshot is needed here"; the specific frame is chosen by me after seeing the real image.
3. **Screenshot redaction**: screenshots containing account / email / ID / card-tail must pass `./scripts/redact-image.sh`. I am the redaction decision-maker; AI only identifies candidate coordinates (CLAUDE.md §3.3.4) and does not make the final call for you.
4. **commit push ack**: any `git push` waits for me to personally run `git log -1 --stat` and read it through before acking. AI always holds push (CLAUDE.md §6).

### 5.2 Decision-rights attribution (3 decision items)

| Decision | Who decides | Why |
|---|---|---|
| Topic pick (which one from topic-pool recommendations) | User | The narrative endpoint is the person, not traffic |
| commit push ack | User (must ack) | Public CDN is not recallable |
| Y1/Y2 title deferral | User | Cluster first-release cadence submits to X1 completion state |

### 5.3 AI-assisted output (default OK, but needs audit)

- Draft structure (step-by-step framework + annotation slots + pre-flight search task)
- English translation (word-for-word, no fact addition/removal — CLAUDE.md §3.8 rule 5)
- cross-reference anchor verification (avoid phantom conclusions — CLAUDE.md §3.8 rule 6)
- mock-reader report structuring (mock-reader is not a real reader, AI may run it, but it is an audit walk)
- Documentation archiving (think-*.md / topic-pool.md and other structured memory)

### 5.4 Grey-zone regression test

When AI output is uncertain whether it belongs in 5.1 or 5.3, ask three questions:

1. If this content is wrong, **am I willing to publicly take responsibility?**
2. Can this content be **reverse-verified by a third-party reader** (not mock-reader)?
3. Can the AI output be **rolled back without loss**?

Any "no" answer → falls into 5.1 human-gated. I can pause the entire flow with a single chat message at any time; AI will not bypass me to commit push. This item has no "dialogue-end auto-execute" ack-exception.

---

## §6 Conclusion + series preview (pointing to Y1 / Y2)

11 days, 4 major iterations, from 6 hours to 2 hours per post — this pipeline has not disappointed me yet. **AI is the assistant, not the replacement.** This is the ratchet settled after the D4 revert incident, not degradable.

This article is X1 — the externalised form of the editorial-pipeline framework. The next stage splits into two series single-posts (titles deferred; **Y1 launch metric = X1 [zh-final] + translation + push complete + mock-reader reports ≥3 + translation commit with `[translate]` prefix in place**):

| Candidate | Launch metric (all must hold) | Priority | Estimated effort | Main dependency |
|---|---|---|---|---|
| **Y1** mock-reader-feedback skill deep dive (persona implementation + report structure + integrate commit gate) | X1 published + mock-reader reports archived ≥3 + 5 persona data wired in | ★★★ | ~3 days | translation complete / persona-data.json V1.1+ |
| **Y2a** pre-commit gates breakdown (verify-image-paths / verify-cross-refs / lint-post.sh / hugo --gc four-piece set each as its own article) | After Y1 done + at least 1 gate-failure recovery experience | ★★ | ~2 days | verify-cross-refs integrated into lint-post.sh (M4 phase §4) |
| **Y2b** redact-image PII workflow deep dive (coordinate identification + script invocation + verification) | mock-reader reports have ≥1 PII false-positive + Pillow installed | ★ | ~1 day | existing `scripts/redact-image.sh` |

If you are also building your own overseas blog + AI toolchain, I hope this article helps you avoid the D4 revert-incident knife. A solo developer's editorial pipeline does not need flashy features — hold onto these three bottom lines: "first-person experience written by the author + AI drafts intermediate output + commit push always waits for ack" — everything else is optimisation space.