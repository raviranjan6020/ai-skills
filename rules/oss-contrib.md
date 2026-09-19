# Open-source contribution

- Read `CONTRIBUTING.md`, PR template, and `.github/workflows` before writing code.
  Match their commit format, sign-off (DCO `git commit -s`), and CLA requirements.
- One PR = one concern. Don't bundle a drive-by fix with a feature.
- PR description: what and why, how it was tested (real commands, real output), and any
  caveat honestly stated. Never claim a limitation or result you didn't reproduce.
- Run exactly what CI runs (`make lint`, `make test`) locally before pushing.
- Test-only PRs: don't change production code unless the maintainers ask. If a refactor
  would make the test simpler, mention it as an option in the PR body.
- Respond to review comments by changing the code or explaining, never by silently
  force-pushing over the discussion. Prefer fixup commits until asked to squash.
- Don't @-mention maintainers or ping for review in the first 3 business days.
- Commits are authored by the user only: git's configured `user.name`/`user.email`, no
  `Co-Authored-By` AI trailers, no "Generated with ..." lines in commits or PR bodies.
  Never pass `-c user.email=...` to override the configured identity.
