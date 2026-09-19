---
name: oss-pr
description: Prepare an open-source pull request end to end - read contributing docs, run what CI runs, verify every claim, draft the PR body. Use when the user says "open a PR", "prepare PR", "/oss-pr", or is about to push a branch to an upstream repo.
---

# OSS PR preparation

Follow these steps in order. Don't skip a verify step because it "looks fine".

1. **Read the rules of the house.** `CONTRIBUTING.md`, `.github/PULL_REQUEST_TEMPLATE*`,
   `.github/workflows/*`, `Makefile` lint/test targets, `OWNERS` if present.
   Note: commit format, DCO/CLA, required PR body sections.
2. **Scope check.** `git diff main...HEAD --stat`. Every file changed must trace to the
   PR's one concern. Unrelated changes → separate branch.
3. **Run what CI runs.** Exactly the same commands (`make lint`, `make test`, or what the
   workflow file shows). Paste the tail of the output. Fix failures before continuing.
4. **Verify claims.** For every factual statement you plan to put in the PR body
   (coverage %, "all branches covered", "no behaviour change", timings): run the command
   that proves it and record the number. See `rules/verification.md`.
5. **Draft PR body** using the repo's template. Sections: what/why, how tested (commands +
   real output), caveats (honest), `release-note` block if the repo uses one.
6. **Commit hygiene.** Sign-off if DCO required. Conventional/subsystem prefix if the repo
   uses one (check `git log --oneline -20`). Squash WIP commits.
7. **Show the user** the diff stat, the test/lint output, and the PR body. Do not push or
   open the PR until they confirm.
