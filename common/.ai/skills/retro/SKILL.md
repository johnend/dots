---
name: retro
description: >
  Automatically review completed substantive tasks and generalisable corrections
  for reusable lessons shared between Claude and Codex. Also run for explicit
  retros and before session wrap-up. Write scoped guidance and maintain its index;
  skip task reports, one-off preferences and trivial exchanges without lessons.
---

# Retro

Turn reusable lessons into guidance that loads only when the relevant work occurs.

## When to run

Run before the final response for substantive implementation, configuration,
investigation, research or review work, after a generalisable correction, and
before session wrap-up. No separate user request is required. Do one review for
the completed task, not after every tool call or each step of the same work.

## Find useful lessons

Look for repeated mistakes, user corrections, refuted hypotheses, tool workarounds
and scope misses. Skip temporary task state and facts readily derived from current
code. Read [guidance maintenance](../../context/guidance-maintenance.md) before
recording or reorganising instructions.

## Write in the right place

- Reusable language, tool or task guidance: read the conditional-reading index in
  `~/.ai/AGENTS.md` and update the matching file under `~/.ai/context/` directly.
  These files are in a public repository, so first make the lesson general: strip
  company names, project keys, ticket numbers, field IDs, internal hostnames and
  team names.
- Lessons that only apply when calling one MCP server or CLI: that tool's own
  module (`~/.ai/context/<tool>.md`), created on its first lesson and added to the
  index. Don't mix tools in one module.
- Company-specific details that don't survive generalising and aren't tied to one
  repository: `~/.ai-work/AGENTS.md` (private, untracked; create it if missing).
- Project-specific facts or invariants: use the owning project's `AGENTS.md` or a
  relevant project guidance file linked from it. Do not put project details in
  global modules or rely on one tool's private memory as the shared source.
- A new global preference or permission boundary: propose the focused change to
  the shared global `AGENTS.md`; do not recreate an Applied Learning backlog.
- Multi-step workflows: update the relevant skill. Propose skill/hook changes or
  policy replacements unless the user has already authorised that change in the
  current task. Hooks remain appropriate for mechanically enforced boundaries.

Edit the real repository files, not their installed symlink paths. Use the current
checkout path rather than assuming a particular machine's directory layout.

Read the destination first. Keep the rule concise and preserve its applicability,
known rationale and useful source reference. Do not invent provenance. Merge with
equivalent guidance rather than duplicating it; create a new module only when it
has a clear scope and add its reading condition to the appropriate index.

## Extend the shared guidance

Routine guidance files, directories and reading-index updates are authorised in
both tools. Reuse a fitting module first. If none fits, create a focused file with
an applicability statement and the useful rule. Add a topic/stack directory when
it provides a clear home for related modules; avoid folders for individual
incidents, empty scaffolding and deep hierarchies.

Update the shared global reading index or the owning project's index in the same
change, using a specific task condition and an ordinary Markdown link. Keep shared
modules under `~/.ai/context/` and project modules in the project. Do not add eager
imports or place conditional modules in Claude's auto-loaded rules directory.

Both tools must read and update these same repository files. Across machines,
changes travel with the dotfiles or project repository through the usual approved
Git workflow. Tool-private memory is not the shared source.

Reorganise guidance directly, without disposition lists or migration records.
Do not write tool-managed memory unless the user explicitly requests it.

## Report

Briefly name what was written and where, or any concrete proposal awaiting
approval. Do not list every considered or skipped lesson. An automatic review with
no useful new lesson stays silent. For an explicitly requested retro with no
qualifying lessons, say "No durable lessons this session."
