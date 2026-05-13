---
name: chronicle-docs
description: Draft or update high-quality technical documentation for the Obsidian vault with clear structure, Obsidian-ready frontmatter, appropriate tags, rationale, and practical examples.
---

# Chronicle Docs

Target vault: `~/Developer/personal/Obsidian`

# 1. Classify content:

- Workflow guide, tool guide, architecture note, or learning note.

# 2. Suggest path:

- Work: `Work/Domains/<project>/` or `Work/Knowledge/`
- Personal: `Personal/Projects/<project>/`, `Personal/Knowledge/Tools/`, or `Personal/Learning/Notes/`

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
- Only add wikilinks to documents that are known to exist in the vault. Do not speculatively link to notes that might be created later. If referring to a topic without a matching note, use plain text instead of a wikilink.
- Before adding a `[[Related]]` or `[[See Also]]` section, verify target notes exist. Prefer fewer accurate links over many broken ones.

# 5. Write documentation:

- Explain why and how.
- Include examples, commands, and troubleshooting.
- Use concise, natural technical language.

# 6. Output:

- Suggested path
- Final markdown content ready to store, including frontmatter when appropriate
