!#/bin/bash

# Show scratchpad
swaymsg 'scratchpad show'

# Wait
sleep 0.1

# Float, resize and center focused window
swaymsg '[con_id=__focused__] floating enable, resize set 1800 1000, move position center'
