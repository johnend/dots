---
description: Subagent report shaping — cap report length up front, prefer parallel dispatch for independent work, give self-contained prompts so agents return concise actionable output instead of verbose research dumps
alwaysApply: true
---

## Subagent Report Shaping

### Core Pattern: Cap Reports Up Front

- Every agent prompt must specify the expected output format and length cap — without a cap, agents default to multi-paragraph research dumps that flood the main context window:

  ```
  Agent(prompt="... Report a punch list — done vs. missing. Under 200 words.")
  ```

- Choose the right format for the question:
  - **Punch list / checklist** when you want discrete items to act on
  - **One paragraph** when you want a synthesized answer
  - **Table** when comparing multiple things across the same axes
  - **Single-line verdict** when you want yes/no with brief justification

- Tell the agent what to OMIT explicitly when relevant — no preamble, no methodology recap, no caveats, no "I checked X and Y and Z". The user does not need the agent's narration of its own work.

### When to Use a Subagent vs Inline Work

Subagents earn their cost when:

- **Broad codebase exploration** — 3+ Grep/Read calls hunting an answer; delegate to `Explore` so the raw results don't fill main context
- **Independent parallel work** — multiple investigations that don't depend on each other; dispatch in a single message
- **Heavy research dumps** — when you genuinely need to scan a lot but only the conclusion matters in main context
- **Specialized tasks** — use the matching specialist (`code-reviewer`, `Plan`, `feature-dev:*`) rather than generic agents

Don't spawn an agent for:

- A single Grep or Read that would answer the question
- Work the main context handles cheaply
- Tasks already done by an earlier agent in the same session

### Parallel by Default

- When multiple agent invocations are independent, dispatch them in a single message with multiple Agent tool-use blocks — they run concurrently. Sequential dispatch is correct only when later prompts depend on earlier results.

### Brief the Agent Like a Colleague

- The agent has no memory of this conversation. Self-contained prompts only — include what you're trying to accomplish, what you've already ruled out, and the specific question to answer
- Hand over the exact command for lookups; hand over the question for investigations — prescribed steps become dead weight if the premise is wrong
- Never write "based on your findings, fix the bug" — that delegates synthesis you should be doing yourself. Give the agent a specific instruction, not an open-ended invitation

### Anti-Patterns

- **No length cap** — agents return 2000+ word reports that fill the main context window
- **Spawning for trivial tasks** — Grep/Read directly when the answer is one query away
- **Duplicate work** — searching the same thing yourself after delegating it to an agent
- **Using general-purpose when a specialist fits** — `Explore` for searches, `code-reviewer` for review, etc.
- **Sequential dispatch of independent work** — wastes wall-clock time and tokens on retained context between calls

### Review Checklist for New Agent Calls

Before dispatching an Agent call, verify:

- ✓ Is the report length capped in the prompt?
- ✓ Is the output format specified (punch list, paragraph, table, verdict)?
- ✓ Is the prompt self-contained — would a cold colleague understand it?
- ✓ Is this the right specialist agent, or is general-purpose actually correct?
- ✓ If multiple agents: are independent ones dispatched in parallel?
- ✓ Would Grep / Read inline answer this without an agent at all?
