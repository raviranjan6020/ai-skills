# ai-skills

My rules, skills, hooks, and permissions for coding agents — one source, installed into
Claude Code, Codex, Kiro, and Cursor.

```
AGENTS.md            core behaviour (tool-agnostic; Karpathy 4 rules + verify + security)
rules/               topic rules: verification, security, go, oss-contrib, k8s-sigs
skills/<name>/       Agent Skills (SKILL.md) — /oss-pr, /go-review
agents/              Claude Code subagents — security-reviewer (read-only)
hooks/               shell hooks — go-fmt.sh (gofmt after every Edit/Write of a .go file)
claude/              Claude Code specifics: CLAUDE.md (imports AGENTS.md), settings.json (permissions + hooks)
install.sh           symlink / generate into ~/.claude, ~/.codex, ~/.kiro, or a project
```

## Install

```sh
git clone git@github.com:raviranjan6020/ai-skills.git ~/ai-skills
~/ai-skills/install.sh global          # user-level: Claude Code, Codex, Kiro
~/ai-skills/install.sh project ~/repo  # per-repo: AGENTS.md, CLAUDE.md, .cursor/rules, .kiro/steering
```

`global` symlinks, so editing this repo updates every tool immediately (Codex's
`~/.codex/AGENTS.md` is a generated bundle — re-run `install.sh global` after editing).

## Which tool reads what

| Tool | Rules | Skills | Hooks / permissions |
|---|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` → `@AGENTS.md`; `~/.claude/rules/*.md` (auto) | `~/.claude/skills/` | `~/.claude/settings.json` |
| Codex | `~/.codex/AGENTS.md` (bundle) or project `AGENTS.md` | `~/.codex/skills/` | n/a (use `config.toml` sandbox) |
| Kiro | `~/.kiro/steering/*.md`, project `.kiro/steering/` | `~/.kiro/skills/` | n/a |
| Cursor | project `AGENTS.md` (native) + `.cursor/rules/*.mdc` | `.cursor/skills/` (unverified) | n/a |

Kiro user-level steering path and Cursor skills path are from docs, not tested here — fix
the script if your version differs.

## Philosophy

- **Rules = advice, hooks/permissions = enforcement.** Anything that must never happen
  (secrets, force-push, `rm -rf`) goes in `claude/settings.json`, not prose.
- **Short beats complete.** A 300-line CLAUDE.md gets skimmed. Add a line only after an
  agent actually got something wrong.
- **Borrowed vs. mine.** `AGENTS.md` §1–4 are from
  [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT).
  Everything in `rules/` is from my own mistakes.

## Adding a rule

1. Something went wrong in a session.
2. One or two lines in the matching `rules/*.md` — what to do, not a story.
3. Commit with the session's lesson in the message.

## Branch protection

`main` on this repo has a GitHub ruleset (`protect-main`): PR required, force-push and
deletion blocked, no bypass. Reproduce on any repo:

```sh
gh api -X POST repos/<owner>/<repo>/rulesets --input - <<'JSON'
{"name":"protect-main","target":"branch","enforcement":"active","bypass_actors":[],
 "conditions":{"ref_name":{"include":["~DEFAULT_BRANCH"],"exclude":[]}},
 "rules":[{"type":"deletion"},{"type":"non_fast_forward"},
  {"type":"pull_request","parameters":{"required_approving_review_count":0,
   "dismiss_stale_reviews_on_push":true,"require_code_owner_review":false,
   "require_last_push_approval":false,"required_review_thread_resolution":true,
   "allowed_merge_methods":["squash","rebase"]}}]}
JSON
```

Agent side, `claude/settings.json` denies `git push` to `main`/`master` and to `upstream`.
