#!/bin/bash

set -euo pipefail

# Determine screenshot type based on argument
case "$1" in
  fullscreen)
    file="$HOME/Pictures/Screenshots/fullscreen-$(date +'%d-%m-%Y_%H-%M-%S').png"
    grim "$file"  # Fullscreen screenshot
    ;;
  window)
    file="$HOME/Pictures/Screenshots/window-$(date +'%d-%m-%Y_%H-%M-%S').png"
    swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.pid and .visible) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
    slurp | grim -g - "$file"  # Window screenshot
    ;;
  area)
    file="$HOME/Pictures/Screenshots/screenshot-$(date +'%d-%m-%Y_%H-%M-%S').png"
    grim -g "$(slurp)" "$file"  # Area screenshot
    ;;
  clipboard)
    temp_file=$(mktemp /tmp/screenshot-preview-XXXXX.png)
    grim -g "$(slurp)" "$temp_file"
    wl-copy < "$temp_file"
    notify-send "Screenshot copied to clipboard" "Go forth and paste" -i "$temp_file"
    rm "$temp_file"
    exit 0
    ;;
  *)
    notify-send "Error" "Unknown screenshot type"  # If invalid argument is passed
    exit 1
    ;;
esac

# Get the directory containing the screenshot
screenshot_dir=$(dirname "$file")

# Show notification with action buttons and handle response
action=$(notify-send "Screenshot Taken" "$file" \
  -i "$file" \
  --action="delete=Delete" \
  --action="open=Open Folder")

# Handle the selected action
case "$action" in
  delete)
    if rm "$file"; then
      notify-send "Screenshot Deleted" "File removed successfully"
    else
      notify-send "Error" "Failed to delete screenshot"
    fi
    ;;
  open)
    nemo "$screenshot_dir"
    ;;
  *)
    # No action taken (notification dismissed or timed out)
    ;;
esac
