---
description: Create comprehensive project context in OpenCode config
---

# /ctx-create

Create context files for the current project in OpenCode config (NOT in the project directory).

## Steps

1. **Ask project type:** work (stored in `context/work/projects/` — gitignored) or personal (stored in `context/personal/projects/` — tracked)
2. **Analyze project:** read package.json, tsconfig, CI config, README, folder structure. Identify: tech stack + versions, available scripts, key dependencies, architectural patterns, testing setup
3. **Create two files:**
   - `context.md` — comprehensive project documentation (tech stack, scripts, patterns, structure, key files)
   - `project-metadata.json` — `{ name, type, path, techStack[], keywords[], relatedContexts[], lastUpdated }`
4. **Confirm** — show summary: location, file sizes, tech stack detected, scripts documented, patterns identified
