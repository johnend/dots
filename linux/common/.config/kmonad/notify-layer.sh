#!/bin/bash
# Wrapper script for KMonad layer change notifications
# Ensures proper D-Bus environment for notify-send

# Log for debugging
exec 2>> /tmp/kmonad-notify.log
echo "[$(date)] Called with: $*" >&2

# Get the user's D-Bus session address
USER_ID=$(id -u)

# Try multiple methods to get the correct DBUS address
# Method 1: Check from running KDE/Plasma processes
for pid in $(pgrep -u $USER_ID plasmashell); do
  if [ -f "/proc/$pid/environ" ]; then
    eval "export $(strings /proc/$pid/environ | grep '^DBUS_SESSION_BUS_ADDRESS=')"
    break
  fi
done

# Method 2: Fallback to default
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus"
fi

# Method 3: Try getting WAYLAND_DISPLAY too
for pid in $(pgrep -u $USER_ID plasmashell); do
  if [ -f "/proc/$pid/environ" ]; then
    eval "export $(strings /proc/$pid/environ | grep '^WAYLAND_DISPLAY=')"
    break
  fi
done

export DISPLAY=:0

echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS" >&2
echo "DISPLAY: $DISPLAY" >&2
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY" >&2

# Send notification with the layer name passed as argument
LAYER_NAME="${1:-Unknown}"
notify-send -t 2000 'KMonad' "Layer: ${LAYER_NAME}" -u low
echo "notify-send exit code: $?" >&2
