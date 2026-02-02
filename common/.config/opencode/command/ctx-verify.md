---
description: Verify context matches current project state
agent: artificer
---

# Verify Project Context

Check if the existing context file in `~/.config/opencode/context/{type}/projects/{project-name}/` accurately reflects the current project state.

## When to Run

This command should be run automatically by Artificer when:
1. Starting work in a codebase that has existing context
2. User explicitly requests verification with `/ctx-verify`

## Step 1: Detect Existing Context

Look for context in both locations:
- `~/.config/opencode/context/work/projects/{current-project-name}/context.md`
- `~/.config/opencode/context/personal/projects/{current-project-name}/context.md`

If no context exists, suggest running `/ctx-create` instead.

## Step 2: Verification Checks

### 1. Tech Stack Accuracy
- Compare versions in context vs. actual config files
- Check framework versions
- Check language/runtime versions
- Flag any mismatches

**Example:**
```
✅ React version: 19.0.0 (matches)
❌ Node version: context says 20.x, actual is 22.15
```

### 2. Scripts Completeness
- List all available scripts from package.json/build.gradle/etc.
- Check if all are documented in context
- Note any new scripts not documented

**Example:**
```
✅ All 12 scripts documented
⚠️  New script not in context: test:watch
```

### 3. Dependencies Sync
- Check if major dependencies match
- Note version upgrades
- Identify new significant dependencies

**Example:**
```
✅ Core dependencies match
⚠️  New dependency: @tanstack/react-query 5.64.2
⚠️  Upgraded: typescript 4.9.5 → 5.4.5
```

### 4. Structure Alignment
- Verify directory structure matches
- Note any new important directories
- Check if restructuring occurred

**Example:**
```
✅ Directory structure matches
⚠️  New directory: src/features/
```

### 5. Pattern Consistency
- Check if documented patterns are still used
- Identify new patterns not documented
- Look for deprecated patterns

**Example:**
```
✅ Testing patterns still accurate
⚠️  New pattern detected: MSW for API mocking
```

### 6. Team Info Current
- Verify Slack channels still active (can't check, just note)
- Check runbook/wiki links still valid (can attempt to verify)
- Note any ownership changes

**Example:**
```
⚠️  Unable to verify Slack channels (manual check needed)
✅ Runbook link still valid
```

## Step 3: Output Format

Provide a clear verification report:

```
Context Verification Report - {project-name}
=============================================

Context Location: ~/.config/opencode/context/{type}/projects/{project-name}/
Last Updated: {date from metadata.json}

✅ ACCURATE ({X} checks passed):
- Tech stack versions match
- Core dependencies documented
- Project structure current
- Testing patterns valid

⚠️  NEEDS UPDATE ({X} issues found):
- New dependency added: @tanstack/react-query v5.64.2
- Script 'test:watch' not documented
- New directory: src/features/
- TypeScript upgraded: 4.9.5 → 5.4.5

❌ OUTDATED ({X} critical issues):
- React version in context: 18.2.0, actual: 19.0.0
- Build tool changed: webpack → vite

RECOMMENDATION:
{if issues found}
Run /ctx-update to sync context with current project state

{if all accurate}
Context is up to date! No action needed.
```

## Step 4: Context Reference

After verification, remind the user:

```
Context files are stored in OpenCode config, not in the project:
- Work projects: ~/.config/opencode/context/work/projects/
- Personal projects: ~/.config/opencode/context/personal/projects/

These files are loaded automatically by GloomStalker when you work in the project.
```

## Verification Logic

**Critical Issues (❌):**
- Major version mismatch (framework, language, runtime)
- Significant architectural changes
- Build tool changes

**Needs Update (⚠️):**
- Minor version changes
- New dependencies
- New scripts
- New directories
- New patterns

**Accurate (✅):**
- Versions match
- All documented items still valid
- No new significant changes

## Notes

- This command runs IN the project directory but checks context IN OpenCode config
- Context file path depends on project type (work/personal)
- After verification, offer to run `/ctx-update` if needed
