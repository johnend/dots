#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): flag `local foo=$(cmd)` patterns inside
# bash scripts — `local` always returns 0, so the inner command's exit
# status is silently discarded.
#
# Enforces common/.ai/rules/bash-output-suppression.md:
#   "Inside bash functions: local always exits 0, masking the real exit
#    code — declare and assign separately."
#
# Hook contract: exit 0 = silent pass; exit 2 = feedback to Claude (the
# write has already happened — this is advisory, not a revert).
set -uo pipefail

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')

[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

FIRST_LINE=$(head -1 "$FILE_PATH" 2>/dev/null || true)

# Decide whether to treat this as a bash script we should check. `local` in
# zsh has different semantics (its return code does propagate from $(...)
# in some modes), so we deliberately exclude zsh shebangs.
is_bash=0
case "$FIRST_LINE" in
  '#!/bin/bash'*|'#!/usr/bin/env bash'*|'#!/usr/bin/bash'*|'#!/bin/sh'*|'#!/usr/bin/env sh'*)
    is_bash=1
    ;;
esac

case "$FILE_PATH" in
  *.sh)
    case "$FIRST_LINE" in
      '#!/bin/zsh'*|'#!/usr/bin/env zsh'*|'#!/usr/bin/zsh'*) ;;
      *) is_bash=1 ;;
    esac
    ;;
esac

[ "$is_bash" -eq 0 ] && exit 0

# Match `local <name>=$(...)` or `local <name>=`...``, optionally with
# `local -r|-i|-x ... name=...` flag prefixes. Requires `$(` or backtick
# immediately after `=` so quoted strings like `local x="hi"` don't trip.
LOCAL_ASSIGN_PATTERN='^[[:space:]]*local([[:space:]]+-[a-zA-Z]+)*[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*=(\$\(|`)'

hits=$(grep -nE "$LOCAL_ASSIGN_PATTERN" "$FILE_PATH" || true)
[ -z "$hits" ] && exit 0

cat >&2 <<EOF
Advisory: $FILE_PATH combines \`local\` with command substitution.

Rule (common/.ai/rules/bash-output-suppression.md):
  \`local\` always returns 0, so \`local x=\$(cmd)\` discards the inner
  exit status — failures in the substitution become silent. Declare and
  assign on separate lines so \$? reflects the real result:

    local output
    output=\$(cmd 2>&1)
    rc=\$?
    [ "\$rc" -ne 0 ] && { printf '%s\n' "\$output" | tail -20 >&2; return "\$rc"; }

Offending line(s):
$hits
EOF
exit 2
