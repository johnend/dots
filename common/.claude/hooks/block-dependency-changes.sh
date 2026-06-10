#!/usr/bin/env bash
# PreToolUse hook (Bash): block package-manager commands that add, remove,
# upgrade, or otherwise mutate dependencies — across npm, pnpm, bun, pip,
# poetry, cargo, and bundle.
#
# Enforces the global rule in ~/.claude/CLAUDE.md:
#   "Never modify dependencies without explicit confirmation"
#
# Allowed (do NOT block):
#   - Bare lockfile installs: `npm install`, `npm ci`, `pnpm install`,
#     `bun install`
#   - Script runs:           `npm run X`, `npm test`, `pnpm run X`, etc.
#   - Lockfile / editable pip: `pip install -r ...`, `pip install -e .`
#
# `yarn add|remove|upgrade` is already blocked via settings.json deny list;
# this hook extends coverage to the other managers.
#
# Hook contract: exit 0 = allow; exit 2 = block.
set -uo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')

[ -z "$COMMAND" ] && exit 0

# Normalise: prepend a separator so the start of the command matches the same
# regex anchor as later chained commands, and convert newlines to `;` so each
# logical command is treated independently.
NORM=$(printf '; %s' "$COMMAND" | tr '\n' ';')

block() {
  local reason="$1"
  cat >&2 <<EOF
Blocked: command modifies dependencies ($reason).

Global rule (~/.claude/CLAUDE.md):
  Never modify dependencies without explicit confirmation. Lockfile installs
  and script runs are fine; adding, removing, or upgrading packages requires
  explicit user approval first.

Command:
  $COMMAND

If the user has already approved this dependency change, ask them to disable
this hook for the session or run the command outside Claude Code.
EOF
  exit 2
}

# npm / pnpm / bun: `install` or `i` followed by a positional package arg.
# Allows bare `npm install`, `npm install --foo` (flags only), and `npm ci`.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*(npm|pnpm|bun)[[:space:]]+(install|i)([[:space:]]+-{1,2}[^[:space:]]+)*[[:space:]]+[^-[:space:]]'; then
  block "npm/pnpm/bun install <pkg>"
fi

# npm / pnpm / bun: subcommands that always mutate deps.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*(npm|pnpm|bun)[[:space:]]+(add|remove|uninstall|un|rm|update|upgrade)\b'; then
  block "npm/pnpm/bun dependency change"
fi

# pip / pip3 install — block unless it's `-r <file>` or `-e <path>`.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*(pip|pip3)[[:space:]]+install\b'; then
  if ! printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*(pip|pip3)[[:space:]]+install[[:space:]]+(-r|--requirement|-e|--editable)\b'; then
    block "pip install <pkg>"
  fi
fi

# pip / pip3 uninstall.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*(pip|pip3)[[:space:]]+uninstall\b'; then
  block "pip uninstall"
fi

# poetry add / remove / update.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*poetry[[:space:]]+(add|remove|update)\b'; then
  block "poetry dependency change"
fi

# cargo add / remove / rm / update.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*cargo[[:space:]]+(add|remove|rm|update)\b'; then
  block "cargo dependency change"
fi

# bundle add / remove / update.
if printf '%s' "$NORM" | grep -qE '[;&|][[:space:]]*bundle[[:space:]]+(add|remove|update)\b'; then
  block "bundle dependency change"
fi

exit 0
