---
name: fix-merge-conflicts
description: Resolve merge conflicts with minimal edits, validate the result, and leave the branch in a clean buildable state without pushing.
---

# Fix Merge Conflicts

Use this skill when the branch has unresolved merge conflicts and needs a reliable path back to a buildable state.

# 1. Detect the full conflict set

- Identify conflicted files from git status and conflict markers.
- Check for generated files such as lockfiles that should be regenerated instead of hand-merged.

# 2. Resolve minimally

- Resolve each file with correctness and readability first.
- Preserve both sides when they can coexist safely.
- If only one side should win, choose the version that keeps behavior coherent and compiles with the surrounding code.

# 3. Regenerate where appropriate

- Regenerate lockfiles or derived artifacts with the proper package manager or build tool instead of editing them manually when possible.

# 4. Validate

- Run compile, lint, and the narrowest relevant tests.
- Confirm no conflict markers remain anywhere in the tree.

# Guardrails

- Keep changes focused on conflict resolution; avoid opportunistic refactors.
- Do not leave partially resolved files behind.
- Do not commit, push, or tag as part of this workflow unless explicitly requested.

# Output

- Files resolved
- Notable resolution decisions
- Validation performed and remaining blockers
