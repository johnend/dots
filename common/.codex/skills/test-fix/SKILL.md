---
name: test-fix
description: Diagnose and fix failing tests with scoped runs, root-cause analysis, and re-validation before completion.
---

# Test Fix

1. Scope runs:
- Start with affected tests only.
- Do not run full suite unless asked.

2. Diagnose:
- Identify failing assertions and the behavior mismatch.
- Determine whether code or test expectation is wrong.

3. Implement:
- Apply minimal fix aligned with existing patterns.

4. Re-run scoped tests:
- Confirm previous failures are now passing.

5. Report:
- What failed
- Root cause
- What changed
- Scoped run command and result
