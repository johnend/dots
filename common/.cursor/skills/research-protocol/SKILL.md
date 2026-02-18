---
name: research-protocol
description: "For complex work (features, bugs, integrations, config): 8-step research-first protocol. Discovery → verify understanding → execute → update docs. Use when scope is non-trivial or 'not found' is possible."
---

# Research-first protocol

Use this protocol when the work is **complex**: new features, non-trivial bugs, dependency/config changes, integrations, architectural or data-flow changes, or any task where “not found” or wrong assumptions are possible. **Skip** for simple known ops (single file read, known command, known repo git op).

## Phase 1: Discovery

1. **Notes and docs** – Search workspace (notes/, docs/, README), project .md files, and if relevant ~/Documents/. Use for context only; verify everything against actual code.
2. **Map the system** – Data flow and architecture, data structures/schemas, config and dependencies, and **existing implementations** that do something similar (leverage or extend rather than create from scratch).
3. **Inspect before building** – Study existing code that solves similar problems. If reusing or extending it, trace its dependencies so your changes don’t break other callers.

## Phase 2: Verification

4. **Verify understanding** – In your head or in a short summary: full flow, impact, and alternatives. For multi-step or subtle problems, think through approach and risks before acting.
5. **Blockers** – Ambiguous requirements? Security/risk? Multiple valid designs? Missing info only the user can give? If no blockers → proceed to Phase 3. If blockers → state them briefly and ask for clarification.

## Phase 3: Execution

6. **Execute** – Implement (or fix) without asking permission for the implementation itself. Respect existing rules (e.g. no auto-commit, ask before UI, confirm destructive ops). Complete the full task chain; if task A reveals B, fix both.
7. **Update documentation** – After completion, update existing notes/docs to match reality. Note outdated bits with dates. Add assumptions that still need verification. Don’t create duplicate docs.

## Principles

- **Trust code over docs** – When docs and code disagree, trust code; then update docs.
- **Exhaust search before “not found”** – Try different patterns, content search, and directories before concluding something doesn’t exist.
- **Complete everything** – One fix may reveal another; fix the chain and fix the class of issue where appropriate.
