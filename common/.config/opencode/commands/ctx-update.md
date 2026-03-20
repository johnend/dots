---
description: Update existing project context to match current state
---

# /ctx-update

Sync existing project context with current project state. Run after `/ctx-verify` identifies issues.

## Steps

1. **Load existing** context.md and project-metadata.json
2. **Analyze changes:** dependencies added/removed/upgraded, scripts added/changed, structure changes, tech stack version bumps, new patterns, team info changes
3. **Surgical edits** — update only changed sections in context.md (not a full rewrite). Update `lastUpdated` in metadata.
4. **Report** — summary of what changed
