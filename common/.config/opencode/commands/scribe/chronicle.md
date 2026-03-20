---
description: Create documentation in Obsidian vault with smart location routing (Scribe command)
---

# /chronicle

Create rich documentation in the Obsidian vault (`~/Developer/personal/Obsidian`). Used by Scribe.

## How It Works

1. Detect current working directory → infer work vs personal project
2. Auto-detect content type: code implementation, workflow, learning, tool guide, concept
3. Route to appropriate Obsidian location (confirm with user if ambiguous):
   - Work: `Work/Domains/{Project}/` or `Work/Knowledge/`
   - Personal projects: `Personal/Projects/{Project}/`
   - Learning: `Personal/Learning/Notes/`
   - Tools: `Personal/Knowledge/Tools/`
4. Generate documentation using Scribe's natural voice

## Implementation

- `obsidian-mapper.js` — maps vault structure, detects project type
- `scribe-chronicle.js` — generates documentation with template
- Caching system stores project → location mappings to avoid repeated confirmations

## Usage

```bash
# During a session (after implementing something)
@Scribe /chronicle

# Standalone
/chronicle "Document the new auth flow"
```

Manual location override: `/chronicle --location "Personal/Learning/Notes/"`
