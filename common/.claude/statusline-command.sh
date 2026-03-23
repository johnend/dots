#!/bin/bash
# Claude Code status line — mirrors Starship prompt style
# Displays: dir  branch [dirty]  model  context%
# Icons sourced from common/.config/nvim/lua/config/icons.lua (via printf Unicode escapes)

ICON_DIR=$(printf '\xef\x84\x95')        # ui.FolderOpen    U+F115
ICON_BRANCH=$(printf '\xee\x9c\xa5')    # git.Branch       U+E725
ICON_DIRTY=$(printf '\xee\xac\xb2')     # git.FileUnstaged U+EB32
ICON_MODEL=$(printf '\xee\xb0\x9e')      # misc.CoPilot     U+EC1E
ICON_CTX=$(printf '\xf3\xb0\xa7\x91')   # misc.Brain       U+F09D1

input=$(cat)

# ── Directory (truncate to 3 components, collapse $HOME to ~) ──────────────
raw_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
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
cache_file="/tmp/claude-git-$(echo "$raw_dir" | md5 -q 2>/dev/null || echo "$raw_dir" | md5sum | cut -d' ' -f1)"
cache_ttl=5

if git -C "$raw_dir" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  now=$(date +%s)
  # Use cache if it exists and is fresh
  if [ -f "$cache_file" ] && [ $(( now - $(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file") )) -lt $cache_ttl ]; then
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

# ── Model ─────────────────────────────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // ""')

# ── Context usage ─────────────────────────────────────────────────────────
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ── Assemble ──────────────────────────────────────────────────────────────
printf "\033[1;34m%s %s\033[0m" "$ICON_DIR" "$dir"

if [ -n "$branch" ]; then
  printf "  \033[1;32m%s %s%s\033[0m" "$ICON_BRANCH" "$branch" "$branch_flag"
fi

if [ -n "$model" ]; then
  printf "  \033[0;33m%s %s\033[0m" "$ICON_MODEL" "$model"
fi

if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  remaining_int=$((100 - used_int))

  # Build 10-block progress bar (filled = used)
  bar_filled=$(( used_int * 10 / 100 ))
  bar_empty=$(( 10 - bar_filled ))
  bar=""
  for ((i=0; i<bar_filled; i++)); do bar+="█"; done
  for ((i=0; i<bar_empty; i++)); do bar+="░"; done

  if [ "$used_int" -ge 80 ]; then
    printf "  \033[1;31m%s %s %d%%\033[0m" "$ICON_CTX" "$bar" "$used_int"
  elif [ "$used_int" -ge 50 ]; then
    printf "  \033[1;33m%s %s %d%%\033[0m" "$ICON_CTX" "$bar" "$used_int"
  else
    printf "  \033[0;36m%s %s %d%%\033[0m" "$ICON_CTX" "$bar" "$used_int"
  fi
fi
