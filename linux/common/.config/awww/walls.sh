#!/bin/bash

DIR=$HOME/Pictures/walls

WALLS=($(ls "${DIR}"))

RANDOMWALL=${WALLS[$RANDOM % ${#WALLS[@]}]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

awww query || awww-daemon

# Change to random wallpaper in the Pictures directory
awww img "${DIR}"/"${RANDOMWALL}" --transition-fps 60 --transition-type any --transition-duration 3 --resize crop
"$HOME/.config/awww/sync-cache.sh"
