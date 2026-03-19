#!/bin/bash
set -euo pipefail

# Wrapper script for KMonad layer change notifications.
# Pull a desktop session environment from the running compositor/shell process.

exec 2>>/tmp/kmonad-notify.log
echo "[$(date --iso-8601=seconds)] Called with: $*" >&2

USER_ID=$(id -u)
export XDG_RUNTIME_DIR="/run/user/${USER_ID}"

export_from_process_env() {
  local pid="$1"
  local var_name="$2"
  local value=""

  [ -r "/proc/${pid}/environ" ] || return 1

  value=$(
    tr '\0' '\n' < "/proc/${pid}/environ" | sed -n "s/^${var_name}=//p" | head -n 1
  )

  [ -n "${value}" ] || return 1
  export "${var_name}=${value}"
}

for process_name in plasmashell kwin_wayland gnome-shell sway hyprland; do
  while read -r pid; do
    [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] || export_from_process_env "${pid}" DBUS_SESSION_BUS_ADDRESS || true
    [ -n "${WAYLAND_DISPLAY:-}" ] || export_from_process_env "${pid}" WAYLAND_DISPLAY || true
    [ -n "${DISPLAY:-}" ] || export_from_process_env "${pid}" DISPLAY || true
  done < <(pgrep -u "${USER_ID}" "${process_name}" || true)
done

export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=${XDG_RUNTIME_DIR}/bus}"
export DISPLAY="${DISPLAY:-:0}"

case "${1:-unknown}" in
  base|Base)
    layer_name="Base"
    ;;
  plain|Plain)
    layer_name="Plain"
    ;;
  *)
    layer_name="${1:-Unknown}"
    ;;
esac

echo "DBUS_SESSION_BUS_ADDRESS: ${DBUS_SESSION_BUS_ADDRESS}" >&2
echo "DISPLAY: ${DISPLAY}" >&2
echo "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-}" >&2

notify-send -a "KMonad" -t 2000 -u low "KMonad" "Layer: ${layer_name}"
echo "notify-send exit code: $?" >&2
