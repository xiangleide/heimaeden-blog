## Summary

<!-- 1-3 sentences: what does this PR change and why? -->

## Linked issue

<!-- Every PR should reference a GitHub issue. If there isn't one yet, open one first and link it here.
     PRs without a linked issue will be asked to open one before review. -->

- Fixes #<issue_number>
- Or relates to #<issue_number> (explain the relationship in the description)

## Type of change

<!-- Check one — helps reviewers know what to expect. -->

- [ ] Factual correction (typo / wrong version flag / factual inaccuracy)
- [ ] Trivial content fix (broken link / spelling / formatting)
- [ ] New article draft (early review before commit)
- [ ] Documentation update (CLAUDE.md / README.md / docs/)
- [ ] Build / tooling change (scripts / layouts / .github/)

## Hands-on reproduction (REQUIRED for any factual or content PR)

<!-- Per CLAUDE.md §3.8 rule 6: factual claims must have an explicit anchor.
     If your PR changes a fact, command, version number, or recommendation,
     you must show that you ran it yourself. "AI told me so" is not an anchor. -->

- [ ] I reproduced the steps described in the affected post / doc on my own machine.
- [ ] I included the exact command(s) I ran and the output (or a screenshot) below.
- [ ] If the change is purely cosmetic, explain why no repro is needed.

```
<command + output here, or attach screenshot>
```

## Out-of-scope changes

<!-- List anything you intentionally changed but that wasn't strictly required by the linked issue.
     If the list is empty, write "None". -->

## Self-review checklist

<!-- Per CLAUDE.md §3 + §3.8 rule 1 (no first-person fabrication) + rule 6 (no phantom cross-refs). -->

- [ ] I have read the affected file(s) end-to-end before editing.
- [ ] I did not introduce new first-person claims beyond what my own repro / commit history supports.
- [ ] I did not introduce cross-references (AdSense flow / WordFirst flow / commit hashes / etc.) without an explicit anchor in CLAUDE.md / README.md / docs/.
- [ ] All commit hashes referenced are real and present in `git log`.
- [ ] I have run `./scripts/lint-post.sh` (if a content post is touched) and `hugo --gc` locally.
- [ ] I have not included screenshots with visible PII (account numbers, full names, emails). PII screenshots have been redacted via `./scripts/redact-image.sh`.
- [ ] I have not committed a screenshot wider than 1440px (per CLAUDE.md §3.3.2).

## Risk / rollback

<!-- One sentence on how to revert if this PR turns out to be wrong. -->
