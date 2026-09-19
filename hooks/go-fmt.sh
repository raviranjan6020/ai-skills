#!/usr/bin/env bash
# PostToolUse hook (Edit|Write): gofmt any .go file the agent just touched.
# Reads the hook JSON from stdin; exits 0 always so it never blocks the agent.
set -u
file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
case "$file" in
  *.go)
    if [ -f "$file" ] && ! gofmt -l "$file" | grep -q .; then exit 0; fi
    [ -f "$file" ] && gofmt -w "$file" && echo "gofmt: reformatted $file"
    ;;
esac
exit 0
