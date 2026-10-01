#!/usr/bin/env bash
# UserPromptSubmit hook (Claude Code and Codex share the same `.prompt` field).
# When my prompt reads like a correction, remind the agent to record the lesson.
# Silent otherwise: stdout from this event is injected as context, so it must
# stay empty on the common path.
set -uo pipefail

INPUT=$(cat)
PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // ""' 2>/dev/null || true)

[ -z "$PROMPT" ] && exit 0

# Anchored or phrase-level patterns only; a bare "no" or "actually" mid-sentence
# is too common in normal requests to be a useful signal.
CORRECTION_PATTERN='^(no|nope|wrong|stop)[,.!]|that.?s (wrong|not (right|what i))|not what i (asked|meant|wanted)|i (said|told you|already said)|you (missed|forgot|ignored)|why did you|don.?t (do|guess|assume)|again[,.]? (you|it)|i meant'

if printf '%s' "$PROMPT" | rg -qi -e "$CORRECTION_PATTERN"; then
  printf '%s\n' "This prompt looks like a correction. After addressing it, if the lesson generalises beyond this task, record it per the Applied Learning rule (or run the retro skill) and say what you recorded."
fi

exit 0
