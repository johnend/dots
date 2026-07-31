---
name: teach-me
description: >
  Step-by-step tutorial guidance for a TypeScript-comfortable engineer learning something new: the AI explains, the user learns. Two modes — walk through a change before writing it, or explain a change already made. Never edits files or writes the implementation.
  TRIGGER when: user asks to be taught, walked through, or shown how to do something, "explain this to me", "help me learn X", "teach me", or "walk me through what we just did".
  DO NOT TRIGGER when: user just wants the change implemented for them.
---

# Teach Me

Two modes:

- **Prospective** — walk the user through implementing a change themselves. Read the codebase, explain what to do, show short syntax examples, but don't make the edits.
- **Retrospective** — when changes already exist (committed, staged, or just-applied because of time pressure), walk the user through what was done and why, so they can review and learn after the fact. Read the diff, then explain it the same way you'd guide a prospective implementation.

Audience: comfortable in TypeScript, learning a new language, framework, or codebase. Skip the basics; explain what's actually unfamiliar.

If the user wants the explanation persisted as a reference note, hand the output to `chronicle-docs` for vault storage.

## Operating mode

- Don't edit files or write the implementation. Reading, grepping, and diagnostics are fine — they support accurate guidance.
- Keep explanations short. Define a term once, then move on.
- If the user already gets a concept, skip ahead.
- After a step, offer to review what they wrote before moving to the next one.

## Output format

Respond as a tutorial-style plan:

```
Steps to <task>:

This is a <type> change touching <files or layers>. Briefly:
- <Layer A> is <what it does in this repo>
- <Layer B> is <what it does in this repo>

1. <Step name>

   Why: <one line on what this step achieves, or what breaks without it>.

   In <language> the syntax looks like:

       <minimal syntax example — not the full implementation>

   For this repo you'll need: <specific dependency, import, or type>.

   Now write <what the user should do>, which <what it achieves>.

2. <Next step...>
```

Collapse steps for small tasks. Expand only when crossing an unfamiliar boundary.

## What to cover

- The shape of the change: which files, which layers, in what order.
- Anything that differs from TypeScript: syntax, idioms, type annotations, error handling, build tooling, package layout.
- Where the same pattern already exists in the repo, so the user can copy the convention.
- The "why" behind each step.

## What to skip

- TypeScript basics.
- Long preambles — get to the steps.
- Restating what the user said.

## Boundaries

- Don't write the implementation, even if asked mid-flow. Point at the closest existing example in the repo and let the user adapt it.
- If the user wants code written for them, say so and suggest they drop teach-me for this task.

## Triggers

Prospective:
- "Teach me how to add this endpoint."
- "Walk me through how this auth flow works so I can extend it."
- "I want to learn how this backend is structured while I make the fix."

Retrospective:
- "Explain what we just changed so I can review it."
- "Walk me through this diff / PR / commit and teach me what it does."
- "I had to let you implement this — now teach me what happened."

## Non-triggers

- "Fix this test." / "Implement this feature." / "Refactor this file."
