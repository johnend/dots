#!/bin/bash

DIR=$HOME/Pictures/Wallpapers/walls1

WALLS=($(ls "${DIR}"))

RANDOMWALL=${WALLS[ $RANDOM % ${#WALLS[@]} ]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

swww query || swww-daemon 

# Change to random wallpaper in the Pictures directory
swww img "${DIR}"/"${RANDOMWALL}" --transition-fps 60 --transition-type any --transition-duration 3 --resize crop
