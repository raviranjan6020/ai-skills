# ai-skills

Rules, skills, hooks, and permissions for coding agents. One source, installed into Claude Code, Codex, Kiro, and Cursor.

## Layout

| Path | What |
|---|---|
| `AGENTS.md` | Core rules, tool agnostic. Sections 1 to 4 adapted from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT). Sections 5 and 6 are mine. |
| `rules/` | Topic rules: verification, security, go, oss-contrib, k8s-sigs |
| `skills/` | Agent Skills: `oss-pr`, `go-review`, `docs-writing` |
| `agents/` | Claude Code subagents: `security-reviewer` (read only) |
| `hooks/go-fmt.sh` | Runs gofmt after every Edit or Write of a `.go` file |
| `claude/` | Claude Code only: `CLAUDE.md` (imports `AGENTS.md`), `settings.json` (permissions, hook, no AI attribution) |
| `install.sh` | Links or generates config for each tool |
| `.claude-plugin/` | Manifest so the repo also installs as a Claude Code plugin |

## Install

```sh
git clone git@github.com:raviranjan6020/ai-skills.git ~/ai-skills
~/ai-skills/install.sh global
```

`global` symlinks into `~/.claude`, `~/.codex`, `~/.kiro`. Edits in this repo apply at once, except `~/.codex/AGENTS.md`, which is a generated bundle. Re run `install.sh global` after editing rules.

Per repo:

```sh
~/ai-skills/install.sh project ~/path/to/repo
```

Writes `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/ai-skills.mdc`, `.kiro/steering/00-agents.md`. Skips files that exist. In someone else's repo, add them to `.git/info/exclude`.

As a Claude Code plugin (skills and agent only, no rules or permissions):

```
/plugin marketplace add raviranjan6020/ai-skills
/plugin install ai-skills
```

## Verify

Shell:

```sh
ls -la ~/.claude | grep -E 'CLAUDE|rules|skills|agents'
jq '{attribution, deny: .permissions.deny, hooks}' ~/.claude/settings.json
claude doctor
ls ~/.codex/skills ~/.kiro/skills ~/.kiro/steering
head -3 ~/.codex/AGENTS.md
```

Inside a Claude Code session:

```
/context        CLAUDE.md, rules, skills, agents loaded
/skills         oss-pr, go-review, docs-writing listed
/hooks          PostToolUse Edit|Write shows go-fmt.sh
/permissions    deny list shows git push to main and secret paths
/status         settings sources in effect
```

Test the hook: ask Claude to write a badly formatted `.go` file. The reply includes `gofmt: reformatted <file>`.

Test the deny rule: ask Claude to run `git push origin main`. It is refused before running.

Codex and Kiro: open a session and ask "what rules are you following". The answer should mention verification and security rules. Kiro user level steering path and Cursor `.cursor/skills` are from docs, not tested here.

## Which tool reads what

| Tool | Rules | Skills | Enforcement |
|---|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` imports `AGENTS.md`. `~/.claude/rules/*.md` load by path glob | `~/.claude/skills/` | `~/.claude/settings.json` |
| Codex | `~/.codex/AGENTS.md` bundle, or project `AGENTS.md` | `~/.codex/skills/` | none yet |
| Kiro | `~/.kiro/steering/*.md`, or project `.kiro/steering/` | `~/.kiro/skills/` | none |
| Cursor | project `AGENTS.md` and `.cursor/rules/*.mdc` | `.cursor/skills/` (untested) | none |

Rules are advice. Permissions and hooks are enforced. Anything that must never happen belongs in `claude/settings.json`.

## Adding a rule

An agent got something wrong. Add one or two lines to the matching `rules/*.md`. Commit with the lesson in the message. Keep files short. A 300 line rules file gets skimmed.
