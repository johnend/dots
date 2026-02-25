Find and fix failing tests with a scoped workflow.

Process:
1. Identify changed files and run scoped tests first (not the whole suite by default).
2. List failing tests and pinpoint root cause in code or test expectations.
3. Apply minimal fix following existing patterns.
4. Re-run the same scoped tests to confirm pass.

Output:
- Which tests were run
- What failed
- Root cause (1-2 sentences)
- What changed
- Verification result

Do not claim completion until scoped tests pass.
