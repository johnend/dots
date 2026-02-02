# OpenCode Hooks & CLIs

## Overview

OpenCode's three-layer safety system is powered by TypeScript CLIs that run automatically as part of the Artificer workflow. These "hooks" intercept execution at key points to provide context efficiency, task visibility, and operational safety.

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Three-Layer System                     │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  Layer 1: 🔦 GloomStalker (Context Efficiency)          │
│  Layer 2: 🚦 Todo Enforcer (Task Visibility)            │
│  Layer 3: 🛡️ Risk Assessor (Operational Safety)          │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## Layer 1: 🔦 GloomStalker

**Location:** `hooks/gloomstalker/`  
**Type:** TypeScript CLI  
**Purpose:** Smart context loading (40-60% token savings)

### Overview

GloomStalker analyzes user requests for keywords and returns a minimal list of relevant context files to load, dramatically reducing token usage while maintaining accuracy.

### How It Works

1. **Keyword Detection**
   - Extracts keywords from user's task
   - Maps keywords to patterns (e.g., "test" → testing-patterns.md)

2. **Project Detection**
   - Detects current working directory
   - Matches against known projects

3. **Hierarchical Loading**
   - Priority 1: Always-load files (user-prefs, conventions, project core)
   - Priority 2-5: Conditional files based on keywords

4. **Returns File List**
   - Outputs JSON array of file paths
   - Artificer uses Read tool to load only those files

### CLI Usage

```bash
# Basic usage
node hooks/gloomstalker/cli.js "Add a test for login API"

# Output
Files to load:
  - /Users/you/.config/opencode/context/general/user-preferences.md
  - /Users/you/.config/opencode/context/work/conventions.md
  - /Users/you/.config/opencode/context/work/core/testing-patterns.md
  - /Users/you/.config/opencode/context/work/core/api-patterns.md
  - /Users/you/.config/opencode/context/work/projects/sportsbook/core.md

Token savings: 52% (4,200 tokens vs 8,800)
```

### Configuration

Keyword mappings are defined in `keyword-detector.ts`:

```typescript
{
  'test': ['core/testing-patterns.md'],
  'api': ['core/api-patterns.md'],
  'react': ['ui/web/react-patterns.md'],
  'redux': ['core/state-management.md'],
  // ... more mappings
}
```

### Performance

- **Average execution time:** <100ms
- **Token savings:** 40-60%
- **Accuracy:** 98% (loads all necessary files)

### Implementation Details

**Files:**
- `cli.js` - CLI wrapper
- `hook.ts` - Main entry point
- `context-loader.ts` - Loading logic
- `keyword-detector.ts` - Keyword → file mapping
- `*.test.ts` - Unit tests

**Dependencies:**
- TypeScript
- Node.js built-ins only (no external deps)

---

## Layer 2: 🚦 Todo Enforcer

**Location:** `hooks/todo-enforcer/`  
**Type:** TypeScript CLI  
**Purpose:** Multi-step task detection and todo enforcement

### Overview

Todo Enforcer analyzes user requests to detect multi-step tasks. If detected, it blocks execution until todos are created, ensuring work is tracked and visible.

### How It Works

1. **Multi-Step Detection**
   - Scores task based on indicators
   - Threshold: score >= 2 = multi-step

2. **Scoring System**
   - Multiple action verbs (2+) = 2 points
   - Sequential conjunctions (and, then, after) = 1 point
   - Complex request (>200 chars) = 1 point
   - Multiple files mentioned = 1 point
   - Cross-cutting concerns (across X and Y) = 2 points

3. **Enforcement**
   - If multi-step + no todos: BLOCK
   - If multi-step + has todos: ALLOW
   - If single-step: ALLOW

4. **Suggestions**
   - Extracts action verbs from request
   - Suggests todo breakdown

### CLI Usage

```bash
# Test multi-step task
node hooks/todo-enforcer/cli.js "Add authentication and write tests"

# Output
{
  "isMultiStep": true,
  "shouldBlock": true,
  "score": 3,
  "confidence": "medium",
  "message": "🚦 MULTI-STEP TASK DETECTED...",
  "suggestedTodos": [
    "Add [specific task based on prompt context]",
    "Write [specific task based on prompt context]"
  ],
  "indicators": [
    "2 action verbs found",
    "Sequential conjunctions detected"
  ]
}
```

### CLI Options

```bash
# With existing todos (won't block)
node cli.js "Add auth and tests" --has-todos

# Debug mode
node cli.js "task" --debug

# Change sensitivity
node cli.js "task" --sensitivity=high

# Help
node cli.js --help
```

### Sensitivity Levels

- **Low (threshold: 3):** Only obvious multi-step tasks
- **Medium (threshold: 2):** Balanced [Default]
- **High (threshold: 1):** Aggressive, catches borderline cases

### Examples

**Multi-Step (Blocked):**
```bash
✓ "Add authentication and write tests" → score: 3
✓ "Refactor UserService across sportsbook and raf-app" → score: 3
✓ "Create API endpoint, update Redux, and add UI" → score: 3
```

**Single-Step (Allowed):**
```bash
✓ "Fix typo in README" → score: 0
✓ "Run npm install" → score: 0
```

### Implementation Details

**Files:**
- `cli.js` - CLI wrapper
- `detector.ts` - Multi-step detection logic
- `enforcer.ts` - Main enforcement orchestration

**Exit Codes:**
- `0` - Safe to proceed
- `1` - Blocked (multi-step, no todos)

See [hooks/todo-enforcer/README.md](../hooks/todo-enforcer/README.md) for detailed documentation.

---

## Layer 3: 🛡️ Risk Assessor

**Location:** `hooks/risk-assessor/`  
**Type:** TypeScript CLI  
**Purpose:** Destructive operation detection and risk assessment

### Overview

Risk Assessor evaluates operations before execution to detect destructive patterns. It blocks critical operations, requires confirmation for high-risk ones, and warns about medium-risk operations.

### How It Works

1. **Pattern Detection**
   - Scans operation for 30+ destructive patterns
   - Categorizes by type (git, file, database, system, etc.)

2. **Critical Target Detection**
   - Identifies operations targeting critical files/dirs
   - System dirs: `/usr`, `/etc`, `/var`
   - Main branches: `main`, `master`
   - Important files: `package.json`, `.env`, `.git`
   - Production indicators: `production`, `prod`

3. **Risk Scoring**
   - Base score from operation severity
   - +2 per critical target
   - +5 if production context

4. **Risk Levels**
   - **Critical (10+):** Block execution
   - **High (7-9):** Require user confirmation
   - **Medium (4-6):** Warn and proceed
   - **Low (1-3):** Info only
   - **None (0):** Safe

### CLI Usage

```bash
# Test critical risk
node hooks/risk-assessor/cli.js "git push --force origin main"

# Output
{
  "riskLevel": "critical",
  "shouldBlock": true,
  "shouldWarn": false,
  "shouldProceed": false,
  "score": 12,
  "reasons": [
    "1 high-severity destructive operation(s) detected",
    "Targets critical file(s)/directory(s): main",
    "No backup detected or confirmed"
  ],
  "recommendations": [
    "🛑 STOP: This operation is extremely dangerous",
    "Create a backup before proceeding",
    "Review git documentation for safer approaches"
  ],
  "operations": [{
    "type": "git-force",
    "command": "git push --force",
    "severity": "critical"
  }],
  "criticalTargets": ["main"]
}
```

### CLI Options

```bash
# Production environment (adds +5 to score)
node cli.js "DROP DATABASE myapp" --production

# Has backup (removes warning)
node cli.js "git reset --hard" --has-backup

# User confirmed (allows high-risk to proceed)
node cli.js "git branch -D old" --confirmed

# Debug mode
node cli.js "rm -rf node_modules" --debug

# Help
node cli.js --help
```

### Detected Patterns (30+)

**Git Operations:**
- `git push --force` → critical
- `git reset --hard` → critical
- `git branch -D` → high
- `git rebase` → medium
- `git commit --amend` → medium

**File Operations:**
- `rm -rf` → critical
- `del /s` (Windows) → high
- `> file` (overwrite) → medium
- `mv` → low

**Database Operations:**
- `DROP DATABASE` → critical
- `TRUNCATE TABLE` → high
- `DELETE FROM` (no WHERE) → critical
- `DELETE FROM ... WHERE` → medium

**System Commands:**
- `sudo rm` → critical
- `kill -9` → medium
- `chmod 000` → high

**Package Operations:**
- `npm uninstall` → low
- Remove `package-lock.json` → medium

### Exit Codes

- `0` - Safe to proceed (low/none risk)
- `1` - Should warn (medium/high risk)
- `2` - Blocked (critical risk)

### Implementation Details

**Files:**
- `cli.js` - CLI wrapper
- `detector.ts` - Pattern detection (30+ patterns)
- `assessor.ts` - Risk scoring and categorization

See [hooks/risk-assessor/README.md](../hooks/risk-assessor/README.md) for detailed documentation.

---

## Integration with Artificer

### Execution Flow

```
┌─────────────────┐
│  USER REQUEST   │
└────────┬────────┘
         ↓
┌────────▼────────┐
│   ARTIFICER     │
└────────┬────────┘
         │
         ├─→ [Step 2] 🚦 TODO ENFORCER
         │   ├─ node hooks/todo-enforcer/cli.js "task"
         │   ├─ Parse JSON response
         │   └─ Block if shouldBlock=true
         │
         ├─→ [Step 3] 🔦 GLOOMSTALKER
         │   ├─ node hooks/gloomstalker/cli.js "task"
         │   ├─ Get file list from response
         │   └─ Use Read tool to load files
         │
         ├─→ [Step 6] 🛡️ RISK ASSESSOR (before destructive ops)
         │   ├─ node hooks/risk-assessor/cli.js "operation"
         │   ├─ Parse JSON response
         │   ├─ If critical → BLOCK
         │   ├─ If high → ASK user
         │   └─ If medium → WARN
         │
         └─→ [Continue execution]
```

### Response Handling

All three CLIs return JSON:

```typescript
// Todo Enforcer
{
  isMultiStep: boolean;
  shouldBlock: boolean;
  score: number;
  suggestedTodos: string[];
  // ...
}

// GloomStalker
{
  filesToLoad: string[];
  tokenSavings: number;
  // ...
}

// Risk Assessor
{
  riskLevel: 'none' | 'low' | 'medium' | 'high' | 'critical';
  shouldBlock: boolean;
  shouldWarn: boolean;
  recommendations: string[];
  // ...
}
```

## Development

### Setup

All three CLIs require TypeScript compilation:

```bash
# Run install script (recommended)
./install.sh

# Or manually for each CLI
cd hooks/gloomstalker && npm install && npx tsc
cd hooks/todo-enforcer && npm install && npx tsc
cd hooks/risk-assessor && npm install && npx tsc
```

### Testing

Each CLI can be tested independently:

```bash
# GloomStalker
node hooks/gloomstalker/cli.js "test task"

# Todo Enforcer
node hooks/todo-enforcer/cli.js "add auth and tests"

# Risk Assessor
node hooks/risk-assessor/cli.js "git push --force"
```

### Watch Mode

For development:

```bash
cd hooks/todo-enforcer
npm run watch  # Recompiles on file changes
```

### Adding New Patterns

**Todo Enforcer - Add detection pattern:**
1. Edit `detector.ts`
2. Add pattern to detection logic
3. Update scoring system
4. Test with sample tasks

**Risk Assessor - Add destructive pattern:**
1. Edit `detector.ts`
2. Add pattern to appropriate category
3. Assign severity and score
4. Test with sample operations

## Performance

**All CLIs are designed for speed:**

| CLI | Avg Execution | Max Acceptable |
|-----|---------------|----------------|
| GloomStalker | <50ms | 100ms |
| Todo Enforcer | <30ms | 50ms |
| Risk Assessor | <30ms | 50ms |

**Total overhead per request:** <100ms (negligible compared to LLM latency)

## Future Enhancements

### GloomStalker
- Cache file analysis for repeated tasks
- LLM-powered relevance scoring
- Project-specific keyword learning

### Todo Enforcer
- LLM-powered todo suggestions (beyond keyword matching)
- Todo templates for common patterns
- Progress estimation

### Risk Assessor
- Learn from user corrections (false positives/negatives)
- Custom pattern rules per project
- Integration with CI/CD for automated checks

## Troubleshooting

### CLI Not Found

```bash
# Ensure CLIs are installed and built
./install.sh
```

### TypeScript Errors

```bash
# Rebuild TypeScript
cd <cli-directory>
npm install
npx tsc
```

### Permission Denied

```bash
# Make CLI executable
chmod +x <cli-directory>/cli.js
```

## Reference

- [Overview Documentation](./overview.md)
- [Agent Documentation](./agents.md)
- [GloomStalker README](../hooks/gloomstalker/README.md)
- [Todo Enforcer README](../hooks/todo-enforcer/README.md)
- [Risk Assessor README](../hooks/risk-assessor/README.md)
