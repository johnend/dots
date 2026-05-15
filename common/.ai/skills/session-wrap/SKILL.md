---
name: session-wrap
description: "End-of-session documentation: synthesizes what was done, why, patterns implemented, and codebase knowledge gained, then hands off to chronicle-docs to write a structured Obsidian note."
---

# Session Wrap

Produces a rich end-of-session Obsidian note. Two phases: gather and synthesize, then hand off to `chronicle-docs` for formatting and storage.

---

## Phase 1 — Gather artifacts

Run in parallel:

- `git branch --show-current`
- `git log --oneline -20`
- `git diff --stat $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null || echo HEAD)`
- `git status --short`
- `pwd`

If not in a git repo, note it and use the directory name as the project name.

---

## Phase 2 — Determine context

**JIRA ticket**: Extract from branch name using pattern `([A-Z]+-[0-9]+)`.
Example: `RACNS-1234-some-feature` → `RACNS-1234`. Omit if no match.

**Workspace classification** — determines the Obsidian destination:

- Path under `~/Developer/fanduel/` → **Work**
  - Repo name = directory immediately under `~/Developer/fanduel/` (e.g. `refer-a-friend`)
  - Obsidian target: `Work/Domains/<repo-name>/`
  - Include `repo` in frontmatter
- All other paths, or if `~/Developer/fanduel/` does not exist → **Personal**
  - Obsidian target: `Personal/Projects/<project>/` for personal projects, `Personal/Knowledge/Tools/` for tooling, config, or dotfile work
  - No `repo` field in frontmatter

**File name**:
- Work with JIRA ticket: `<TICKET>-<Short-Title>.md` (e.g. `RACNS-1234-Predicts-Join-Page.md`)
- Everything else: `YYYY-MM-DD-<Short-Title>.md`

---

## Phase 3 — Synthesize session content

Write a structured document with the sections below. Be specific — file paths, function names, package names, and concrete examples are more useful than generalities.

### Summary

One short paragraph: what problem was being solved or what feature was being built, in plain language.

### What was done

Concrete list of changes made. Reference specific files, components, classes, and functions. Group logically by feature area or layer.

### Why

Motivation and context behind the work: ticket goal, bug report, PR reviewer feedback, architectural constraint. Connect each significant change to its reason. Call out non-obvious motivations explicitly.

### Patterns and techniques

Reusable patterns and techniques from this session — things worth reaching for again in this codebase or others. Favour concrete examples over abstract summaries.

Good: "Used `getCopy(key, params)` for copy interpolation — pass `{ variableName: value }` and the YAML template uses `{variableName}` syntax. Avoids `.replace()` chains."

Too vague: "Used the project's copy system."

Include patterns that were explicitly avoided and why, if that is a useful negative example.

### Codebase knowledge

Foundational understanding gained: how a subsystem works, where configuration lives, how data flows between layers, which classes or services own which domains, non-obvious invariants. Write this as a brief for an engineer who is new to this area.

### Decisions made

Key architectural or design decisions and their rationale. Where two or more approaches were considered, note what was chosen and why.

### Follow-ups

Deferred work, known gaps, open questions, or next steps. Omit this section entirely if there are none.

---

## Phase 4 — Construct frontmatter

Prepare these fields to pass to `chronicle-docs`:

- `date` — today's date in ISO 8601 (e.g. `2026-05-15`)
- `ticket` — JIRA ticket number if extracted (e.g. `RACNS-1234`); omit otherwise
- `repo` — repo name if Work context (e.g. `refer-a-friend`); omit otherwise
- `status` — `complete` or `in-progress`
- `type` — infer from changes: `feature`, `bugfix`, `refactor`, `docs`, `config`, `tooling`, or `review`
- `tags` — combine into a single flat list:
  - Ticket project prefix if present (e.g. `RACNS`)
  - Repo name if Work (e.g. `refer-a-friend`)
  - Organisation namespace if Work (e.g. `fanduel`)
  - Session type (e.g. `feature`)
  - Tech stack: infer from files changed — include languages (e.g. `typescript`, `java`), frameworks (e.g. `react`, `spring-boot`), and tooling (e.g. `jest`, `css-modules`, `kafka`) that were meaningfully involved. Only include what was actively worked with, not every project dependency.

---

## Phase 5 — Show draft, confirm, and hand off

Show the full synthesized content to the user for review. After showing it, ask explicitly:

> Save this to Obsidian?
> 1. Yes — write it now
> 2. No — discard

Wait for the user's response. Do not proceed until they reply.

**If the user confirms (selects 1, says "yes", "go ahead", "looks good", or any affirmative):**
Invoke `chronicle-docs` by calling `Skill("chronicle-docs")`, passing:
- The synthesized content from Phase 3
- The suggested Obsidian path from Phase 2
- The file name from Phase 2
- The frontmatter fields from Phase 4
- The workspace classification (Work or Personal) so `chronicle-docs` places the file without re-deriving it

**If the user declines (selects 2, says "no", "skip", "not now", "don't", or any response whose intent is to not proceed):**
Acknowledge and stop. Do not invoke `chronicle-docs`. Do not write any files.

Treat ambiguous or hedged responses ("maybe later", "let me think") as a no — do not proceed without clear intent to write.
