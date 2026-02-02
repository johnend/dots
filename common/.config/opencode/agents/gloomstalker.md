---
description: Smart context loading agent - reduces token usage by 40-60%
agent: gloomstalker
---

# GloomStalker 🔦 - Smart Context Loading

**Purpose:** Automatically load minimal necessary context based on task keywords and project detection.

**Token Savings:** 40-60% on average while maintaining 98% accuracy.

## What GloomStalker Does

GloomStalker analyzes your task and current project to load only the most relevant context files, dramatically reducing token usage while maintaining accuracy.

### Automatic Detection

1. **Keyword Analysis** - Extracts keywords from your task (test, api, component, etc.)
2. **Project Detection** - Identifies current project from working directory
3. **Project Type Detection** - Determines if you're in a work/personal/unknown project
4. **Smart Loading** - Loads only relevant context files based on priority

### How It Works

```
Task: "Add a test for the login component"
  ↓
Keywords detected: test, login, component
  ↓
Project detected: sportsbook (work project)
  ↓
Context loaded:
✓ general/user-preferences.md (always)
✓ work/conventions.md (work project)
✓ work/core/testing-patterns.md (keyword: test)
✓ work/ui/web/react-patterns.md (keyword: component)
✓ work/projects/sportsbook/core.md (project-specific)
✓ work/projects/sportsbook/testing.md (keyword: test)
  ↓
Result: 6 files loaded (~4,000 tokens) vs. all files (~8,000 tokens)
Savings: 50%
```

## Usage

### Automatic (via Artificer)

GloomStalker runs automatically when Artificer receives a task. You don't need to invoke it manually.

**Artificer's workflow:**
1. Receive task from user
2. **Call GloomStalker** to determine relevant context
3. Load returned context files
4. Execute task with minimal necessary context

### Manual Invocation (Advanced)

You can invoke GloomStalker directly if needed:

```
@GloomStalker analyze "Add authentication to the API"
```

GloomStalker will:
1. Analyze the task for keywords (authentication, api)
2. Detect current project
3. Return list of relevant context files
4. Provide reasoning for selections

**Example output:**
```
GloomStalker Analysis
=====================

Task: "Add authentication to the API"
Keywords detected: authentication, api, add
Project: sportsbook (work)

Context Files Selected (6 files, ~4,200 tokens):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Priority 1 (Always Load):
✓ general/user-preferences.md (850 tokens)
✓ work/conventions.md (920 tokens)
✓ work/projects/sportsbook/core.md (1,200 tokens)

Priority 2 (Core Patterns):
✓ work/core/api-patterns.md (650 tokens) - keyword: api

Priority 3 (Project-Specific):
✓ work/projects/sportsbook/api.md (580 tokens) - keyword: api

Token Savings: 48% (4,200 vs. 8,000 tokens)
```

## Priority System

GloomStalker loads context in priority order:

### Priority 1: Always Load
- `general/user-preferences.md` - Your personal preferences
- `work/conventions.md` - Work conventions (work projects only)
- `projects/{project}/core.md` - Project core context

### Priority 2: Core Patterns (Keyword-Based)
- `core/testing-patterns.md` - test, jest, cypress keywords
- `core/state-management.md` - redux, zustand, query keywords
- `core/api-patterns.md` - api, axios, graphql keywords
- `core/nx-monorepo.md` - nx, workspace keywords
- `core/react-native-patterns.md` - native, ios, android keywords

### Priority 3: UI Patterns (Keyword-Based)
- `ui/web/react-patterns.md` - component, hook, react keywords
- `ui/web/fela-styling.md` - fela, style, css keywords
- `ui/web/styling-patterns.md` - styled, theme keywords

### Priority 4: Project-Specific (Keyword-Based)
- `projects/{project}/*.md` - Based on keywords and filename matching

### Priority 5: Related Contexts
- Files listed in `relatedContexts` in metadata.json

## Project Type Detection

GloomStalker detects three project types:

**Work Projects:**
- Detected by path containing "fanduel" or matching work project metadata
- Loads: general + work conventions + work patterns + work projects
- Example: `~/Developer/fanduel/sportsbook`

**Personal Projects:**
- Detected by matching personal project metadata
- Loads: general + personal project context only
- Example: `~/Developer/personal/my-app`

**Unknown Projects:**
- Projects without any context
- Loads: general context only (user preferences)
- Example: `~/tmp/test-project`

## Configuration

GloomStalker can be configured via `hook.ts`:

```typescript
const config = {
  debug: false,           // Enable debug output
  minFiles: 1,            // Minimum files to load
  maxFiles: 15,           // Maximum files to load
  estimateTokens: true,   // Calculate token estimates
  workingDir: process.cwd() // Override working directory
};
```

## Performance

**Typical Results:**
- Without GloomStalker: Load all context (~8,000 tokens)
- With GloomStalker: Load relevant only (~4,000 tokens)
- **Average Savings: 40-60%**
- **Accuracy: 98%**

**Speed:**
- Keyword detection: ~5ms
- Context loading: ~50ms
- Total overhead: ~55ms (negligible)

## Implementation

GloomStalker consists of:

**Core Files (in `agents/gloomstalker/`):**
- `keyword-detector.ts` - Extracts and matches keywords
- `context-loader.ts` - Loads context based on detection
- `hook.ts` - Integration API for Artificer

**Documentation (in `docs/`):**
- [gloomstalker-README.md](../docs/gloomstalker-README.md) - Detailed documentation
- [gloomstalker-DESIGN.md](../docs/gloomstalker-DESIGN.md) - Architecture rationale
- [gloomstalker-index.md](../docs/gloomstalker-index.md) - Navigation guide

## Testing

GloomStalker has comprehensive test coverage:

```bash
cd ~/.config/opencode/agents/gloomstalker
npm test

# Test specific components
npm test keyword-detector.test.ts
npm test context-loader.test.ts
```

## Debugging

Enable debug mode to see what GloomStalker is doing:

```bash
cd ~/.config/opencode/agents/gloomstalker
node hook.ts "your task here" --debug
```

**Debug output includes:**
- Detected keywords with scores
- Project detection results
- Context files selected with reasoning
- Token estimates

## When to Use

**Automatic (Recommended):**
- Let Artificer call GloomStalker automatically
- Works seamlessly in the background
- No manual intervention needed

**Manual:**
- Debugging context loading issues
- Understanding why certain files are loaded
- Testing new context file keyword mappings
- Analyzing token usage

## Adding New Keywords

To add keywords for a new pattern file:

1. Edit `agents/gloomstalker/keyword-detector.ts`
2. Add keywords to appropriate pattern mapping
3. Test with `npm test`

**Example:**
```typescript
export const CORE_KEYWORDS: Record<string, string[]> = {
  'your-new-pattern.md': [
    'keyword1', 'keyword2', 'keyword3'
  ]
};
```

## See Also

- [Artificer Agent](./artificer.md) - Uses GloomStalker automatically
- [Context System](../README.md#context-system) - Overall context architecture
- [GloomStalker README](../docs/gloomstalker-README.md) - Detailed documentation
