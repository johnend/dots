---
name: research-protocol
description: "For complex repo work such as features, non-trivial bugs, integrations, and config changes: research first, verify understanding, then implement and update docs."
---

# Research Protocol

Use this skill when the task is non-trivial: new features, subtle bugs, dependency or config changes, integrations, architecture changes, or any case where wrong assumptions are likely.

# 1. Discover first

- Read the smallest set of relevant docs, notes, configs, and code paths.
- Prefer existing implementations over inventing a new pattern.
- Map the affected flow, dependencies, and similar code before editing.

# 2. Verify understanding

- Confirm the likely data flow, ownership, and change surface.
- Identify blockers, ambiguous requirements, and risky assumptions.
- If a key requirement cannot be inferred safely, ask a focused question.

# 3. Execute after research

- Implement once the path is clear.
- Prefer extending existing code over introducing parallel abstractions.
- Respect other active guardrails such as manual git, destructive confirmation, and UI consent.

# 4. Close the loop

- Run the narrowest useful validation.
- Update existing docs or notes when the change makes them stale.
- Fix nearby instances when the same issue pattern clearly repeats.

# Output

- Brief summary of what was verified
- Files or systems affected
- Key assumptions or open questions
- Validation performed
