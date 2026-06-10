#!/usr/bin/env bash
# PreToolUse hook (Bash): block commands that suppress stderr on tools whose
# stderr carries load-bearing diagnostics.
#
# Enforces:
#   - ~/.claude/CLAUDE.md: "Never use 2>/dev/null on commands whose stderr
#     matters for debugging (e.g., gradle, build tools)."
#   - common/.ai/rules/bash-output-suppression.md: gh CLI and
#     `git push|fetch|pull|ls-remote|commit` also flow load-bearing stderr
#     (SSH auth failures, SAML enforcement, hook subprocess failures).
#
# Detects: `2>/dev/null`, `2>&-`, `&>/dev/null`, `>& /dev/null`.
# Triggers only when the command also invokes a known sensitive tool —
# probes like `command -v node >/dev/null 2>&1` stay allowed.
#
# Hook contract: exit 0 = allow; exit 2 = block.
set -uo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')

[ -z "$COMMAND" ] && exit 0

SUPPRESSION_PATTERN='(2>[[:space:]]*/dev/null|2>&-|&>[[:space:]]*/dev/null|>&[[:space:]]*/dev/null)'
if ! printf '%s' "$COMMAND" | grep -qE "$SUPPRESSION_PATTERN"; then
  exit 0
fi

# Build / test / lint tools whose stderr carries load-bearing diagnostics.
BUILD_TOOL_PATTERN='(\./gradlew|[[:space:]]gradle[[:space:]]|^gradle[[:space:]]|[[:space:]]mvn[[:space:]]|^mvn[[:space:]]|[[:space:]]cargo[[:space:]]|^cargo[[:space:]]|go[[:space:]]+(build|test|run|vet)|[[:space:]]tsc[[:space:]]|^tsc[[:space:]]|[[:space:]]tsc$|^tsc$|webpack|vite|next[[:space:]]+(build|dev|start)|nuxt[[:space:]]+(build|dev)|rollup|esbuild|xcodebuild|swift[[:space:]]+(build|test)|[[:space:]]make[[:space:]]|^make[[:space:]]|[[:space:]]cmake[[:space:]]|^cmake[[:space:]]|ninja|(npm|pnpm|bun)[[:space:]]+(run|test|build|start)|yarn[[:space:]]+(run|test|build|tsc|lint|start)|jest|vitest|mocha|pytest|python[[:space:]]+-m[[:space:]]+pytest|eslint|prettier|ruff|mypy|pyright|biome|gradle-)'

# Remote-contact tools whose stderr carries auth / SAML / hook diagnostics.
REMOTE_TOOL_PATTERN='(^|[[:space:];&|])(gh[[:space:]]|git[[:space:]]+(push|fetch|pull|ls-remote|commit)([[:space:]]|$))'

category=""
if printf '%s' "$COMMAND" | grep -qE "$BUILD_TOOL_PATTERN"; then
  category="build"
elif printf '%s' "$COMMAND" | grep -qE "$REMOTE_TOOL_PATTERN"; then
  category="remote"
fi

[ -z "$category" ] && exit 0

if [ "$category" = "build" ]; then
  cat >&2 <<EOF
Blocked: stderr suppression on a build / debug-sensitive command.

Global rule (~/.claude/CLAUDE.md):
  Never use 2>/dev/null on commands whose stderr matters for debugging
  (gradle, mvn, tsc, jest, pytest, eslint, etc.). Errors hide silently and
  waste cycles diagnosing later.

Command:
  $COMMAND

Capture both streams instead — silent on success, last 50 lines on failure:
  output=\$(<cmd> 2>&1); rc=\$?
  [ "\$rc" -ne 0 ] && printf '%s\n' "\$output" | tail -50
EOF
else
  cat >&2 <<EOF
Blocked: stderr suppression on a gh / git remote command.

Rule (common/.ai/rules/bash-output-suppression.md):
  Never suppress stderr on gh CLI or git push|fetch|pull|ls-remote|commit.
  Their stderr is load-bearing — SSH auth failures, SAML enforcement, and
  pre-push/commit hook subprocess failures only appear on stderr.

Command:
  $COMMAND

Run these directly and let output flow through:
  gh pr create --title "\$TITLE" --body "\$BODY"
  git push origin HEAD
EOF
fi
exit 2
