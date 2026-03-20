---
description: Verify context accuracy against current project state
---

# /ctx-verify

Check if existing project context matches the current project state. Run automatically when Artificer starts work in a project with context.

## Steps

1. **Detect** existing context location (work or personal)
2. **Verify:** tech stack versions match, scripts are documented, dependencies are listed, structure is current, patterns are accurate
3. **Report:** list accurate items, items needing update (with specifics), and critical mismatches
4. **Recommend** `/ctx-update` if issues found
