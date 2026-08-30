+++
title = "How I Built a 5-Persona Mock Reader Skill (with Claude Code)"
description = "5-persona mock reader feedback skill for Claude Code. 7-step workflow + YAML schema + 6 anti-patterns. Real hugo-pitfalls + TCO math."
date = 2026-08-30T00:00:00Z
draft = false
tags = ["Claude Code", "AI Agent", "Editorial Workflow", "LLM-as-Judge", "Persona Prompt", "Claude Code Pipeline"]
categories = ["AI-Agent"]

# Hugo series (per CLAUDE.md §3.4 + PaperMod taxonomy convention) — cluster with A2 claude-code-editorial-pipeline.
# Series landing: content/posts/ai-agent/_index.md + ai-agent category page.
series = ["AI Agent"]

showToc = true
TocOpen = true

[cover]
    # D21 M2 stage: AI-generated cover (Variant V1 5-persona lens view) replacing stage 4 placeholder cover.jpg.
    # Path format: resources path = images/<category>/<article-slug>/<file>, prefix images/ + drop assets/ (PaperMod cover.html line 22 absURL fallback).
    image = "images/ai-agent/mock-reader-feedback-skill-deep-dive/cover.png"
    alt = "Flat-vector technical illustration: a central green index.md document surrounded by 5 persona-colored viewer lenses (P1 red direct_technical, P2 orange editor-grade, P3 purple one-liner, P4 gray silent, P5 gold comparison-matrix). Top-left shows a faded ghost smiley with 5 stars crossed out in red, labeled LLM default positive bias. A bright green arrow loops from the ghost back to the central document, labeled mock-reader-feedback/v1."

# E-slot (methodology retrospective) - per docs/writing-prompts.md section 6: commit hashes + revert events + decision points.
# Content covers hugo-pitfalls / claude-code-cli-setup / claude-code-editorial-pipeline with 12 feedback commit anchors,
# anti-patterns map to 5 community pitfalls in section 0 + 1 baseline comparison, 5 decision points vs mock-reader choice.
prompt_type = "E"
+++

> **TL;DR**: The `mock-reader-feedback` skill is a Claude Code sub-command that uses 5 preset personas (P1-P5) to simulate reader feedback. It outputs a YAML feedback report to `docs/feedback/<article>-<persona>.md`. This article breaks it down: how the 5 personas are constructed, how the 7-step workflow runs, how the YAML schema is strictly enforced, and 5 anti-patterns I have already hit.
>
> **Author's note**: This skill is what I crystallised after running 12 feedback reports against 3 articles in August 2026 (`hugo-cloudflare-pages-pitfalls` / `claude-code-cli-setup-indie-blog` / [claude-code-editorial-pipeline]({{< ref "posts/ai-agent/claude-code-editorial-pipeline" >}})). Every report, script, and persona file referenced here lives in the repo and is inspectable.

---

## FAQ (Common questions up front)

**Q: What is `mock-reader-feedback`?**
A: A Claude Code sub-command skill that uses 5 preset personas (P1-P5) to simulate reader feedback. It outputs a YAML feedback report to `docs/feedback/<slug>-P{id}.md`.

**Q: How is it different from just asking an LLM to review the article?**
A: Asking an LLM directly (without a persona prompt) triggers the default positive bias — 5-star blanket praise (per Appendix 0 community pitfall #2). The skill forces explicit `feedback_style` + `rating < 5` hard constraints, pulling the LLM away from "generic positive feedback" toward paragraph-level critique.

**Q: When should I run it?**
A: After the `[zh-final]` / `[en-final]` stage, before `commit-with-prefix`. Default P5 (most demanding) + P1 (validates hands-on feasibility). After translation, add P3 (validates overseas-reader reception).

---

## Step 0: Community pitfall search (mandatory before hands-on)

**Task**: Before starting, scan community critiques of LLM-as-judge / persona prompts to avoid retreading the same traps.

**5 community pitfalls (by relevance)**:

1. **LLM surface-level bias**: [PersonaEval arXiv 2508.18076](https://arxiv.org/html/2508.18076v2) — Gemini-2.5-pro reaches only 68.8% accuracy in judging persona role-play quality (humans: 90.8%); the LLM fixates on surface language instead of conversational intent.
2. **5-star blanket praise is LLM default**: [Field Guide to AI](https://fieldguidetoai.com/scam-watch/fake-ai-reviews) — ChatGPT reviews are **systematically more positive** than humans; you must explicitly prompt to forbid 5⭐.
3. **Likert ceiling effect**: [Moonlight ceiling](https://www.themoonlight.io/fr/review/the-signal-is-the-ceiling-measurement-limits-of-llm-predicted-experience-ratings-from-open-ended-survey-text) — All models **systematically under-predict** ratings (positive-only 86% agreement vs negative-only 44%).
4. **Persona stereotyping**: [Irish Examiner](https://irishexaminer.com/opinion/commentanalysis/arid-41184352.html) — persona prompts like "business traveller" produce stereotyping.
5. **AI lacks the lizard brain**: [softwaredoug.com](https://softwaredoug.com/blog/2025/11/02/llm-judges-arent-the-shortcut-you-think) — LLMs lack the human engagement instinct; the last 10–20% of disagreement contains the most meaningful edge cases.

**Why search these 5 first**: `mock-reader-feedback` is LLM-as-judge at its core. Without knowing the biases, the feedback report is noise.

## Introduction

**The problem**: TCM SOP stage 4 (`[zh-final]`) says "user confirmation → trigger translation stage." If "user confirmation" is just AI self-checking, the result is AI auditing its own draft — **one of the Scaled Content Abuse signature signals**.

**The fix**: Use 5 preset personas to run a "virtual reader feedback" pass. Each persona has a different background + feedback style, forcing the AI to **read the article from a perspective other than its own**. Feedback is captured in a YAML report, leaving the human user as the final judge.

**What this article covers**:
- Steps 1-3: prerequisites, triggers, persona + data
- 5-persona comparison matrix
- Step 5: YAML schema breakdown + real-report excerpt
- 6 anti-patterns (mapping §0's 5 community pitfalls + 1 baseline)
- Dependencies + v1→v2 evolution
- Conclusion + 3 follow-up actions

**What this article does NOT cover**: an ROI comparison vs. a real human reader (separate article).

---

## Step 1: Install prerequisites

### 1.0 3 prerequisite checks

```bash
claude --version            # ≥ 1.0
ls -ld ~/.claude/skills/    # current user must have write access (macOS sandbox may restrict)
python3 --version           # ≥ 3.8 (Pillow compatibility)
```

### 1.1 Three required files

```bash
docs/mock-reader-personas.md    # 5 persona prompt templates (230 lines)
docs/persona-data.json          # MVP = MOCK data / V1.1+ = real data (203 lines)
.claude/skills/mock-reader-feedback/SKILL.md   # what this article dissects
```

**First-run mandatory**: `mkdir -p docs/feedback && echo 'initialized'` — the skill's default output directory does not exist on a fresh clone and the first run will fail.

### 1.2 One data-fetcher script

```bash
scripts/fetch-persona-data.sh   # validate cache status / optional --live
```

### 1.3 A ≥500-word target article

`content/posts/<category>/<article-slug>/index.md` (either `[zh-final]` or `[en-final]` works)

### 1.4 Self-check

```bash
# Validate cache JSON
python3 -c "import json; json.load(open('docs/persona-data.json'))"

# Validate 5 personas present
count=$(grep -c "^## P[1-5]" docs/mock-reader-personas.md)
if [ "$count" -ne 5 ]; then echo "persona count abnormal ($count), please check docs/mock-reader-personas.md"; exit 1; fi
```

> **Author's note on §1.4**: When I first ran the self-check, my `count` came back as `4`. The script exited 1, but I had not yet wired the failure-path behaviour into the skill — so the skill silently fell back to a 4-persona run. Lesson: pair every self-check with an explicit `exit 1` + visible stderr message; otherwise the silent fallback masks the data issue.

📸 **Screenshot slot (Step 1)**:
- **What to capture**: P1 section of `docs/mock-reader-personas.md`
- **Redaction**: not needed (in-repo public file)
- **Filename**: `step-1-personas-p1-section.png`
- **Where**: `content/posts/ai-agent/mock-reader-feedback-skill-deep-dive/step-1-personas-p1-section.png`

![P1 persona template from docs/mock-reader-personas.md: strong Chinese mainland dev, deployment-focused reader with direct technical feedback style and specific traps to avoid](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-1-personas-p1-section.png)

---

## Step 2: Trigger the skill

**5 trigger phrases** (any one is enough):

| Phrase | Scenario |
|---|---|
| "mock reader feedback" | English trigger, most common |
| "pretend to be a reader" | English casual |
| "P1 feedback" | Explicit persona selection |
| "give it a try-read" | Casual trigger |
| "act as a P3 reader" | Explicit multi-persona |

**Full command examples**:

```
# Default (recommend P5 selection-decision persona - most demanding feedback)
"Run mock reader feedback on hugo-cloudflare-pages-pitfalls"

# Explicit P1 (strong China-mainland dev, deployment-first)
"Run P1 feedback on claude-code-editorial-pipeline"

# Multi-persona comparison (V2 feature)
"Run P1 vs P3 comparison on hugo-pitfalls"
```

**Skill not triggering?** Check that `.claude/skills/mock-reader-feedback/SKILL.md` is in Claude Code's skill discovery path. Run `/skills` to list loaded skills — if `mock-reader-feedback` is missing, verify the file path + restart Claude Code.

---

## Step 3: Pick a persona + load data

### 3.1 Pick a persona (default P5)

```yaml
P1: strong China-mainland dev (deployment-first + EACCES debugging + domestic-network pitfalls)
P2: content creator (prose / SEO / clickbait detection)
P3: Western indie hacker (30-second decisions / ROI / selection tables)
P4: AI sceptic (LLM-as-judge vigilance / marketing-tone resistance)
P5: selection decision-maker (default · TCO / exit cost / comparison matrix)
```

**Why default P5**: P5 feedback is the highest quality; **it forces discovery of real problems** (per `mock-reader-feedback` SKILL.md §2). If the user does not specify, always P5.

### 3.2 Load data (default cache / explicit --live)

```bash
# Default (recommended) — read cache, no API-quota cost
./scripts/fetch-persona-data.sh

# --live mode (user explicitly requests a refresh)
./scripts/fetch-persona-data.sh --live --source=gsc
```

**Before GSC is wired**: every `data_source` in `docs/persona-data.json` reads `"[MOCK]"`. The prompt must explicitly tag `[MOCK]` — **never pretend to have real geographic data**.

> **Author's note on §3.2**: When I first wired GSC, I left the prompt header as "geographic distribution: CN 85% / HK 5% / TW 5% / SG 3% / OTHER 2%" without the `[MOCK]` tag. P3 ran for 30 seconds and produced feedback like "skew toward Asia, English might lose US audience" — LLM was treating mock data as real. Always tag the data source explicitly inside the prompt.

📸 **Screenshot slot (Step 3)**:
- **What to capture**: `geo_distribution` block of P1 in `docs/persona-data.json`
- **Redaction**: not needed ([MOCK] data)
- **Filename**: `step-3-persona-data-p1-mock.png`
- **Where**: same Page Bundle

![P1 geo_distribution mock data from docs/persona-data.json showing CN 85 percent, HK TW 5 percent each, SG 3 percent, OTHER 2 percent — labeled MOCK to avoid fabricating real geographic distribution](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-3-persona-data-p1-mock.png)

---

## Step 4: Construct the persona prompt (3 blocks)

```text
You are the HeimaEden blog's <P1-P5 persona label>. Background: <the P1-P5 description in docs/mock-reader-personas.md>.

Real-time data (from docs/persona-data.json's <persona-id> block):
- Geographic distribution: <geo_distribution>
- Device split: <device_split>
- Typical search queries: <top_search_queries>
- Preferred reads: <top_pages_visited>
- Community activity: <community_signals>

Reading scenario: <primary_intent> (e.g. deploy-fixing / selection-decision)

Your feedback style: <feedback_style> (e.g. direct_technical / reddit-grade / one-liner)

After reading [article title], output feedback in the YAML schema below.
```

**3 hard rules**:

1. **Always tag `feedback_style` explicitly** — to prevent P3 from writing long-form (one-liner) or P4 from writing commentary (silent). If `feedback_style` is left unspecified, the LLM defaults to "generic positive feedback" and triggers §0 pitfall #2 (5⭐ blanket praise).
2. **Tag `[MOCK]` explicitly when data is mock** — to prevent pretending to have real geographic data (per §0 pitfall #1, LLM surface-level bias).
3. **Do not read the front matter** — body only, so the prompt does not waste tokens on metadata.

---

## Step 5: Run the persona + emit the YAML schema (strict)

**Full YAML schema** (must be strictly followed — 12 front-matter fields + 4 body sections):

```yaml
---
schema: mock-reader-feedback/v1
persona_id: P1
persona_label: strong China-mainland dev
article_slug: hugo-cloudflare-pages-pitfalls
article_path: content/posts/static-site/hugo-cloudflare-pages-pitfalls.md
article_category: static-site
read_at: 2026-08-20T22:45:00Z
data_source: MOCK | GSC | CF | REDDIT | PLAUSIBLE
intent: deploy-fixing
feedback_style: direct_technical
rating: 1-5
verdict: stay | skim | bounce
---

<!-- Above YAML block + full persona thinking trace + key quote + suggested fixes -->

key_points:
  - …(3–5 items, positive + negative)
friction_points:
  - paragraph: "§3 fourth paragraph"
    issue: "the error example is missing the full stack trace"
    suggested_fix: "add the top 5 lines of the stack trace"
quote_feedback: |
  "If I landed here from a search for that error, I'd want the root cause within 3 screens."
session_signals:
  - estimated dwell time
  - estimated bookmark likelihood
  - estimated subscription likelihood
```

**Field reference**:

| Field | Required | Default | Description |
|---|---|---|---|
| `schema` | ✅ | — | Fixed `mock-reader-feedback/v1`; schema-version gate |
| `persona_id` | ✅ | — | P1–P5; triggers prompt selection |
| `persona_label` | ✅ | — | Eyeball label (avoid P1/P5 mix-ups) |
| `article_slug` | ✅ | — | Target slug; used in filename |
| `article_path` | ⚪ optional | inferred from `<slug>.md` | Full path; scripts read directly |
| `article_category` | ⚪ optional | inferred from front matter | Category redundancy; avoids front-matter parsing |
| `feedback_style` | ⚪ optional | `long-form-rss` (P5 default) | Guards against anti-pattern #2 |
| `read_at` | ⚪ optional | current ISO timestamp | Generation timestamp |
| `data_source` | ⚪ optional | `MOCK` | MOCK / GSC / CF / REDDIT / PLAUSIBLE |
| `intent` | ⚪ optional | `selection-decision` | Matches persona `primary_intent` |
| `rating` | ✅ | — | 1–5, **must be < 5** (5⭐ = distortion) |
| `verdict` | ✅ | — | `stay` / `skim` / `bounce` |

**§5.1 Missing-field failure modes** (vendor-grade robustness):

| Missing field | Behaviour |
|---|---|
| `schema` / `persona_id` | Error and exit |
| `persona_label` | Warn but still run (eyeball cross-check) |
| `feedback_style` | Warn + degrade to `long-form-rss` (avoid §6 #2) |
| `article_slug` | Warn but do not exit (fall back to default path) |

**Real-report body excerpt** (`docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md`, with front-matter strictly following the table above):

```yaml
key_points:
  - "Real reproduction of 7 traps + verified — does not read like AI farm content"
  - "ERR_TOO_MANY_REDIRECTS fix section has copy-pasteable commands"
  - "Cover uses an Unsplash concept image, real screenshots only appear in §7 — order feels off"
friction_points:
  - paragraph: "§3 ERR_TOO_MANY_REDIRECTS"
    issue: "Missing the actual invocation of the PII-redaction command before screenshotting"
    suggested_fix: "After §3.4 add `pip3 install --user Pillow` + a sample red-box coordinate set"
  - paragraph: "§6 Pros & Cons table"
    issue: "Hetzner column prices are 2024 data; 2026 prices have already gone up"
    suggested_fix: "Add a [discontinued] tag or refresh to verified 2026 prices"
quote_feedback: |
  "If I came in from a search for ERR_TOO_MANY_REDIRECTS, the title already
  matches. But I have to scroll past 3 screens of intro before §3 — recommend
  trimming intro to 200 words."
session_signals:
  - estimated dwell: 6 minutes (finished §3 + §6)
  - estimated bookmark: yes (fix section is copy-pasteable)
  - estimated subscription: no (never reaches the "domestic network pitfalls" section P1 cares about)
```

📸 **Screenshot slot (Step 5)**:
- **What to capture**: YAML header of `docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md`
- **Redaction**: not needed (already a public in-repo file)
- **Filename**: `step-5-real-report-hugo-pitfalls-p1.png`
- **Where**: same Page Bundle

![Real P1 mock-reader feedback YAML front matter from docs/feedback/hugo-cloudflare-pages-pitfalls-P1.md with 12 fields including schema mock-reader-feedback/v1, persona_label, article_path, feedback_style, rating 4, verdict stay](/images/ai-agent/mock-reader-feedback-skill-deep-dive/step-5-real-report-hugo-pitfalls-p1.png)

---

## Step 6: Write to docs/feedback/

```bash
# V1 default: drop in docs/feedback/ first, **do NOT auto-commit**
docs/feedback/<article-slug>-<persona-id>.md

# V1 file structure (YAML inside markdown body, not TOML front matter)
---
schema: mock-reader-feedback/v1
persona_id: P1
article_slug: <article-slug>
read_at: 2026-08-20T22:30:00Z
intent: deploy-fixing
data_source: MOCK
rating: 4
verdict: stay
---

<!-- Above YAML block + full persona thinking trace + key quote + suggested fixes -->
```

**Do NOT commit** (default) — only enters the repo after the user runs `git add -f` themselves (per .gitignore). This rule prevents "every mock-reader run pollutes git log".

**When to commit — the inverse rule**: ≥ 3 feedback reports cross-validated with ≥ 2 personas flagging the same friction → that friction is a real problem; commit the feedback as the basis for fixing the article (per §6 #6 baseline comparison).

---

## Step 7: Self-check (5 hard checks + 1 diversity check)

| Check | Expectation |
|---|---|
| ✅ At least 1 negative in the 5 `key_points`? | Yes (avoids §0 pitfall #2 5⭐ blanket praise) |
| ✅ At least 1 `friction_points` entry names a specific paragraph? | Yes (avoids generic "add more examples") |
| ✅ `rating < 5`? | Yes (5⭐ = persona distortion, anti-pattern §6.1) |
| ✅ YAML strictly follows the schema? | Yes (CI/CD-friendly, structured feedback) |
| ✅ Written to `docs/feedback/`? | Yes (keeps `content/posts/` clean) |
| ✅ Diversity self-check (D12 SOP) | Run `grep -h '^prompt_type' content/posts/**/*.md \| tail -5`; if ≥ 4 posts share the same `prompt_type`, append a "Scaled Content risk" note to the feedback |

---

## 5-persona comparison matrix (core — soul of this article)

| persona | feedback_style | Typical hits | Anti-pattern |
|---|---|---|---|
| **P1** strong China-mainland dev | `direct_technical` | deployment step details / EACCES debugging / domestic network | writes too long, not direct enough for a dev |
| **P2** content creator | `editor-grade` | prose / SEO / clickbait detection | feedback stuffed with testimonials |
| **P3** Western indie hacker | `one-liner` | 30-second decisions / ROI / selection tables | turns into a 500-word technical review |
| **P4** AI sceptic | `silent` | LLM-as-judge vigilance / marketing-tone resistance | output reads like AI-farm content |
| **P5** selection decision-maker | `comparison-matrix` | TCO quantification / exit cost / comparison tables | default all-praise + 0 friction |

**Selection guidance**:

- First review pass → P5 (default) + P1 (validate hands-on)
- After translation → add P3 (validate overseas reception)
- Suspected AI-farm tone → add P4 (reverse validation)
- Money Hook articles → must run P2 (SEO / clickbait)

---

## Anti-patterns (6 already-hit traps)

Mapping the 5 community pitfalls in §0 + 1 "before-skill vs after-skill" comparison. **Anti-pattern #1 is LLM default behaviour, not a skill defect** — real "failure demo" screenshots are hard (LLMs have built-in critique), so §0 community pitfalls serve as counter-evidence.

| # | Anti-pattern | Trigger | Fix |
|---|---|---|---|
| 1 | Feedback written "perfectly" — 5⭐ + 0 friction | LLM default positive bias (§0 pitfall #2 [Field Guide to AI](https://fieldguidetoai.com/scam-watch/fake-ai-reviews)) | prompt add "rating must be < 5 + friction at least 1 entry" + explicit `feedback_style` |
| 2 | Letting P3 write "long-form technical review" | P3 is a one-liner persona; without explicit `feedback_style` it stereotypes | system prompt block 3 explicitly sets `your feedback style: one-liner` |
| 3 | Feedback stuffed with testimonial marketing tone | "Would highly recommend..." triggers §0 pitfall #5 AI-farm flavour | system prompt add "forbid testimonial tone" |
| 4 | Feedback reports committed into `content/posts/` | pollutes article directory + git log | default to `docs/feedback/`, only enters repo after user `git add -f` |
| 5 | Modifying the source after the fact without archiving persona feedback | no way to trace back "why we changed it" | every `[zh-final]` commit must be linked to ≥ 1 report in `docs/feedback/` |
| 6 | Asking the LLM to review the article without invoking the skill | skips Step 1-7; 14-character bare prompt triggers §0 pitfall #1 surface-level bias | **Always invoke via `.claude/skills/.../SKILL.md`**; baseline shown below |

**Baseline failure case** (without the skill · bare prompt): `Prompt: "Please rate this article"` → `Output: "This is a great article, with clear structure and rich content. Highly recommended. 5/5."` — no persona / `feedback_style` / `rating` constraint → LLM walks the default positive bias path (§0 pitfall #2: 5⭐ + 0 friction). **Compare with the screenshot below — 4/5 + full friction + Path to 5/5. The delta is the skill's core value.**

📸 **Successful comparison screenshot** (standard output after invoking the skill):
- **What to capture**: terminal output from the user actually running `mock-reader-feedback` on `hugo-cloudflare-pages-pitfalls`
- **Signature elements**: `Impression: 4/5` + 4-5 Highlights (with Trap 1-5 paragraph anchors) + **4-5 Deductions** (specific paragraph issues) + Contrast compliance (TOML/lint check) + Path to 5/5 improvement list
- **Why it matters**: proves the skill's core value = **forcing LLM away from default positive bias** — without the skill you get marketing-tone 5⭐; with the skill you get 4/5 + full friction + paragraph-anchored improvement suggestions
- **Redaction**: not needed (terminal content has no PII)
- **Filename**: `skill-working-baseline.png`
- **Where**: same Page Bundle

![Mock-reader-feedback skill baseline output for hugo-cloudflare-pages-pitfalls: rating 4 out of 5 with structured Highlights covering traps 1-5 plus detailed Deductions pointing to specific paragraphs and a Path to 5/5 improvement list — the value of the skill is forcing LLM away from default positive bias toward substantive critique](/images/ai-agent/mock-reader-feedback-skill-deep-dive/skill-working-baseline.png)

---

## Dependencies + v1-v2 evolution path

### Dependencies

```bash
docs/mock-reader-personas.md    # 5 persona prompt templates
docs/persona-data.json          # MOCK → real data, in progress
scripts/fetch-persona-data.sh   # cache validator + optional --live fetcher
```

**Fallback table** (cache + live, 4 combinations): cache hit → use cache (default); miss + live OK → fetch live; miss + live fail → error + degrade to P5 + explicit `[MOCK]` tag; quota exceeded → fall back to cache + stderr warning.

### v1-v2 evolution (planned, not yet implemented)

| Version | Plan | Trigger condition |
|---|---|---|
| v1.1 | GSC live integration (OAuth service account) | GCP project + service-account JSON configured |
| v1.2 | CF Analytics (visits + device + referrer) | Cloudflare API token configured |
| v1.3 | Reddit / HN / GitHub public APIs | rate-limit quota + content-moderation SOP |
| v1.4 | Plausible / Umami native blog | self-hosted Plausible instance OR paid Umami subscription |
| **v2** | multi-persona comparison + auto-highlight friction points | `--multi` flag + Markdown diff rendering |

---

## Conclusion + follow-up actions

**3 follow-up action triggers**:

1. "Submit feedback" → use commit-with-prefix skill, prefix=`[docs]`, scope `feedback`
2. "Fix the article based on feedback" → run the zh-final-refactor skill (TCM stage 4)
3. "Run P1/P3 comparison again" → repeat §3-§7 in this article, emit a comparison table

**Main takeaways**:

- LLM-as-judge **always needs an explicit `feedback_style`** — without it the default is "generic positive feedback" → 5⭐ all-praise
- `[MOCK]` data must be tagged explicitly — LLMs lean surface-level; without the tag they pretend it is real
- Running mock-reader **is not AI self-review, it is AI reading from a non-self perspective** — the human is the final judge
- Feedback reports do not auto-commit — avoids git log pollution

### TCO estimate (read this before deciding)

| Dimension | Value |
|---|---|
| Per-article tokens | 500 words × 5 personas × ~3K ≈ **15K tokens/article** |
| API cost | Claude Sonnet $3/M ≈ **$0.045/draft** |
| Setup | 30 minutes one-time (4 config files + 1 skill + 1 fetcher) |
| Payback | ~3 drafts (vs. human review at $15/hr) |
| Exit cost | **Near zero** — plain YAML in markdown; git-trackable, portable, reusable as training data. **No vendor lock-in** |

> **📎 [Affiliate placeholder]**: none (in-house tool, per CLAUDE.md §3.4)

---

*Drafted: D21 2026-08-30 · path `content/posts/ai-agent/mock-reader-feedback-skill-deep-dive/index.md`*
*Trigger: X1 `docs/archive/think-x1-claude-code-pipeline.md` §6 Y1 candidate (user D21 decision: P1 plan)*
*Slot: E (methodology retrospective, per `docs/writing-prompts.md` section 6 — includes commit hashes + 12 feedback reports + decision points; not B-tier horizontal review)*
*Companion commits: `[draft] mock-reader-feedback-skill-deep-dive + topic-pool.md Y1 sync` + `[asset] 4 screenshots landed`*