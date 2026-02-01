---
description: Verify context matches current project state
agent: artificer
---

# Verify Project Context

Check if the existing context file accurately reflects the current project state.

## Verification Steps

1. **Tech Stack Accuracy**
   - Compare versions in context vs. actual files
   - Flag any mismatches

2. **Scripts Completeness**
   - List all available scripts
   - Check if all are documented in context

3. **Structure Alignment**
   - Verify directory structure matches
   - Note any new directories

4. **Pattern Consistency**
   - Check if documented patterns are still used
   - Identify new patterns not documented

5. **Team Info Current**
   - Verify Slack channels still active
   - Check runbook/wiki links still valid

## Output Format

```
Context Verification Report
===========================

✅ Accurate:
- Tech stack versions match
- All scripts documented

⚠️  Needs Update:
- New dependency added: @tanstack/react-query v5.0.0
- Script 'test:watch' not documented

❌ Outdated:
- React version in context: 18.2.0, actual: 18.3.1

Recommendation: Run /ctx-update to sync context
```
