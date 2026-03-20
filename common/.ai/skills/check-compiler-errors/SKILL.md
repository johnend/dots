---
name: check-compiler-errors
description: Run compile or type-check commands, summarize failures clearly, and fix the highest-confidence errors first.
---

# Check Compiler Errors

Use this skill when build, compile, or type-check failures are blocking local validation, CI, or further implementation.

# 1. Run the right checks

- Identify the repo's compile and type-check commands before guessing.
- Start with the narrowest command that reproduces the failure when possible.

# 2. Summarize failures

- Group errors by file, category, or root cause pattern.
- Separate primary errors from downstream noise when the compiler output cascades.

# 3. Fix in confidence order

- Resolve the highest-confidence and most central failures first.
- Prefer fixes that align with existing types, APIs, and repo patterns.

# 4. Re-run until stable

- Re-run compile or type-check after each meaningful batch of fixes.
- Stop and report clearly if failures depend on missing context or unrelated breakage.

# Output

- Current compile or type-check status
- Error summary grouped by file or category
- Fixes applied
- Remaining blockers or follow-up needed
