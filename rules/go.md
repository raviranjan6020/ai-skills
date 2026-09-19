---
paths: ["**/*.go", "go.mod", "go.sum"]
inclusion: fileMatch
fileMatchPattern: "**/*.go"
---
# Go

- Run `gofmt` on every file you touch. Run `go vet ./...` and the project's linter
  (`make lint` / `golangci-lint run`) before saying you're done. Lint config in repo wins
  over your preference.
- Wrap errors with context: `fmt.Errorf("doing x: %w", err)`. Never swallow errors silently.
- Tests: table-driven where there are 3+ cases, `t.Helper()` in helpers, `t.Setenv` over
  `os.Setenv`, `t.TempDir()` over manual temp dirs, `t.Parallel()` when subtests are
  independent, `t.Context()` for subprocess/timeouts (Go 1.24+).
- Code that calls `os.Exit` is tested via subprocess re-exec (`exec.Command(os.Args[0],
  "-test.run=^TestHelperProcess$")`). Forward `GOCOVERDIR` to the child or coverage is lost.
- Prefer `errors.Is`/`errors.As` over string matching on errors.
- No `init()` for anything that can be explicit. No package-level mutable state.
- Keep exported surface small. Unexported until a second package needs it.
- Line length: follow the repo's `lll` setting (commonly 120).
