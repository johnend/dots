#!/bin/bash

# Check if Spotify is running
if pgrep -x "spotify" > /dev/null; then
    # Spotify is running, send Play/Pause command
    playerctl play-pause
else
    # Spotify is not running, launch it
    spotify &
fi
