#!/bin/bash
set -euo pipefail

# GloomStalker Integration Test Script
# Tests various scenarios to validate token savings and accuracy.
#
# Usage: test-integration.sh [mobile-app-dir] [web-app-dir]
# Project folders are arguments so no work paths live in this public repo;
# without them the tests run from /tmp and exercise the fallback path.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOBILE_APP_DIR="${1:-/tmp}"
WEB_APP_DIR="${2:-/tmp}"

run_test() {
  local title="$1"
  local task="$2"
  local project_dir="$3"

  printf '%s\n' "$title"
  printf "Task: '%s'\n" "$task"
  printf '%s\n' "--------------------------------------------------"
  (cd "$project_dir" && node "$SCRIPT_DIR/cli.js" "$task" --debug) || printf 'Test failed: %s\n' "$title"
  printf '\n\n'
}

printf '%s\n' "==================================================" "GloomStalker Integration Test" "==================================================" ""

run_test "Test 1: Simple test task" "Add a test for login form" "$MOBILE_APP_DIR"
run_test "Test 2: Complex Redux task" "Add Redux state for API auth with tests" "$MOBILE_APP_DIR"
run_test "Test 3: Styling task" "Update Fela theme colors" "$MOBILE_APP_DIR"
run_test "Test 4: Web app component task" "Create a button component with styled-components" "$WEB_APP_DIR"
run_test "Test 5: Unknown project (graceful fallback)" "Add a test" "/tmp"

printf '%s\n' "==================================================" "Integration Test Complete" "==================================================" ""
printf '%s\n' "Summary:" \
  "- Test 1: Mobile app test task (should load testing patterns)" \
  "- Test 2: Complex Redux task (should load state + API + testing)" \
  "- Test 3: Styling task (should load Fela patterns)" \
  "- Test 4: Web app component (should load React + styled-components)" \
  "- Test 5: Unknown project (should load core patterns only)" \
  "" \
  "Expected token savings: 40-60% on average"
