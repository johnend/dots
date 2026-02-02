---
description: Debug and fix failing tests
agent: artificer
---

# Fix Failing Tests

Analyze failing tests, identify root cause, fix issues, and verify with test run.

## Process

1. **Identify Failures**
   - Run tests to see current state
   - Parse test output for failures
   - List all failing tests

2. **Analyze Root Cause**
   - Read failing test code
   - Check what's being tested
   - Examine implementation code
   - Identify the actual problem

3. **Fix Implementation**
   - Apply fix to source code
   - Ensure fix addresses root cause
   - Follow project patterns
   - Don't break other functionality

4. **Verify Fix**
   - Run tests again
   - Confirm previously failing tests now pass
   - Check no new failures introduced
   - Run full test suite if needed

## Output

Provide:
- List of tests that were failing
- Root cause explanation
- Changes made to fix
- Test results showing pass
- Any additional tests added (if needed)

**IMPORTANT:** Don't declare success until tests are verified passing!
