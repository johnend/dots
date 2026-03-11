---
name: pre-commit-cleanup
description: Clean up a patch before review or commit by removing slop, checking test value, validating key paths, and surfacing remaining risks.
---

# Pre-Commit Cleanup

Use this skill when a patch is mostly implemented and should be tightened before the user reviews it or considers committing.

# 1. Inspect the patch first

- Review the current diff or changed files before editing.
- Identify whether the main risks are code slop, test slop, correctness issues, or unfinished validation.

# 2. Clean the patch

- Apply `deslop` principles to remove noisy comments, unnecessary indirection, placeholder code, and low-value tests.
- Keep tests that cover meaningful behavior, important branches, and realistic regressions.
- Avoid inflating test count unless additional tests materially increase confidence.

# 3. Check for obvious review issues

- Look for correctness risks, missing edge cases, and maintainability problems that would likely come up in review.
- Fix small high-confidence issues directly.
- If a larger design issue appears, report it instead of quietly rewriting the patch.

# 4. Validate

- Run focused validation for the changed behavior.
- Re-check the final diff for consistency with local style and repo patterns.

# Output

- Cleanup performed
- Tests kept, added, removed, or rewritten and why
- Validation performed
- Remaining risks or questions before commit or review
