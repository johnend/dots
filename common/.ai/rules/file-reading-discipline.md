---
description: File reading discipline — prefer Grep + narrow Read with offset/limit when a target is known, full reads when context matters; skip generated artifacts and avoid re-reads after Edit/Write
alwaysApply: true
---

## File Reading Discipline

### Core Pattern: Narrow When the Target Is Known, Full When Context Matters

- Default to narrow reads only when you have a specific target. Use the Grep tool to locate a known symbol, function, or string before reading — searching with Grep is cheaper than reading multiple files hunting for it, and tells you exactly which file and line to jump to:

  ```
  Grep for the symbol/string → get file:line → Read with offset/limit around that line
  ```

- Use Read with `offset` and `limit` when prior context (Grep result, error message, stack trace) has already told you where the relevant region lives. Pull roughly 50 lines around the target — enough for surrounding context without dragging the whole file into the window:

  ```
  Read(file_path="...", offset=120, limit=60)
  ```

- Do not guess at narrow ranges when you don't know where to look. A single full read beats three speculative narrow reads chasing the right offset — the latter wastes tokens AND reasoning budget.

### When Full Reads Are the Right Call

The narrow-read bias is a default, not a hard rule. Read the whole file when:

- **Small files** — Under roughly 300 lines, the full read is barely more expensive than a Grep call and gives you the complete picture in one round trip
- **Structural understanding** — You need to see imports, exports, type definitions, and how pieces connect, not just one symbol's body
- **Code review or audit scope** — Partial reads risk missing the issue. If the user has asked you to review or audit a file, read it fully
- **The file IS the artifact you're editing** — SKILL.md, CLAUDE.md, config files, scripts you're rewriting. You need full context to make consistent edits
- **Config files** — Any setting could be relevant to the task; partial reads risk missing an override or related option
- **First read of a file you'll work in repeatedly** this session — front-load the cost once instead of paying per-edit

### Anti-Patterns to Avoid

- **Re-reading after Edit/Write** — The harness tracks file state. If Edit or Write succeeded, the file is what you wrote. Re-reading to "verify" wastes a full file in context
- **Re-reading the same file twice in a session** without an edit in between — your context already has it
- **Reading generated artifacts** — Lockfiles (`yarn.lock`, `package-lock.json`, `Cargo.lock`), `dist/` output, minified bundles, `node_modules/` contents. Large and rarely informative
- **Reading when Grep would answer the question** — "Does this file use X?" is a Grep question, not a Read question
- **Using Bash with `cat`/`head`/`tail` instead of Read** — already covered by the system prompt, but worth restating: Read with offset/limit is the right tool for "show me lines N–M of file F"

### Search Hygiene

- Prefer the Grep tool over `rg` via Bash — Grep returns structured matches directly; piping rg through Bash drags raw output into the tool result
- Scope Grep with `path`, `glob`, or `type` filters rather than searching the whole repo when you know the area:

  ```
  Grep(pattern="useAuth", glob="**/*.tsx", path="src/components")
  ```

- Use `head_limit` on Grep when you expect many matches but only need the first few
- Use `output_mode="count"` or `output_mode="files_with_matches"` when you don't need the matching lines themselves — just the count or file list

### Review Checklist for New Reads

Before opening a Read call, verify:

- ✓ Have I already read this file (or its relevant region) in this session?
- ✓ Is there a Grep call that would answer my question without reading?
- ✓ If full read: is the file small, am I auditing, or do I genuinely need structural view?
- ✓ If narrow read: do I actually know the right offset, or am I guessing?
- ✓ Is this a generated artifact I should skip entirely?
