# Context System README

## How It Works

**OpenCode automatically loads context based on your current directory!**

When you work in a project directory, OpenCode:
1. Detects your working directory (e.g., `~/Developer/fanduel/sportsbook/`)
2. Matches it against `matchPatterns` in `metadata.json` files
3. Automatically loads the corresponding `context.md`
4. Also loads `user-preferences.md`
5. Agents get full context without you asking!

**You don't need to manually load context** - it's automatic! 🎉

## Quick Commands

Use OpenCode commands (press `Ctrl+P`) for context management:

- **/ctx-create** - Create context for new project
- **/ctx-update** - Update existing context
- **/ctx-verify** - Verify context accuracy
- **/review** - Review code changes against project standards
- **/test-fix** - Fix failing tests
- **/ui-create** - Create UI component (asks first)

## Overview
This directory contains project-specific context files that AI agents load dynamically. This separation allows agent behavior to remain consistent while project details vary.

## Architecture

### Purpose
- **Agent Profiles** (system prompts) define HOW agents work
- **Context Files** (this directory) define WHAT agents work on
- Context is loaded dynamically based on detected project path

### Directory Structure
```
context/
├── README.md (this file)
├── user-preferences.md
└── projects/
    ├── sportsbook/
    │   ├── context.md
    │   └── metadata.json
    ├── aw-dynamic-web/
    │   ├── context.md
    │   └── metadata.json
    ├── raf-app/
    │   ├── context.md
    │   └── metadata.json
    └── ... (other projects)
```

## File Types

### context.md
Project-specific context including:
- Tech stack (framework, language, build tool, dependencies)
- Scripts and commands
- Project structure
- Testing strategy
- Development workflow
- Team information
- Common patterns
- Configuration files

### metadata.json
Machine-readable project metadata:
```json
{
  "projectPath": "/Users/john.enderby/Developer/fanduel/sportsbook",
  "projectName": "sportsbook",
  "lastUpdated": "2026-01-30",
  "contextVersion": "1.0.0",
  "hasAgentsMd": true,
  "hasAiFolder": true,
  "monorepo": "nx",
  "matchPatterns": [
    "**/fanduel/sportsbook/**",
    "**/sportsbook/**"
  ]
}
```

### user-preferences.md
User working style, preferences, and patterns extracted from dotfiles and working habits.

## Context Loading Strategy

### 1. Path Detection
When an AI agent starts work, it:
1. Detects the current working directory
2. Matches against `matchPatterns` in metadata files
3. Loads the corresponding `context.md`

### 2. Context Combination
The agent combines:
- Agent behavior (from system prompt)
- Project context (from `context.md`)
- User preferences (from `user-preferences.md`)

### 3. Fallback Behavior
If no matching context is found:
- Agent operates with general knowledge only
- May ask user for project details
- Can still function but with less project-specific awareness

## Projects Covered

### Priority Projects (Detailed Context)
1. **aw-dynamic-web** - React web app (Account & Wallet)
2. **refer-a-friend-service** - Java Spring Boot backend
3. **raf-app** - React frontend (Refer-a-Friend)
4. **sportsbook** - React Native + Web Nx monorepo

### Other Projects (Basic Context)
- adminweb
- account_e2e_cypress
- fd-lambda-shorturl
- refer-a-friend-db (+ notifications, stream)
- level-up-butler
- personal-dots

## Maintenance

### Adding New Projects
1. Create `context/projects/{project-name}/` directory
2. Create `context.md` with project details
3. Create `metadata.json` with path patterns
4. Update this README

### Updating Existing Context
1. Edit the relevant `context.md` file
2. Update `lastUpdated` in `metadata.json`
3. Increment `contextVersion` if breaking changes

### Context File Template
```markdown
# {project-name} Context

**Project Path:** `~/path/to/project`

## Overview
Brief description

## Tech Stack
### Core
- Framework
- Language
- Build Tool

### Dependencies
Key libraries

## Scripts
Common commands

## Project Structure
Directory layout

## Development Workflow
How to work on the project

## Team & Support
Communication channels
```

## Benefits

### For AI Agents
- ✅ Load only relevant context
- ✅ Consistent behavior across projects
- ✅ Faster responses (less prompt overhead)
- ✅ Better suggestions (project-aware)

### For Users
- ✅ Single source of truth per project
- ✅ Easy to update project info
- ✅ Agents "just know" project details
- ✅ Less repetition explaining stack

### For Maintenance
- ✅ Separate concerns (behavior vs. context)
- ✅ Version control per project
- ✅ Easy to add new projects
- ✅ No need to update agent profiles

## Context Sources

Context is derived from:
1. **AGENTS.md** - Project-specific AI instructions (if exists)
2. **package.json / build.gradle** - Dependencies and scripts
3. **README.md** - Project documentation
4. **.ai/ folder** - AI commands and instructions
5. **Git history** - Understanding project evolution
6. **Directory structure** - Understanding architecture

## OpenCode Configuration Reference

### Config Location
- Main config: `~/.config/opencode/opencode.jsonc`
- Commands: `~/.config/opencode/command/*.md` (markdown format preferred)

### Documentation
**IMPORTANT:** When editing OpenCode configuration, reference the official docs:

📚 **OpenCode Documentation:**
https://github.com/anomalyco/opencode/tree/dev/packages/web/src/content/docs

The MDX docs contain:
- Schema documentation and examples
- Configuration options explained
- Command system details
- Feature guides

### Command System
Commands are markdown files (`.md`) with frontmatter:

```markdown
---
description: What this command does
agent: artificer|investigator|bard|etc
---

# Command Instructions

Detailed prompt here...
```

**Why markdown?**
- ✅ Easier to read and edit
- ✅ Version controlled with dotfiles
- ✅ Self-documenting with descriptions
- ✅ No JSON escaping headaches

## Version History
- **1.0.0** (2026-01-30) - Initial context system with 12 projects + command system

