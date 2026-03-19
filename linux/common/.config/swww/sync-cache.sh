#!/usr/bin/bash
set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/swww"
STABLE_CACHE_DIR="$CACHE_DIR/by-id"

mkdir -p "$STABLE_CACHE_DIR"

swaymsg -t get_outputs | jq -r '.[] | select(.active) | @base64' | while IFS= read -r encoded; do
  output_json="$(printf '%s' "$encoded" | base64 -d)"
  name="$(printf '%s' "$output_json" | jq -r '.name')"
  make="$(printf '%s' "$output_json" | jq -r '.make // "Unknown"')"
  model="$(printf '%s' "$output_json" | jq -r '.model // "Unknown"')"
  serial="$(printf '%s' "$output_json" | jq -r '.serial // "Unknown"')"
  identity="$make $model $serial"

  source_cache="$CACHE_DIR/$name"
  [[ -f "$source_cache" ]] || continue

  stable_key="$(printf '%s' "$identity" | sha1sum | cut -d' ' -f1)"
  cp "$source_cache" "$STABLE_CACHE_DIR/$stable_key"
done
