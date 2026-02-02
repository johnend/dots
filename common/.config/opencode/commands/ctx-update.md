---
description: Update existing project context
agent: artificer
---

# Update Project Context

Review and update the context file for the current project in `~/.config/opencode/context/{type}/projects/{project-name}/`.

## When to Run

This command should be run:
1. After `/ctx-verify` identifies issues
2. When user explicitly requests with `/ctx-update`
3. When significant project changes are made

## Step 1: Load Existing Context

Find the context file:
- Check `~/.config/opencode/context/work/projects/{current-project-name}/context.md`
- Check `~/.config/opencode/context/personal/projects/{current-project-name}/context.md`

If no context exists, suggest running `/ctx-create` instead.

## Step 2: Analyze Changes

### 1. Dependencies Changed?
- Read `package.json` / `build.gradle` / `pom.xml` / etc.
- Compare with context
- List version changes
- Note new dependencies
- Note removed dependencies

### 2. Scripts Added/Modified?
- List all current scripts
- Compare with context
- Add new scripts with descriptions
- Update modified scripts
- Remove obsolete scripts

### 3. Structure Changed?
- Check directory layout
- Compare with context
- Note new directories
- Note removed/renamed directories
- Update project structure section

### 4. Tech Stack Updated?
- Check framework versions
- Check language/runtime versions
- Check build tool versions
- Update versions in context

### 5. Patterns Evolved?
- Look for new conventions in code
- Check if documented patterns are still used
- Identify new testing patterns
- Update key patterns section

### 6. Team Changes?
- Note any ownership changes (if obvious from README/docs)
- Update team section if needed

## Step 3: Update Files

### Update `context.md`

Make targeted edits to the existing file:
- Update version numbers where changed
- Add new scripts/dependencies
- Remove obsolete information
- Add new directories to structure
- Document new patterns
- Keep existing good documentation

**Do NOT rewrite the entire file** - make surgical edits to preserve existing context.

### Update `project-metadata.json`

- Update `lastUpdated` field to today's date
- Update version numbers if relevant
- Add new keywords if project focus changed
- Keep existing metadata intact

## Step 4: Output Summary

Provide a clear summary of changes:

```
✅ Context Updated - {project-name}

Location: ~/.config/opencode/context/{type}/projects/{project-name}/

Changes Made:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Dependencies Updated:
- typescript: 4.9.5 → 5.4.5
- @tanstack/react-query: 5.64.2 (new)

🔧 Scripts Added:
- test:watch - Run tests in watch mode

📁 Structure Updated:
- Added: src/features/
- Added: src/hooks/

🎯 Patterns Documented:
- MSW for API mocking
- React Query for data fetching

📝 Metadata Updated:
- lastUpdated: {today's date}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Context is now synchronized with current project state.
Run /ctx-verify to confirm accuracy.
```

## Step 5: Verification Offer

After updating, suggest verification:

```
Would you like me to run /ctx-verify to confirm everything is accurate?
```

## Update Strategy

**Surgical Updates:**
- Edit specific sections that changed
- Preserve existing good documentation
- Don't rewrite sections that are still accurate

**Comprehensive Updates:**
- If context is severely outdated (>10 changes)
- If major refactoring occurred
- If project structure completely changed
- In these cases, consider suggesting `/ctx-create` to rebuild

## Notes

- Updates are made to OpenCode config files, not project files
- Context location depends on project type (work/personal)
- After update, GloomStalker will use the new context automatically
- Work contexts (gitignored) won't be tracked in dotfiles
- Personal contexts (tracked) will be committed to dotfiles
