---
name: debug-with-me
description: "Structured debugging workflow for runtime bugs and failing tests: hypothesis-driven investigation, minimal fix, and scoped verification."
---

# Debug With Me

1. Capture symptom:
- Exact error, expected behavior, and reproduction conditions.

2. Form hypotheses:
- List likely causes with quick rationale.

3. Investigate:
- Use focused checks (logs, traces, breakpoints, `git diff`, related tests).

4. Fix minimally:
- Patch root cause, not downstream symptoms.

5. Verify:
- Run scoped tests/commands and confirm behavior.

6. Report:
- Root cause summary
- Evidence
- Applied fix
- Verification result
- Short prevention tip
