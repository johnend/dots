---
name: pre-commit-cleanup
description: Clean up a patch before review or commit by removing AI-style slop, checking test value, validating key paths, and surfacing remaining risks.
---

# Pre-Commit Cleanup

Use this skill when a patch is mostly implemented and should be tightened before the user reviews it or considers committing.

# 1. Inspect the patch first

- Review the current diff or changed files before editing.
- Compare the new code and tests against nearby file and repo conventions.
- Identify whether the main risks are code slop, test slop, correctness issues, or unfinished validation.

# 2. Remove low-value code noise

- Delete comments that restate obvious code.
- Remove unnecessary defensive branches, wrappers, or indirection.
- Simplify nested logic when early returns or direct expressions are clearer.
- Eliminate type escapes or placeholder abstractions that exist only to force progress.

# 3. Remove low-value test noise

- Prefer tests that protect real behaviour, meaningful branches, and regression-prone paths.
- Remove or avoid tests that only pad counts, duplicate nearby coverage, or assert library/framework behaviour rather than local logic.
- Keep multiple tests when they cover distinct outcomes, edge cases, or branches that matter.
- Preserve confidence in real behaviour under test rather than maximising raw test count.

# 4. Check for obvious review issues

- Look for correctness risks, missing edge cases, and maintainability problems that would likely come up in review.
- Fix small high-confidence issues directly.
- If a larger design issue appears, report it instead of quietly rewriting the patch.

# 5. Preserve behaviour

- Keep public behaviour unchanged unless a clear bug is found.
- If cleanup reveals a real bug, fix it minimally and say so explicitly.
- Avoid broad rewrites during cosmetic cleanup.

# 6. Validate

- Run focused validation for the changed behaviour.
- Re-read the final diff for consistency with local style and repo patterns.

# Output

- Slop patterns removed (code and tests)
- Tests kept, added, removed, or rewritten and why
- Any behaviour-affecting fix made during cleanup
- Validation performed
- Remaining risks or questions before commit or review
