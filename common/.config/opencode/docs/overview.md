# OpenCode System Overview

**Version:** 2.0  
**Last Updated:** 2026-02-02

## Philosophy

OpenCode is an AI assistant configuration system built on three core principles:

1. **Context Efficiency** - Load only what's needed (40-60% token savings)
2. **Task Visibility** - Track multi-step work with mandatory todos
3. **Operational Safety** - Prevent destructive operations from causing damage

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         USER REQUEST                         │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    ARTIFICER (Orchestrator)                  │
│  • Receives all requests                                     │
│  • Coordinates specialist agents                             │
│  • Enforces three-layer safety system                        │
└──────────────┬───────────────────────────────────────────────┘
               │
               ├──→ [Step 1] Route to specialist agent if simple
               │    (Sentinel, Pathfinder, Investigator, etc.)
               │
               ├──→ [Step 2] 🚦 TODO ENFORCER CLI
               │    │ Detects multi-step tasks
               │    │ • score >= 2 → Require todos
               │    │ • score < 2 → Skip
               │    └─→ Creates todos if needed
               │
               ├──→ [Step 3] 🔦 GLOOMSTALKER CLI
               │    │ Smart context loading
               │    │ • Analyzes task keywords
               │    │ • Returns relevant file list
               │    └─→ Loads only necessary context (40-60% savings)
               │
               ├──→ [Step 4] Verify project context
               │    Check if /ctx-create or /ctx-update needed
               │
               ├──→ [Step 5] Analyze & Categorize
               │    Determine approach (delegate vs. handle)
               │
               ├──→ [Step 6] 🛡️ RISK ASSESSOR CLI (before destructive ops)
               │    │ Evaluates operation safety
               │    │ • Critical (10+) → BLOCK
               │    │ • High (7-9) → ASK user
               │    │ • Medium (4-6) → WARN
               │    └─→ Low/None → Proceed
               │
               ├──→ [Step 7] Execute & update todos
               │
               └──→ [Step 8] Verify & Report
```

## Three-Layer Safety System

### Layer 1: 🔦 GloomStalker (Context Efficiency)

**Purpose:** Load minimal necessary context  
**Location:** `hooks/gloomstalker/`  
**Type:** TypeScript CLI

**How it works:**
1. Analyzes user's task for keywords (test, api, react, etc.)
2. Detects current project from working directory
3. Returns list of relevant context files to load
4. Result: 40-60% token savings while maintaining accuracy

**Example:**
```bash
$ node hooks/gloomstalker/cli.js "Add a test for login API"

Files to load:
  - context/general/user-preferences.md
  - context/work/conventions.md
  - context/work/core/testing-patterns.md
  - context/work/core/api-patterns.md
  - context/work/projects/sportsbook/core.md

Token savings: 52% (4,200 tokens vs 8,800)
```

### Layer 2: 🚦 Todo Enforcer (Task Visibility)

**Purpose:** Prevent incomplete multi-step work  
**Location:** `hooks/todo-enforcer/`  
**Type:** TypeScript CLI

**How it works:**
1. Analyzes user's request for multi-step indicators
2. Scores based on: action verbs, conjunctions, complexity, files mentioned
3. If score >= 2: Task is multi-step, todos required
4. Suggests todo breakdown based on detected actions

**Example:**
```bash
$ node hooks/todo-enforcer/cli.js "Add authentication and write tests"

{
  "isMultiStep": true,
  "score": 3,
  "shouldBlock": true,
  "message": "🚦 MULTI-STEP TASK DETECTED",
  "suggestedTodos": ["Add auth logic", "Write tests"],
  "indicators": ["2 action verbs found", "Sequential conjunctions"]
}
```

**Multi-step indicators:**
- Multiple action verbs (2+) = 2 points
- Sequential conjunctions (and, then) = 1 point
- Complex request (>200 chars) = 1 point
- Multiple files mentioned = 1 point
- Cross-cutting concerns = 2 points

### Layer 3: 🛡️ Risk Assessor (Operational Safety)

**Purpose:** Prevent destructive operations  
**Location:** `hooks/risk-assessor/`  
**Type:** TypeScript CLI

**How it works:**
1. Detects 30+ destructive operation patterns
2. Identifies critical targets (main branch, production, system dirs)
3. Scores risk level (0-20+)
4. Takes action: BLOCK critical, ASK for high, WARN for medium

**Example:**
```bash
$ node hooks/risk-assessor/cli.js "git push --force origin main"

{
  "riskLevel": "critical",
  "shouldBlock": true,
  "score": 12,
  "recommendations": ["🛑 STOP: This operation is extremely dangerous"],
  "operations": [{"type": "git-force", "severity": "critical"}],
  "criticalTargets": ["main"]
}
```

**Risk levels:**
- **Critical (10+):** Block execution, show error
- **High (7-9):** Require explicit user confirmation
- **Medium (4-6):** Warn, proceed with caution
- **Low (1-3):** Info only, proceed
- **None (0):** Safe, no assessment needed

## Hierarchical Context System

Context is organized in three tiers:

```
context/
├── general/              # Personal preferences (PUBLIC, tracked in git)
│   └── user-preferences.md
├── personal/             # Personal projects (PUBLIC, tracked in git)
│   └── projects/
│       └── {project-name}/
│           └── context.md
└── work/                 # Work patterns and projects (GITIGNORED, private)
    ├── conventions.md
    ├── core/            # Core patterns (testing, api, state, etc.)
    ├── ui/              # UI patterns (React, Fela, etc.)
    └── projects/        # FanDuel-specific projects
        └── {project-name}/
            ├── core.md
            ├── context.md
            └── {domain}.md
```

**Loading priority:**
1. Always load: user-preferences.md, conventions.md (if work project)
2. Core patterns matching keywords
3. UI patterns matching keywords
4. Project-specific files matching keywords
5. Related contexts from metadata

## Agent System

OpenCode uses a multi-agent architecture with specialized roles:

### Primary Agent
- **Artificer** 🔨 - Main builder and orchestrator, handles complex multi-step tasks

### Specialist Agents
- **Sentinel** 🛡️ - Fast execution for simple, unambiguous tasks (<5 min)
- **Pathfinder** 🗺️ - Codebase exploration and file finding
- **Investigator** 🔍 - Complex debugging and strategic analysis
- **Chronicler** 📚 - Research, documentation, GitHub operations
- **Bard** 🎨 - UI/component creation (user approval required)
- **Coach** 🏃 - Workflow optimization and productivity
- **Mentor** 🎓 - Learning and explanation
- **Steward** 🌱 - Code quality and best practices
- **Visionary** 🔮 - Architecture and design patterns

See [agents.md](./agents.md) for detailed documentation.

## Command System

Context management commands:

- `/ctx-create` - Create project context in OpenCode config
- `/ctx-verify` - Verify context accuracy against current project
- `/ctx-update` - Surgically update context with project changes

Other commands:
- `/review` - Code review and feedback
- `/test-fix` - Test-driven debugging
- `/ui-create` - UI component scaffolding

See [commands/README.md](../commands/README.md) for all commands.

## Workflow Example

**User request:** "Add authentication to login page and write tests"

1. **Artificer receives request**
   
2. **Todo Enforcer runs:**
   ```
   ✓ Multi-step detected (score: 3)
   ✓ Creating todos:
      1. Implement auth logic in auth service
      2. Update login page to use auth service
      3. Write unit tests for auth service
      4. Write E2E tests for login flow
   ```

3. **GloomStalker loads context:**
   ```
   ✓ Keywords detected: auth, login, page, test
   ✓ Loading 8 files (42% token savings):
      - user-preferences.md
      - conventions.md
      - testing-patterns.md
      - react-patterns.md
      - sportsbook/core.md
      - sportsbook/auth.md
   ```

4. **Artificer executes:**
   ```
   ✓ Todo 1 → in_progress
   ✓ Implements auth service
   ✓ Todo 1 → completed
   
   ✓ Todo 2 → in_progress
   ✓ Updates login page
   ✓ Todo 2 → completed
   
   [continues through all todos]
   ```

5. **Risk Assessor (if needed):**
   ```
   ✓ No destructive operations detected
   ✓ Proceeding safely
   ```

6. **Verification:**
   ```
   ✓ All todos completed
   ✓ Tests passing
   ✓ Code follows existing patterns
   ```

## Configuration

### User Preferences

Stored in `context/general/user-preferences.md`:
- Working style and conventions
- Preferred tools and libraries
- Do's and don'ts
- Commit conventions
- Testing preferences

### Project Context

Created with `/ctx-create`, stored in:
- Work: `context/work/projects/{name}/` (gitignored)
- Personal: `context/personal/projects/{name}/` (tracked)

Contains:
- Tech stack and versions
- Dependencies
- Available scripts
- Architecture patterns
- Project-specific conventions

## Setup

### First-Time Setup

```bash
# 1. Stow dotfiles (if using GNU Stow)
cd ~/Developer/personal/dots
stow -t ~ common

# 2. Run install script
cd ~/.config/opencode
./install.sh
```

### What the Install Script Does

1. Installs npm dependencies for all three CLIs
2. Compiles TypeScript to JavaScript
3. Makes CLI executables
4. Verifies everything works

Takes ~30 seconds. Run once per machine or after pulling updates that change CLI code.

## Token Savings Analysis

**Without OpenCode:**
- Average context size: 8,000-12,000 tokens
- Loaded on every request
- No filtering or relevance ranking

**With OpenCode (GloomStalker):**
- Average context size: 3,000-5,000 tokens
- Only relevant files loaded
- Keyword-based smart selection
- **Result: 40-60% token reduction**

**Example savings:**
```
Task: "Fix bug in authentication"

Without GloomStalker: 9,200 tokens
  - All core patterns (4,500 tokens)
  - All UI patterns (2,100 tokens)
  - All project files (2,600 tokens)

With GloomStalker: 4,400 tokens (52% savings)
  - user-preferences.md (800 tokens)
  - conventions.md (600 tokens)
  - testing-patterns.md (900 tokens)
  - auth patterns (1,200 tokens)
  - sportsbook/core.md (900 tokens)
```

## Safety Metrics

**Todo Enforcement:**
- Target: 90%+ multi-step tasks have todos
- Measured: (tasks with todos) / (total multi-step tasks)

**Risk Assessment:**
- Target: 0 destructive operations executed without review
- Critical operations: 100% blocked
- High-risk operations: 100% require confirmation

## Design Principles

1. **Explicitness over Magic**
   - User sees what's happening (loaded files, risk scores, todo breakdowns)
   - No hidden decisions

2. **Safety by Default**
   - Critical operations blocked
   - High-risk requires confirmation
   - Multi-step requires todos

3. **Efficiency without Sacrifice**
   - 40-60% token savings
   - No accuracy loss (keyword-based loading)
   - Fast CLI execution (<100ms)

4. **Composable Architecture**
   - Each CLI can be used standalone
   - Clear separation of concerns
   - Easy to test and maintain

## Future Enhancements

Potential improvements:
- LLM-powered todo suggestions (beyond keyword matching)
- Todo templates for common task types
- Risk pattern learning from user corrections
- Context caching for repeated tasks
- Performance profiling and optimization

## References

- [Agent Documentation](./agents.md)
- [Hook/CLI Documentation](./hooks.md)
- [Command Reference](../commands/README.md)
- [GloomStalker Design](./gloomstalker-DESIGN.md)
