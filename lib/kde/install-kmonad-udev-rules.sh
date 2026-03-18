#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_SOURCE_DIR="${SCRIPT_DIR}/../etc/udev/rules.d"
RULE_NAME="99-kmonad-hi86.rules"
RULE_SOURCE="${RULES_SOURCE_DIR}/${RULE_NAME}"
RULE_DEST="/etc/udev/rules.d/${RULE_NAME}"

if [[ ! -f "${RULE_SOURCE}" ]]; then
  echo "Missing rule file: ${RULE_SOURCE}" >&2
  exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo ${0}" >&2
  exit 1
fi

install -Dm644 "${RULE_SOURCE}" "${RULE_DEST}"
udevadm control --reload-rules

echo "Installed ${RULE_DEST}"
echo "Unplug and replug the BY Tech keyboard to trigger kmonad@hi86.service."
