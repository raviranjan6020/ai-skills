#!/usr/bin/env bash
# Install ai-skills into local agent tools.
#   ./install.sh global            -> Claude Code, Codex, Kiro user-level config
#   ./install.sh project <dir>     -> drop AGENTS.md / .cursor / .kiro / CLAUDE.md into a repo
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

strip_frontmatter() { awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$1"; }

# AGENTS.md + all rules as one file, for tools with no include/rules mechanism.
bundle() {
  cat "$ROOT/AGENTS.md"
  for f in "$ROOT"/rules/*.md; do printf '\n\n'; strip_frontmatter "$f"; done
}

link() { # link <target> <linkpath>  (backs up a real file/dir at linkpath)
  local target=$1 path=$2
  if [ -e "$path" ] && [ ! -L "$path" ]; then mv "$path" "$path.bak.$(date +%s)"; echo "backed up $path"; fi
  ln -sfn "$target" "$path"; echo "linked $path -> $target"
}

install_global() {
  # --- Claude Code ---
  mkdir -p ~/.claude
  link "$ROOT/claude/CLAUDE.md" ~/.claude/CLAUDE.md
  link "$ROOT/rules"            ~/.claude/rules
  link "$ROOT/skills"           ~/.claude/skills
  link "$ROOT/agents"           ~/.claude/agents
  if [ -f ~/.claude/settings.json ]; then
    cp ~/.claude/settings.json ~/.claude/settings.json.bak
    jq -s '.[0] * .[1]' ~/.claude/settings.json "$ROOT/claude/settings.json" > ~/.claude/settings.json.tmp
    mv ~/.claude/settings.json.tmp ~/.claude/settings.json
    echo "merged claude/settings.json into ~/.claude/settings.json (backup: settings.json.bak)"
  else
    cp "$ROOT/claude/settings.json" ~/.claude/settings.json; echo "wrote ~/.claude/settings.json"
  fi

  # --- Codex (reads ~/.codex/AGENTS.md; skills in ~/.codex/skills/<name>) ---
  if [ -d ~/.codex ]; then
    bundle > ~/.codex/AGENTS.md; echo "wrote ~/.codex/AGENTS.md (generated bundle; edit the source in $ROOT)"
    mkdir -p ~/.codex/skills
    for s in "$ROOT"/skills/*/; do link "$s" ~/.codex/skills/"$(basename "$s")"; done
  fi

  # --- Kiro (steering files in ~/.kiro/steering; skills in ~/.kiro/skills/<name>) ---
  if [ -d ~/.kiro ]; then
    mkdir -p ~/.kiro/steering ~/.kiro/skills
    link "$ROOT/AGENTS.md" ~/.kiro/steering/00-agents.md
    for f in "$ROOT"/rules/*.md; do link "$f" ~/.kiro/steering/"$(basename "$f")"; done
    for s in "$ROOT"/skills/*/; do link "$s" ~/.kiro/skills/"$(basename "$s")"; done
  fi
}

install_project() {
  local dir=$1
  [ -d "$dir" ] || { echo "no such dir: $dir" >&2; exit 1; }
  cd "$dir"
  # AGENTS.md: read natively by Codex, Cursor, and (via @import) Claude Code.
  [ -e AGENTS.md ] || { bundle > AGENTS.md; echo "wrote AGENTS.md"; }
  [ -e CLAUDE.md ] || { printf '@AGENTS.md\n' > CLAUDE.md; echo "wrote CLAUDE.md (imports AGENTS.md)"; }
  mkdir -p .cursor/rules .kiro/steering
  [ -e .cursor/rules/ai-skills.mdc ] || {
    { printf -- '---\ndescription: ai-skills agent rules\nalwaysApply: true\n---\n'; bundle; } > .cursor/rules/ai-skills.mdc
    echo "wrote .cursor/rules/ai-skills.mdc"; }
  [ -e .kiro/steering/00-agents.md ] || { cp "$ROOT/AGENTS.md" .kiro/steering/00-agents.md; echo "wrote .kiro/steering/00-agents.md"; }
  echo "note: if this is someone else's repo, keep these files local (add to .git/info/exclude)."
}

case "${1:-}" in
  global)  install_global ;;
  project) install_project "${2:?usage: install.sh project <dir>}" ;;
  *) sed -n '2,4p' "$0"; exit 1 ;;
esac
