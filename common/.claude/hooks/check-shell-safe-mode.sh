#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): when a bash script is written or edited,
# verify it declares safe-mode flags near the top.
#
# Enforces the global rule in ~/.claude/CLAUDE.md:
#   "Shell scripts: set -euo pipefail, 2-space indent, ..."
#
# Lenient check: requires that some `set -...e...` or `set -...u...` flag
# AND `pipefail` both appear somewhere in the file. This accommodates the
# documented hook-script exception (`set -uo pipefail` without -e) from
# common/.ai/rules/bash-output-suppression.md, while still catching scripts
# with no safe-mode declaration at all.
#
# Hook contract: exit 0 = silent pass; exit 2 = feedback to Claude (the
# write has already happened — this is advisory, not a revert).
set -uo pipefail

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')

[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

FIRST_LINE=$(head -1 "$FILE_PATH" 2>/dev/null || true)

# Decide whether to treat this as a bash script we should check.
is_bash=0
case "$FIRST_LINE" in
  '#!/bin/bash'*|'#!/usr/bin/env bash'*|'#!/usr/bin/bash'*|'#!/bin/sh'*|'#!/usr/bin/env sh'*)
    is_bash=1
    ;;
esac

# .sh extension: default to bash check unless the shebang says zsh.
case "$FILE_PATH" in
  *.sh)
    case "$FIRST_LINE" in
      '#!/bin/zsh'*|'#!/usr/bin/env zsh'*|'#!/usr/bin/zsh'*) ;;
      *) is_bash=1 ;;
    esac
    ;;
esac

[ "$is_bash" -eq 0 ] && exit 0

# Require BOTH a `set -...` flag line that includes `e` or `u`, AND a
# `pipefail` declaration somewhere.
has_safe_flag=0
has_pipefail=0

if grep -qE '^[[:space:]]*set[[:space:]]+-[a-zA-Z]*[eu]' "$FILE_PATH"; then
  has_safe_flag=1
fi
if grep -q 'pipefail' "$FILE_PATH"; then
  has_pipefail=1
fi

if [ "$has_safe_flag" -eq 1 ] && [ "$has_pipefail" -eq 1 ]; then
  exit 0
fi

cat >&2 <<EOF
Advisory: $FILE_PATH is a bash script but is missing safe-mode flags.

Global rule (CLAUDE.md):
  Shell scripts should declare 'set -euo pipefail' near the top so they
  fail fast on errors, unset variables, and pipeline failures.

Add this just after the shebang:
  set -euo pipefail

Exception: hook scripts that need conditional fallback branches may use
'set -uo pipefail' (without -e) — see common/.ai/rules/bash-output-suppression.md.
EOF
exit 2
