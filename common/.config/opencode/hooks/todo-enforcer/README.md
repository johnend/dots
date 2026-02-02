# Todo Enforcer

Automatic multi-step task detection and todo enforcement for OpenCode.

## Purpose

Enforces todo creation for multi-step tasks to improve:
- **Visibility** - Track progress in real-time
- **Recovery** - Resume work if interrupted  
- **Clarity** - Break down complex tasks into atomic steps
- **Quality** - Less likely to forget steps

## Architecture

```
todo-enforcer/
├── cli.js          # CLI wrapper for command-line execution
├── detector.ts     # Multi-step task detection logic
├── enforcer.ts     # Main enforcement orchestration
├── package.json    # NPM configuration
├── tsconfig.json   # TypeScript configuration
└── dist/          # Compiled JavaScript (gitignored)
```

## Usage

### From Command Line

```bash
# Check if task is multi-step
node cli.js "Add authentication and write tests"

# Output: JSON with enforcement decision
{
  "shouldBlock": true,
  "isMultiStep": true,
  "score": 3,
  "confidence": "medium",
  "message": "🚦 MULTI-STEP TASK DETECTED...",
  "suggestedTodos": ["Add...", "Write..."],
  "indicators": ["2 action verbs found", "Sequential conjunctions detected"]
}
```

### From Artificer Agent

Artificer automatically calls todo-enforcer before executing any task:

```
1. User submits task
2. Artificer runs: node ~/.config/opencode/hooks/todo-enforcer/cli.js "task"
3. If shouldBlock=true → Show message and request todos
4. If isMultiStep=true but not blocking → Create todos  
5. If isMultiStep=false → Continue without todos
```

## Detection Logic

A task is considered multi-step if it scores **2 or more points**:

| Indicator | Points | Examples |
|-----------|--------|----------|
| Multiple action verbs (2+) | 2 | "add X **and** write Y" |
| Sequential conjunctions | 1 | "and", "then", "after" |
| Complex request (>200 chars) | 1 | Long detailed requests |
| Multiple files mentioned | 1 | "3 files", "several components" |
| Cross-cutting concerns | 2 | "across X and Y", "multiple apps" |

### Examples

**Multi-Step Tasks (Require Todos):**
```
✅ "Add authentication and write tests" (score: 3)
   → 2 verbs + conjunction

✅ "Refactor UserService across sportsbook and raf-app" (score: 3)
   → Cross-cutting concerns + conjunction

✅ "Create API endpoint, update Redux state, and add UI" (score: 3)
   → 3 verbs + conjunctions
```

**Single-Step Tasks (No Todos):**
```
❌ "Fix typo in README" (score: 0)
   → 1 verb, single file

❌ "Run npm install" (score: 0)
   → 1 verb, single command
```

## CLI Options

```bash
# Basic usage
node cli.js "task description"

# With existing todos (won't block)
node cli.js "task description" --has-todos

# Debug mode (show detection details)
node cli.js "task description" --debug

# Change sensitivity
node cli.js "task description" --sensitivity=high

# Show help
node cli.js --help
```

## Sensitivity Levels

- **Low** (threshold: 3) - Only obvious multi-step tasks
- **Medium** (threshold: 2) - Balanced [Default]
- **High** (threshold: 1) - Aggressive, catches borderline cases

## Development

### Build

```bash
npm install
npm run build
```

### Watch Mode

```bash
npm run watch
```

### Test

```bash
# Test single-step
node cli.js "Fix typo in README"

# Test multi-step
node cli.js "Add auth and write tests"

# Test with debug
node cli.js "Refactor across apps" --debug
```

## Integration

This CLI is automatically called by the Artificer agent as Step 2 in its execution workflow:

```
1. RECEIVE TASK
   ↓
2. RUN TODO-ENFORCER CLI 🚦
   ↓
3. CALL GLOOMSTALKER CLI 🔦
   ↓
... (continue execution)
```

See `agents/artificer.md` for full workflow.

## Status

✅ **Phase 4 Complete** - Todo enforcement active and working

- Detector logic implemented and tested
- CLI wrapper functional
- Integrated into Artificer workflow
- Examples added to documentation

## Related

- **GloomStalker** (`agents/gloomstalker/`) - Smart context loading
- **Artificer** (`agents/artificer.md`) - Main builder agent
- **Context System** (`context/`) - Hierarchical patterns and preferences
