#!/bin/bash
set -euo pipefail

layer_arg="${1:-unknown}"

case "${layer_arg}" in
  base|Base)
    layer_name="Base"
    ;;
  plain|Plain)
    layer_name="Plain"
    ;;
  *)
    layer_name="${layer_arg}"
    ;;
esac

case "$(uname -s)" in
  Linux)
    user_id="$(id -u)"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/${user_id}}"
    export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=${XDG_RUNTIME_DIR}/bus}"

    notify-send -a "Kanata" -t 2000 -u low "Kanata" "Layer: ${layer_name}"
    ;;
  Darwin)
    /usr/bin/osascript -e "display notification \"Layer: ${layer_name}\" with title \"Kanata\""
    ;;
esac
