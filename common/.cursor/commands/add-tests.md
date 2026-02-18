# Add tests for untested code

Write tests for **newly implemented or currently untested** code. Aim for meaningful coverage of the implementation. Do not run the full test suite—only the new tests you add.

## What to test

1. **Identify scope** – Either the user specifies which file(s) or feature to test, or identify recently added/changed files that have no corresponding test file (e.g. `feature-a.tsx` exists but `feature-a.test.tsx` or `feature-a.spec.tsx` does not).
2. **Test the implementation, not the libraries** – Focus on **our** logic, behaviour, and edge cases. Do not write tests that merely assert third-party or framework behaviour (e.g. “React renders” or “fetch returns”). Mock external dependencies where needed; assert inputs, outputs, and side effects of the code under test.
3. **Coverage that matters** – Cover: public API / exported behaviour; main branches and error paths; edge cases (empty input, null, boundaries); integration points with our code. Prefer fewer, focused tests over many trivial ones.
4. **Follow project conventions** – Use the repo’s test runner, file naming (`.test.tsx`, `.spec.ts`, etc.), location (co-located or `__tests__/`), and patterns (e.g. React Testing Library, describe/it, fixtures). Match existing test style in the project.

## Use the codebase’s test stack (don’t reinvent)

- **Discover first** – Before writing tests, look for existing test helpers, mocks, utilities, and factories in the repo (e.g. `test-utils`, `testing/`, `__mocks__/`, `jest.setup`, shared `render` helpers, mock factories). Use them instead of writing your own.
- **Reuse helpers and mocks** – If the project has helpers for rendering components, creating fixtures, or mocking APIs/modules, use those. Do not introduce new mocking or setup patterns unless the codebase has none for that case.
- **Match existing style** – Copy structure and patterns from similar test files in the same area of the codebase (same framework, same layer). Consistency over personal preference.

## Minimize repetition (DRY tests)

- **Group and nest** – Use `describe` blocks to group related cases (e.g. by behaviour, by component, by edge case). Share setup at the right level so it’s written once.
- **Shared setup** – Use `beforeEach` / `beforeAll` (or the project’s equivalent) for common setup, and factory functions or builders for test data rather than repeating the same object literals in every test.
- **Helpers for common actions** – If several tests do the same sequence (e.g. “render with X, click Y, assert Z”), extract a small helper or use a shared pattern already in the codebase. Prefer one clear place to change when behaviour evolves.
- **Avoid copy-paste** – If you find yourself duplicating the same setup or assertions across tests, factor it out so there is as little repetition as possible while keeping each test readable and focused.

## Process

1. **Locate untested code** – Confirm which file(s) or module to test and that they have no (or insufficient) tests.
2. **Read the implementation and the test stack** – Understand public behaviour, branches, and error handling. **Find and note** existing test helpers, mocks, utils, and patterns used in nearby or similar tests so you can reuse them.
3. **Write tests** – Create or extend the test file using the codebase’s helpers and conventions. Group cases to avoid repetition; use shared setup and factories where it helps. Prioritise: behaviour the user cares about, edge cases, and failure modes. Avoid testing library internals or implementation details that are likely to change.
4. **Run only the new/updated tests** – Execute the test runner for the new test file(s) only (e.g. `jest path/to/feature-a.test.tsx`). Do not run the full suite unless the user asks.
5. **Fix any failures** – If the new tests fail, fix the tests or the implementation until the scoped run is green.

## Output

- Which file(s) were under test and which test file(s) were added or updated
- Short summary of what is covered (e.g. “happy path, empty input, error response handling”)
- Test run result (pass/fail) for the scoped run

Do not claim the work is done until the new tests have been run and are passing.
