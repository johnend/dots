---
name: chronicle-docs
description: >
  Draft or update high-quality technical documentation in the Obsidian vault, with clear structure, Obsidian-ready frontmatter, tags, rationale, and examples.
  TRIGGER when: user asks to document something, write or update docs/notes, add a page to the Obsidian vault / knowledge base, "chronicle this", or "write this up".
  DO NOT TRIGGER for: code comments, repo README/docs, or PR descriptions (use describe-pr).
---

# Chronicle Docs

Target vaults, in preference order:

- Current Linux machine: `/home/johne/Documents/Obsidian`
- Work machine: `~/Developer/personal/Obsidian`

Use the first path that exists. Do not spend time rediscovering the vault path unless neither exists.

# 1. Classify content:

- Workflow guide, tool guide, architecture note, or learning note.

# 2. Suggest path:

- Work: `Work/Domains/<Domain>/` or `Work/Knowledge/`
- Personal: `Personal/Projects/<project>/`, `Personal/Knowledge/Tools/`, or `Personal/Learning/Notes/`

## Work vault placement

First decide **work item or reference**, because it picks the directory:

- **Work item** — tied to a ticket, initiative, incident or anything with a `status` / end date. Goes in `Work/Domains/<Domain>/Work-Items/<Work-Item>/`.
- **Reference** — durable "how this works" material with no end date. Goes in the domain's topic folder (`Service/`, `Database/`, `Frontend-App/`, `Runbooks/`, or the domain's `Knowledge/`).

Rules:

- **One directory per work item.** Every artifact for a single piece of work — plan, draft ticket, RCA, test plan, prompts — lives together in that one directory. Never scatter a ticket's notes across topic folders.
- **Naming.** `RACNS-<key>-<Short-Summary>` when a Jira key exists, else `<Short-Summary>`. Check for an existing directory for that ticket before creating a new one.
- **Overlap via metadata, not folders.** A work item touching several areas stays in one directory. Express the overlap with frontmatter `tags` and wikilinks — never copy a note into a second folder.
- **Stamp `work-item:`** in frontmatter on every note inside a work-item directory, matching the directory name exactly.
- **Domain hub.** Each domain has `<Domain>-Overview.md`. Add new work items to its Work Items table and to `Work-Items/Work-Items-Overview.md`.
- **Scope.** Top-level `Work/Knowledge/` and `Work/Research/` are **cross-domain only**. A single-domain note belongs under that domain, not at the top level.
- **Graduating knowledge.** When a work item ends and leaves durable knowledge behind, move that note into the domain's topic folder and leave the ticket history in the work-item directory.

Reference example: `Work/Domains/Refer-a-Friend/` — `Work-Items/RACNS-1551-Casino-RAF-Activation/` alongside reference folders `Service/`, `Database/`, `Consumer-Integration/`, `Knowledge/`.

# 3. Add or preserve Obsidian metadata:

- When creating or updating a vault note, include YAML frontmatter at the top unless the target note format clearly does not use it.
- If the note already has frontmatter, preserve valid existing fields and update them instead of replacing them blindly.
- Include `tags` in frontmatter and choose concise, relevant tags based on domain, topic, tool, and note type.
- Add other Obsidian-relevant fields when they improve organization, such as `aliases`, `created`, `updated`, or `status`.
- Keep metadata consistent with the note path and content. Do not add placeholder fields with empty values.

# 4. Wikilink hygiene:

- Use bare filenames in wikilinks — never use relative paths like `../` (e.g. `[[Java-Setup]]` not `[[../Java-Setup]]`).
- Never create files named `README.md` — use a unique name derived from the directory context instead (e.g. `Dotfiles-Overview.md`, `Refer-a-Friend-Overview.md`). Generic filenames cause ambiguous wikilinks in Obsidian when multiple directories have the same filename.
- Never link to a generic filename like `[[README]]` that could match multiple files. Use a unique filename or the full vault path to disambiguate.
- **Keep every basename unique across the vault.** Avoid generic names (`Overview.md`, `Integration.md`, `Notes.md`) and never reuse one basename in sibling folders — a bare `[[Name]]` then resolves unpredictably. Prefix with context instead (`CSS-Modules-Migration-Overview.md`, `RAF-V2-Integration-Plan.md`). When parallel folders hold variants of the same item, suffix them (`03-cap-timeframe.md` vs `03-cap-timeframe-short.md`).
- **Moving or renaming a note outside Obsidian breaks links silently.** `alwaysUpdateLinks` only fires for moves made inside the app. After any filesystem move, grep for inbound references to the old basename (both `[[Name]]` and `](path)` forms) and update them, then re-verify that nothing else pointed at it.
- Only add wikilinks to documents that are known to exist in the vault. Do not speculatively link to notes that might be created later. If referring to a topic without a matching note, use plain text instead of a wikilink.
- Before adding a `[[Related]]` or `[[See Also]]` section, verify target notes exist. Prefer fewer accurate links over many broken ones.

# 5. Write documentation:

- Explain why and how.
- Include examples, commands, and troubleshooting.
- Use concise, natural technical language.

# 6. Output:

- Suggested path
- Final markdown content ready to store, including frontmatter when appropriate
