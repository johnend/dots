---
description: Update existing project context
agent: artificer
---

# Update Project Context

Review and update the context file for the current project.

## What to Check

1. **Dependencies Changed?**
   - Check package.json / build.gradle / etc.
   - Update versions if changed

2. **Scripts Added/Modified?**
   - Check for new scripts
   - Update descriptions

3. **Structure Changed?**
   - New directories or reorganization
   - Update project structure section

4. **Patterns Evolved?**
   - New conventions adopted
   - Update key patterns section

5. **Team Changes?**
   - New Slack channels
   - Ownership changes
   - Update team section

## Process

1. Load current context file
2. Analyze current project state
3. Identify differences
4. Update context.md with changes
5. Update metadata.json `lastUpdated` field

## Output

Provide:
- List of changes made
- Confirmation that context is up to date
- Any significant changes worth noting
