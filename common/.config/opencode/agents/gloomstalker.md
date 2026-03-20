---
description: Smart context loader - saves 40-60% tokens
agent: gloomstalker
---

# GloomStalker - Smart Context Loader

Automatically loads only relevant context files based on task keywords and project detection. Saves 40-60% tokens while maintaining accuracy.

## Usage

Called by Artificer before every task:

```bash
node ~/.config/opencode/hooks/gloomstalker/cli.js "task description"
```

Returns a list of context file paths to load via Read tool.

## How It Works

1. Extracts keywords from the task
2. Detects current project from working directory (work/personal/unknown)
3. Matches keywords against context file categories
4. Returns minimal necessary files in priority order

## Priority System

1. **Always loaded:** user preferences, conventions (for work projects), project core context
2. **Keyword-matched:** testing patterns, state management, API patterns, React patterns, styling patterns
3. **Project-specific:** files matching task keywords from project context
4. **Related:** contexts referenced in project metadata

## Configuration

Options via `hook.ts`: `debug`, `minFiles` (default 2), `maxFiles` (default 15), `workingDir`, `estimateTokens`
