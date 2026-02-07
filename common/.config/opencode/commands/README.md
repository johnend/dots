# OpenCode Commands

This directory contains markdown-based command definitions for OpenCode.

## How Context Loading Works

**IMPORTANT:** OpenCode **automatically loads** project context based on your current directory!

The context system we built provides the **data**, OpenCode handles the **loading**.

## Command Files

Commands are defined as markdown files with frontmatter:

```markdown
---
description: Brief description of what command does
agent: artificer|investigator|bard|etc
model: optional-model-override
subtask: true|false (optional)
---

# Command Title

Command instructions here...
```

## Available Commands

### Context Management

- **ctx-create.md** - Create comprehensive context for new project
- **ctx-update.md** - Update existing context
- **ctx-verify.md** - Verify context matches project state

### Agent-Specific Commands

- **mentor/** - Mentor's teaching and collaboration commands
- **scribe/** - Scribe's documentation and chronicling commands

### Development

- **review.md** - Review code changes against standards
- **test-fix.md** - Debug and fix failing tests
- **ui-create.md** - Create UI component (asks first)

## Usage

Press `Ctrl+P` (or your configured keybind) to open command palette and select a command.

Commands automatically:

- Load appropriate agent
- Apply project context
- Use consistent prompts

## Adding New Commands

1. Create new `.md` file in this directory
2. Add frontmatter with description and agent
3. Write command instructions
4. Use in OpenCode with `Ctrl+P`

## Benefits

✅ **Easier to read** than JSON config  
✅ **Version controlled** with dotfiles  
✅ **Consistent behavior** across sessions  
✅ **Self-documenting** with descriptions

## Documentation

For OpenCode configuration reference:
https://github.com/anomalyco/opencode/tree/dev/packages/web/src/content/docs
