# OpenCode Commands - Quick Reference

**Location:** `~/.config/opencode/command/`  
**Format:** Markdown files with frontmatter  
**Usage:** Press `Ctrl+P` → Select command

## How Context Loading Works

**IMPORTANT:** OpenCode **automatically loads context** based on your directory!

The context system provides the data, OpenCode handles the loading.

## Available Commands

### Context Management

| Command       | Description                                   |
| ------------- | --------------------------------------------- |
| `/ctx-create` | Create comprehensive context for new project  |
| `/ctx-update` | Update existing context with recent changes   |
| `/ctx-verify` | Verify context accuracy against project state |

### Development Workflow

| Command      | Description                                   |
| ------------ | --------------------------------------------- |
| `/review`    | Review code changes against project standards |
| `/test-fix`  | Debug and fix failing tests                   |
| `/ui-create` | Create UI component (**asks first!**)         |

## Command Structure

Each command is a markdown file:

```markdown
---
description: Brief description
agent: artificer|investigator|bard
---

# Command Title

Detailed instructions...
```

## Benefits of Markdown Commands

✅ **Easy to read** - No JSON escaping  
✅ **Easy to edit** - Just edit markdown  
✅ **Version controlled** - In dotfiles repo  
✅ **Self-documenting** - Clear instructions  
✅ **Consistent** - Same prompt every time

## Adding New Commands

1. Create new `.md` file in `~/.config/opencode/command/`
2. Add frontmatter with description and agent
3. Write instructions in markdown
4. Use immediately with `Ctrl+P`

## Important Notes

### User Preferences Honored

All commands respect your preferences:

- ⚠️ **UI work:** Always asks first (you prefer doing frontend yourself)
- 📝 **Git operations:** Manual only (shows status/diff, no auto-commit)
- 🎯 **Code quality:** Prioritizes readability over cleverness
- ✅ **Testing:** Verifies with test runs before declaring success

### Context-Aware

Commands automatically:

- Load project context from `~/.config/opencode/context/projects/`
- Apply your user preferences from `user-preferences.md`
- Use project-specific patterns and conventions

## Documentation

For OpenCode configuration details:
📚 https://github.com/anomalyco/opencode/tree/dev/packages/web/src/content/docs

## Examples

### Loading Context

```
Press Ctrl+P → Type "ctx-load" → Enter
```

Agent loads context and summarizes:

- Project tech stack
- Key scripts
- Testing approach
- Important patterns

### Creating Context for New Project

```
Press Ctrl+P → Type "ctx-create" → Enter
```

Agent analyzes project and creates:

- `context.md` with full documentation
- `metadata.json` with path matching

### Code Review

```
Press Ctrl+P → Type "review" → Enter
```

Agent reviews your changes for:

- Code quality
- Pattern consistency
- Potential issues
- Test coverage

## Tips

1. **Use commands instead of typing prompts** - More consistent
2. **Press `Ctrl+P` to see all commands** - Searchable list
3. **Edit commands to customize** - They're just markdown files
4. **Add project-specific commands** - Create your own for common tasks

---

**Last Updated:** 2026-01-30  
**Commands Created:** 7 + README  
**Ready to use!** Press `Ctrl+P` to try them out.
