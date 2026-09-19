---
name: go-review
description: Review a Go PR or diff locally - checkout, run tests/race/vet/lint/coverage, then give severity-ranked findings. Use when the user says "review this PR", "review my Go diff", or "/go-review".
---

# Go PR review

1. `gh pr checkout <n>` (or use the current branch). `git diff main...HEAD`.
2. Run, in order, and keep the output:
   - `go build ./...`
   - `go vet ./<changed pkgs>`
   - `go test -race -count=1 ./<changed pkgs>`
   - `go test -coverprofile=cover.out ./<changed pkgs> && go tool cover -func=cover.out`
   - repo linter (`make lint`, or `golangci-lint run ./...` with the repo's config)
3. Read the changed code and its callers. For tests, read the code under test.
4. Report findings ranked: 🔴 blocks merge (CI fails, bug, security) → 🟠 wrong claim or
   missing case → 🟡 suggestion → nit. One line each: `file:line — problem — fix`.
5. Cross-check the PR description against what you measured. Flag any mismatch
   explicitly; wrong descriptions cost more reviewer trust than wrong code.
6. State what is fine. Reviewer needs to know what you checked and cleared.
7. Offer to apply fixes; don't apply without a yes.
