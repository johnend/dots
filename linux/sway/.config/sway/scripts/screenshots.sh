#!/bin/bash

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

# Show notification with options
notify-send "Screenshot Taken" "$file" -i "$file"
  # --action="delete=delete" \
  # --action="open=open"

# # Store the filename in /tmp for reference
# echo "$file" > /tmp/last_screenshot

# action_index=$(swaync-client -a)
# echo "Action index output: $action_index" >> ~/swaync_debug.log
# case "$action_index" in
#   "0")
#     action="open"
#     ;;
#   "1")
#     action="delete"
#     ;;
#   "*")
#     action="unknown"
#     ;;
# esac
# echo "Action being processed: $action"
#
# case "$action" in
#   "open")
#     nemo "$file"
#     ;;
#   "delete")
#     rm "$file" && notify-send "Screenshot deleted" "$file"
#     ;;
#   *)
#     notify-send "Action error" "Unknown action: $action"
#     ;;
# esac
