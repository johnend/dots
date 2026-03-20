---
description: Review code changes against project standards
---

# /review

Review current git changes (staged + unstaged) against project standards. Delegated to Investigator.

1. Load project context via GloomStalker
2. Run `git diff` to see all changes
3. Analyze for: code quality issues, pattern violations, potential bugs, missing tests, type safety problems
4. Report findings grouped by severity (critical → warning → suggestion) with file paths and line numbers
