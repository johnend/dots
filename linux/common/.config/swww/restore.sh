#!/usr/bin/bash
set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/swww"
STABLE_CACHE_DIR="$CACHE_DIR/by-id"

mkdir -p "$STABLE_CACHE_DIR"

cache_path_for_identity() {
  local identity="$1"
  local stable_key
  stable_key="$(printf '%s' "$identity" | sha1sum | cut -d' ' -f1)"
  printf '%s/%s' "$STABLE_CACHE_DIR" "$stable_key"
}

extract_filter() {
  tr '\0' '\n' < "$1" | sed -n '2p'
}

extract_image() {
  tr '\0' '\n' < "$1" | sed -n '3p'
}

restore_output() {
  local name="$1"
  local cache_file="$2"
  local filter image

  [[ -f "$cache_file" ]] || return 1
  filter="$(extract_filter "$cache_file")"
  image="$(extract_image "$cache_file")"
  [[ -n "$image" && -f "$image" ]] || return 1

  swww img -o "$name" -f "${filter:-Lanczos3}" "$image" --transition-type none >/dev/null
}

swaymsg -t get_outputs | jq -r '.[] | select(.active) | @base64' | while IFS= read -r encoded; do
  output_json="$(printf '%s' "$encoded" | base64 -d)"
  name="$(printf '%s' "$output_json" | jq -r '.name')"
  make="$(printf '%s' "$output_json" | jq -r '.make // "Unknown"')"
  model="$(printf '%s' "$output_json" | jq -r '.model // "Unknown"')"
  serial="$(printf '%s' "$output_json" | jq -r '.serial // "Unknown"')"
  identity="$make $model $serial"

  stable_cache="$(cache_path_for_identity "$identity")"
  name_cache="$CACHE_DIR/$name"

  if restore_output "$name" "$stable_cache"; then
    continue
  fi

  if restore_output "$name" "$name_cache"; then
    cp "$name_cache" "$stable_cache"
    continue
  fi

  case "$identity" in
    "Apple Computer Inc Color LCD Unknown")
      for alias in eDP-1 eDP-2; do
        alias_cache="$CACHE_DIR/$alias"
        if restore_output "$name" "$alias_cache"; then
          cp "$alias_cache" "$stable_cache"
          break
        fi
      done
      ;;
  esac
done
