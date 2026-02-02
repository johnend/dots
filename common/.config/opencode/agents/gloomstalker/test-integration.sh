#!/bin/bash

# GloomStalker Integration Test Script
# Tests various scenarios to validate token savings and accuracy

echo "=================================================="
echo "GloomStalker Integration Test"
echo "=================================================="
echo ""

# Test 1: Simple test task
echo "Test 1: Simple test task"
echo "Task: 'Add a test for login form'"
echo "--------------------------------------------------"
cd ~/Developer/fanduel/sportsbook 2>/dev/null || cd /tmp
node ~/.config/opencode/agents/gloomstalker/hook.ts "Add a test for login form" --debug
echo ""
echo ""

# Test 2: Complex Redux task
echo "Test 2: Complex Redux task"
echo "Task: 'Add Redux state for API auth with tests'"
echo "--------------------------------------------------"
cd ~/Developer/fanduel/sportsbook 2>/dev/null || cd /tmp
node ~/.config/opencode/agents/gloomstalker/hook.ts "Add Redux state for API auth with tests" --debug
echo ""
echo ""

# Test 3: Styling task
echo "Test 3: Styling task"
echo "Task: 'Update Fela theme colors'"
echo "--------------------------------------------------"
cd ~/Developer/fanduel/sportsbook 2>/dev/null || cd /tmp
node ~/.config/opencode/agents/gloomstalker/hook.ts "Update Fela theme colors" --debug
echo ""
echo ""

# Test 4: RAF-app component task
echo "Test 4: RAF-app component task"
echo "Task: 'Create a button component with styled-components'"
echo "--------------------------------------------------"
cd ~/Developer/fanduel/raccoons/raf-app 2>/dev/null || cd /tmp
node ~/.config/opencode/agents/gloomstalker/hook.ts "Create a button component with styled-components" --debug
echo ""
echo ""

# Test 5: Unknown project
echo "Test 5: Unknown project (graceful fallback)"
echo "Task: 'Add a test'"
echo "--------------------------------------------------"
cd /tmp
node ~/.config/opencode/agents/gloomstalker/hook.ts "Add a test" --debug
echo ""
echo ""

echo "=================================================="
echo "Integration Test Complete"
echo "=================================================="
echo ""
echo "Summary:"
echo "- Test 1: Sportsbook test task (should load testing patterns)"
echo "- Test 2: Complex Redux task (should load state + API + testing)"
echo "- Test 3: Styling task (should load Fela patterns)"
echo "- Test 4: RAF-app component (should load React + styled-components)"
echo "- Test 5: Unknown project (should load core patterns only)"
echo ""
echo "Expected token savings: 40-60% on average"
