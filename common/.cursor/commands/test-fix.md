# Fix failing tests

Analyze failing tests, find the root cause, fix the implementation, and verify with a **scoped** test run. Do not run the whole test suite unless the user explicitly asks—many repos are large monorepos with 100k+ tests.

## Scope tests to changed code

1. **Find modified files** – Use `git status` / `git diff` (or the files the user is working on) to see what changed.
2. **Map to test files** – For each modified source file, run only the tests that cover it:
   - **Same-name convention:** `feature-a.tsx` → `feature-a.test.tsx`, `feature-a.spec.tsx`, or `feature-a.test.ts` in the same or nearby directory.
   - **Co-located:** `__tests__/feature-a.test.tsx`, `__tests__/feature-a.spec.tsx`, or a `tests/` sibling.
   - **Project-specific:** If the repo has an “affected” or “related” command (e.g. `nx affected:test`, `jest --findRelatedTests`), use that to run only tests impacted by the changed files.
3. **Run only those tests** – Execute the test runner with the scoped paths or pattern (e.g. `jest path/to/feature-a.test.tsx`, or the affected command). Do not run the full suite by default.
4. If the user explicitly asks to run the full suite or “all tests”, then do so; otherwise keep runs scoped.

## Process

1. **Identify failures** – Run the **scoped** test command (see above). Parse output and list every failing test.
2. **Find root cause** – Read the failing test(s) and the code under test. Pinpoint why the test fails (wrong behaviour, wrong test, or environment).
3. **Fix** – Change the implementation (or the test if the test is wrong). Follow project patterns; don’t break other behaviour.
4. **Verify** – Re-run the **same scoped tests**. Confirm the previously failing tests pass and no new failures appear. Only suggest a broader or full run if the change could affect other areas and the user agrees.

## Output

- Which files were changed and which tests were run (scoped)
- Which tests were failing
- Root cause in one or two sentences
- What you changed to fix it
- Test run result showing pass

Do not say the fix is done until the scoped tests have been re-run and are passing.
