# OpenCode Configuration

Personal AI assistant configuration including agents, commands, and hierarchical context system.

## Directory Structure

```
~/.config/opencode/
├── agents/              # AI agent definitions
│   ├── artificer.md     # Main builder agent
│   ├── bard.md          # UI/frontend specialist
│   ├── chronicler.md    # Research & documentation
│   ├── investigator.md  # Debugging & analysis
│   ├── pathfinder.md    # Codebase exploration
│   ├── sentinel.md      # Quick tasks
│   └── gloomstalker/    # Smart context loading system
├── command/             # Custom AI commands
└── context/             # Hierarchical context system
    ├── general/         # Personal preferences (public)
    ├── personal/        # Personal project context (public)
    └── work/            # Work-specific context (gitignored)
```

## Context System

The context system provides AI agents with relevant background information based on the current task and project.

### Hierarchical Structure

#### `context/general/` - Personal Preferences
- **Tracked in git:** ✅ Public
- **Contains:** Personal development preferences, workflow patterns, tool configurations
- **Always loaded:** Yes, for all projects

#### `context/personal/` - Personal Projects
- **Tracked in git:** ✅ Public (personal projects only)
- **Contains:** Project-specific context for personal projects
- **Loaded when:** Working in personal project directories

#### `context/work/` - Work Context
- **Tracked in git:** ❌ Gitignored
- **Contains:** Work-specific patterns, conventions, and project contexts
- **Loaded when:** Working in work project directories

### How It Works

The **GloomStalker** agent (`agents/gloomstalker/`) automatically loads relevant context based on:

1. **Project Type Detection** - Identifies if you're in a work/personal/unknown project
2. **Keyword Analysis** - Scans your task for relevant keywords (test, api, component, etc.)
3. **Smart Loading** - Loads only necessary context files (40-60% token savings)
4. **Priority System** - Loads context in order of relevance

### Context File Types

**Pattern Files** (in `core/` and `ui/` directories)
- Reusable patterns and conventions
- Testing patterns, API patterns, state management, etc.
- Loaded based on keyword detection

**Project Files** (in `projects/` directories)
- Project-specific context and metadata
- Tech stack, scripts, conventions
- Loaded when working in that project

**Preferences** (in `general/`)
- Your personal working style
- Tool preferences and workflows
- Always loaded for consistency

### Adding New Context

#### Add General Context
```bash
# Create new file in general/
echo "# My Pattern" > ~/.config/opencode/context/general/my-pattern.md
```

#### Add Personal Project Context
```bash
# Create project directory and files
mkdir -p ~/.config/opencode/context/personal/projects/my-project
echo "# Project Context" > ~/.config/opencode/context/personal/projects/my-project/context.md
```

#### Add Work Context
```bash
# Work context stays private (gitignored)
mkdir -p ~/.config/opencode/context/work/projects/my-work-project
echo "# Work Project" > ~/.config/opencode/context/work/projects/my-work-project/context.md
```

### Keyword Mapping

GloomStalker maps keywords to context files. To add new keywords:

1. Edit `agents/gloomstalker/keyword-detector.ts`
2. Add keywords to the appropriate pattern mapping
3. Test with `yarn test` in gloomstalker directory

## Agents

### Artificer 🔨
Main builder and orchestrator. Delegates to specialists and never gives up until tasks are complete.

### GloomStalker 🔦
Smart context loading system that reduces token usage by 40-60% while maintaining accuracy.

### Pathfinder 🗺️
Fast codebase exploration using glob patterns and content search.

### Investigator 🔍
Complex debugging, performance analysis, and strategic planning.

### Sentinel 🛡️
Quick, simple tasks that take under 5 minutes.

### Chronicler 📚
Research, documentation, and external information gathering.

### Bard 🎨
UI/frontend work and component development.

## Commands

Custom commands available in the `command/` directory. Use with:
```
/command-name [args]
```

## Installation

This configuration is managed with **GNU Stow**:

```bash
cd ~/Developer/personal/dots
stow common
```

This creates symlinks:
- `~/.config/opencode/agents` → dotfiles
- `~/.config/opencode/command` → dotfiles
- `~/.config/opencode/context` → dotfiles

## Gitignore Rules

The `.gitignore` is configured to:

```gitignore
# Track general and personal context
!common/.config/opencode/context/
!common/.config/opencode/context/general/
!common/.config/opencode/context/personal/

# Ignore work-specific context
common/.config/opencode/context/work/
```

This ensures:
- ✅ Personal preferences are public and portable
- ✅ Personal project context is shared across machines
- ❌ Work-specific content stays private

## Development

### GloomStalker Development

```bash
cd ~/.config/opencode/agents/gloomstalker

# Run tests
npm test

# Test specific file
npm test keyword-detector.test.ts

# Debug context loading
node hook.ts "your task here" --debug
```

### Adding New Patterns

1. Create pattern file in appropriate directory
2. Add keyword mappings in `keyword-detector.ts`
3. Add tests in `keyword-detector.test.ts`
4. Test with real tasks

## Token Savings

GloomStalker achieves 40-60% token savings by:
- Loading only relevant context files
- Detecting project type automatically
- Using keyword-based filtering
- Prioritizing always-needed files
- Avoiding duplicate content

**Example:**
- Without GloomStalker: ~8,000 tokens (all context)
- With GloomStalker: ~4,000 tokens (relevant only)
- Savings: 50%

## Maintenance

### Update Context
Context files are markdown and can be edited directly:
```bash
nvim ~/.config/opencode/context/general/user-preferences.md
```

### Sync Across Machines
Since context is in dotfiles:
```bash
cd ~/Developer/personal/dots
git pull
stow common
```

### Backup Work Context
Work context is gitignored but can be backed up separately:
```bash
tar -czf work-context-backup.tar.gz ~/.config/opencode/context/work/
```

## See Also

- [GloomStalker README](./docs/gloomstalker-README.md) - Detailed documentation
- [GloomStalker DESIGN](./docs/gloomstalker-DESIGN.md) - Architecture and rationale
- [GloomStalker Index](./docs/gloomstalker-index.md) - Navigation guide
- [Artificer Agent](./agents/artificer.md) - Main builder documentation

---

**Last Updated:** 2026-02-02  
**Managed by:** GNU Stow  
**Repository:** Personal dotfiles
