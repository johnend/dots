#!/bin/bash
# Claude Code status line — mirrors Starship prompt style
# Displays: dir  branch [dirty]  model  cache countdown  context bar  credits bar
# Icons are Nerd Font glyphs (via printf Unicode escapes); most mirror common/.config/nvim/lua/config/icons.lua

# No -e: optional lookups (git, jq fields, keychain) are expected to fail and fall through
set -uo pipefail

ICON_DIR=$(printf '\xef\x84\x95')        # ui.FolderOpen    U+F115
ICON_BRANCH=$(printf '\xee\x9c\xa5')    # git.Branch       U+E725
ICON_DIRTY=$(printf '\xee\xac\xb2')     # git.FileUnstaged U+EB32
ICON_MODEL=$(printf '\xee\xb0\x9e')      # misc.CoPilot     U+EC1E
ICON_CTX=$(printf '\xf3\xb0\xa7\x91')   # misc.Brain       U+F09D1
ICON_CACHE=$(printf '\xf3\xb0\x85\x90') # md-clock-outline U+F0150
ICON_CREDITS=$(printf '\xf3\xb0\x87\x81') # md-currency-usd U+F01C1

BAR_STEPS=5
GIT_CACHE_TTL_SECONDS=5
USAGE_CACHE="${TMPDIR:-/tmp}/claude-statusline-usage.pct"
USAGE_ATTEMPT="${USAGE_CACHE}.attempt"
USAGE_MAX_AGE=300
USAGE_STALE_AFTER=1800

input=$(cat)
now=$(date +%s)

# ── Extract all fields in one jq pass (unit separator keeps empty fields) ──
# Pre-set so empty or invalid stdin can't trip set -u
raw_dir="" model="" used_pct="" cache_present="" cache_warm=""
prompt_cache_ttl="" cache_expires="" cache_recache=""
IFS=$'\x1f' read -r raw_dir model used_pct cache_present cache_warm \
  prompt_cache_ttl cache_expires cache_recache < <(
  printf '%s' "$input" | jq -r '[
    (.workspace.current_dir // .cwd // ""),
    (.model.display_name // ""),
    (.context_window.used_percentage | if . == null then "" else round end),
    (.prompt_cache != null),
    (.prompt_cache.warm // false),
    (.prompt_cache.ttl // ""),
    (.prompt_cache.expires_at | if . == null then "" else floor end),
    (.prompt_cache.recache_tokens_if_cold | if . == null then "" else round end)
  ] | map(tostring) | join("\u001f")'
)

# ── Helpers ───────────────────────────────────────────────────────────────
# Seconds since a file was modified; large value when missing
file_age() {
  local modified
  # A failed stat probe can still write to stdout.
  if ! modified=$(stat -f %m "$1" 2>/dev/null); then
    modified=$(stat -c %Y "$1" 2>/dev/null) || { echo 999999; return; }
  fi
  if [[ ! "$modified" =~ ^[0-9]+$ ]]; then
    echo 999999
    return
  fi
  echo $(( now - modified ))
}

color_for_pct() {
  if [ "$1" -ge 80 ]; then echo "1;31"
  elif [ "$1" -ge 50 ]; then echo "1;33"
  else echo "0;36"
  fi
}

# 5-dot bar; a partly filled dot rounds to the nearest half (○ ◐ ●)
render_bar() {
  local pct=$1 bar="" step full remainder
  [ "$pct" -gt 100 ] && pct=100
  [ "$pct" -lt 0 ] && pct=0
  full=$(( pct * BAR_STEPS / 100 ))
  remainder=$(( pct * BAR_STEPS % 100 ))
  for ((step = 0; step < full; step++)); do bar+="●"; done
  if [ "$full" -lt "$BAR_STEPS" ]; then
    if   [ "$remainder" -lt 25 ]; then bar+="○"
    elif [ "$remainder" -lt 75 ]; then bar+="◐"
    else bar+="●"
    fi
    for ((step = full + 1; step < BAR_STEPS; step++)); do bar+="○"; done
  fi
  printf '%s' "$bar"
}

print_bar_segment() {
  local icon=$1 pct=$2 color
  color=$(color_for_pct "$pct")
  printf "  \033[%sm%s %s %d%%\033[0m" "$color" "$icon" "$(render_bar "$pct")" "$pct"
}

# Undocumented endpoint (same source as /usage)
refresh_usage() {
  local token tmp
  # Credits lookup requires the macOS Keychain.
  [[ "$(uname -s)" == Darwin ]] || return 1
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
    | jq -r '.claudeAiOauth.accessToken // empty') || return 1
  [ -n "$token" ] || return 1
  tmp=$(mktemp "${USAGE_CACHE}.XXXXXX") || return 1
  # Token goes to curl via config on stdin so it never appears in the process list or on disk
  if printf 'header = "Authorization: Bearer %s"\nheader = "anthropic-beta: oauth-2025-04-20"\n' "$token" \
    | curl -sf --max-time 5 -K - https://api.anthropic.com/api/oauth/usage \
    | jq -r '
        if (.spend.used.amount_minor != null and (.spend.limit.amount_minor // 0) > 0) then
          .spend.used.amount_minor * 100 / .spend.limit.amount_minor
        elif (.extra_usage.used_credits != null and (.extra_usage.monthly_limit // 0) > 0) then
          .extra_usage.used_credits * 100 / .extra_usage.monthly_limit
        else empty end | round' > "$tmp" && [ -s "$tmp" ]; then
    mv "$tmp" "$USAGE_CACHE"
  else
    rm -f "$tmp"
  fi
}

# ── Directory (truncate to 3 components, collapse $HOME to ~) ──────────────
home_dir="$HOME"
dir="${raw_dir/#$home_dir/~}"

# Keep at most 3 path components
component_count=$(echo "$dir" | tr -cd '/' | wc -c)
if [ "$component_count" -gt 3 ]; then
  dir="../$(echo "$dir" | rev | cut -d'/' -f1-3 | rev)"
fi

# ── Git branch + dirty flag (cached 5s per directory) ─────────────────────
branch=""
branch_flag=""
cache_file="${TMPDIR:-/tmp}/claude-git-$(echo "$raw_dir" | md5 -q 2>/dev/null || echo "$raw_dir" | md5sum | cut -d' ' -f1)"

if git -C "$raw_dir" rev-parse --is-inside-work-tree &>/dev/null; then
  # Use cache if it exists and is fresh
  if [ -f "$cache_file" ] && [ "$(file_age "$cache_file")" -lt "$GIT_CACHE_TTL_SECONDS" ]; then
    cached=$(cat "$cache_file")
    branch="${cached%%|*}"
    branch_flag="${cached##*|}"
  else
    branch=$(git -C "$raw_dir" branch --show-current 2>/dev/null)
    dirty=$(git -C "$raw_dir" status --porcelain --ignore-submodules 2>/dev/null)
    [ -n "$dirty" ] && branch_flag=" $ICON_DIRTY" || branch_flag=""
    printf '%s|%s' "$branch" "$branch_flag" > "$cache_file"
  fi
fi

# ── Credits: render from cache, refresh in the background at most every 5m ─
if [ "$(file_age "$USAGE_ATTEMPT")" -ge "$USAGE_MAX_AGE" ]; then
  touch "$USAGE_ATTEMPT"
  # Detached with closed stdio so Claude Code never waits on the network
  ( refresh_usage ) </dev/null >/dev/null 2>&1 &
  disown
fi
# Hide rather than show a stale figure when fetches keep failing
credits_pct=""
if [ -s "$USAGE_CACHE" ] && [ "$(file_age "$USAGE_CACHE")" -lt "$USAGE_STALE_AFTER" ]; then
  read -r credits_pct < "$USAGE_CACHE"
fi

# ── Assemble ──────────────────────────────────────────────────────────────
printf "\033[1;34m%s %s\033[0m" "$ICON_DIR" "$dir"

if [ -n "$branch" ]; then
  printf "  \033[1;32m%s %s%s\033[0m" "$ICON_BRANCH" "$branch" "$branch_flag"
fi

if [ -n "$model" ]; then
  printf "  \033[0;33m%s %s\033[0m" "$ICON_MODEL" "$model"
fi

# Prompt cache countdown; a cold cache means the next turn re-writes the whole prefix
if [ "$cache_present" = "true" ]; then
  if [ "$cache_warm" = "true" ] && [ -n "$cache_expires" ] && [ "$cache_expires" -gt "$now" ]; then
    remaining=$(( cache_expires - now ))
    case "$prompt_cache_ttl" in
      5m) ttl_seconds=300 ;;
      1h) ttl_seconds=3600 ;;
      *)  ttl_seconds=0 ;;
    esac
    if [ "$remaining" -ge 60 ]; then label="$(( remaining / 60 ))m"; else label="${remaining}s"; fi
    color="0;32"
    [ $(( remaining * 5 )) -lt "$ttl_seconds" ] && color="1;33"
  else
    label="cold"
    [ -n "$cache_recache" ] && label+=" ~$(( (cache_recache + 500) / 1000 ))k"
    color="1;31"
  fi
  printf "  \033[%sm%s %s\033[0m" "$color" "$ICON_CACHE" "$label"
fi

if [ -n "$used_pct" ]; then
  print_bar_segment "$ICON_CTX" "$used_pct"
fi

if [[ "$credits_pct" =~ ^[0-9]+$ ]]; then
  print_bar_segment "$ICON_CREDITS" "$credits_pct"
fi
