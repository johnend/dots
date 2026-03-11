---
name: deslop
description: Clean up AI-style code and test slop in a patch by removing unnecessary complexity, noisy comments, and low-value tests while preserving behavior.
---

# Deslop

Use this skill when the user wants a patch cleaned up, made more idiomatic, or stripped of AI-generated noise without changing intended behavior.

# 1. Inspect the patch

- Review the diff or the changed files first.
- Compare the new code and tests against nearby file and repo conventions.

# 2. Remove low-value code noise

- Delete comments that restate obvious code.
- Remove unnecessary defensive branches, wrappers, or indirection.
- Simplify nested logic when early returns or direct expressions are clearer.
- Eliminate type escapes or placeholder abstractions that exist only to force progress.

# 3. Remove low-value test noise

- Prefer tests that protect real behavior, meaningful branches, and regression-prone paths.
- Remove or avoid tests that only pad counts, duplicate nearby coverage, or assert library/framework behavior rather than local logic.
- Keep multiple tests when they cover distinct outcomes, edge cases, or branches that matter.
- If cleanup changes tests, preserve confidence in the real behavior under test rather than maximizing raw test count.

# 4. Preserve behavior

- Keep public behavior unchanged unless a clear bug is found.
- If cleanup reveals a real bug, fix it minimally and say so explicitly.
- Avoid broad rewrites during cosmetic cleanup.

# 5. Verify

- Run focused validation when practical.
- Re-read the final diff for consistency with local style and test value.

# Output

- What slop patterns were removed
- Any test cases removed, rewritten, or kept for coverage value
- Any behavior-affecting fix made during cleanup
- Validation performed or skipped
