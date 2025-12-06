#!/bin/zsh

INTERNAL_KB_ID="1452:610:Apple_Inc._Apple_Internal_Keyboard_/_Trackpad"

CURRENT_STATE=$(swaymsg -t get_inputs | jq -r ".[] | select(.identifier == \"$INTERNAL_KB_ID\") | .libinput.send_events")

# Set a constant ID for replacement
NOTIF_ID=1337

if [[ "$CURRENT_STATE" == "enabled" ]]; then
    swaymsg input "$INTERNAL_KB_ID" events disabled
    notify-send -r $NOTIF_ID -i system-run "Internal Keyboard" "Disabled"
else
    swaymsg input "$INTERNAL_KB_ID" events enabled
    notify-send -r $NOTIF_ID -i system-run "Internal Keyboard" "Enabled"
fi
