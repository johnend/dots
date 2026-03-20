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

# 4. Write documentation:

- Explain why and how.
- Include examples, commands, and troubleshooting.
- Use concise, natural technical language.

# 5. Output:

- Suggested path
- Final markdown content ready to store, including frontmatter when appropriate
