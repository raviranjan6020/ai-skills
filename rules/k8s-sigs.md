# kubernetes / kubernetes-sigs repos

- Prow, not GitHub Actions, gates merges. First-time contributors need a member to
  comment `/ok-to-test`. Merge needs `lgtm` + `approved` labels; tide merges.
- PR body must include a `release-note` block. `NONE` for tests/docs/refactors.
- CLA: EasyCLA check must pass (already done for raviranjan6020).
- Copyright header on every new `.go` file (copy from a sibling file, keep the year).
- `make lint` uses pinned golangci-lint from `Makefile` (`GOLANGCI_LINT_VERSION`); use
  that, not a globally installed one.
- Useful bot commands: `/retest`, `/assign @user`, `/kind cleanup|bug|feature`,
  `/hold` and `/hold cancel`.
- Envtest-based tests need `KUBEBUILDER_ASSETS`; `make test` sets it up.
