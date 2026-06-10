#!/usr/bin/env bash
# PreToolUse hook (Bash): block `git commit` invocations whose message
# contains a "Co-Authored-By" trailer.
#
# Enforces the global rule in ~/.claude/CLAUDE.md:
#   "Never include any Co-Authored-By trailer in commit messages."
# This overrides Claude Code's built-in default of appending one.
#
# Hook contract: exit 0 = allow; exit 2 = block (stderr fed back to Claude).
set -uo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')

[ -z "$COMMAND" ] && exit 0

# Only inspect commands that actually invoke `git commit`. Match the literal
# token so we don't trip on e.g. `git log --grep=commit`.
if ! printf '%s' "$COMMAND" | grep -qE '(^|[[:space:];&|])git[[:space:]]+commit\b'; then
  exit 0
fi

# Case-insensitive match — variants like "co-authored-by", "Co-authored-By"
# all need to be caught.
if ! printf '%s' "$COMMAND" | grep -qi 'co-authored-by'; then
  exit 0
fi

cat >&2 <<'EOF'
Blocked: `git commit` message contains a "Co-Authored-By" trailer.

Global rule (~/.claude/CLAUDE.md):
  Never include any Co-Authored-By trailer in commit messages — including
  Claude Code's default `Co-Authored-By: Claude ... <noreply@anthropic.com>`.
  Applies to all commits regardless of repo, branch, or context.

Re-issue the commit without the trailer. If you used a heredoc with the
default template, strip the trailing block entirely.
EOF
exit 2
