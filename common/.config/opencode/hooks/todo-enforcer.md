# Todo Enforcement Hook

**Hook Type:** `pre-execution`  
**Trigger:** After user submits prompt, before agent responds  
**Priority:** High (runs early in pipeline)  
**Status:** Specification (to be implemented in OpenCode TUI)

## Purpose

Automatically detect multi-step tasks and enforce todo creation before allowing execution. This ensures users have visibility into progress and can resume work if interrupted.

## Detection Logic

### Multi-Step Indicators

A task is considered multi-step if it has **2 or more** of these indicators:

**1. Multiple Action Verbs (2+)**
```typescript
const actionVerbs = [
  'add', 'create', 'implement', 'write', 'refactor', 'update',
  'fix', 'test', 'deploy', 'build', 'configure', 'setup',
  'remove', 'delete', 'modify', 'change', 'migrate', 'upgrade'
];

// Count occurrences in user prompt
const verbCount = actionVerbs.reduce((count, verb) => {
  const regex = new RegExp(`\\b${verb}\\b`, 'gi');
  return count + (prompt.match(regex) || []).length;
}, 0);

if (verbCount >= 2) {
  multiStep = true;
}
```

**2. Conjunctions Indicating Sequential Steps**
```typescript
const conjunctions = /\b(and|then|after|before|also|plus)\b/i;
if (conjunctions.test(prompt)) {
  multiStep = true;
}
```

**3. Complexity Indicators**
```typescript
// Long requests are usually complex
if (prompt.length > 200) {
  multiStep = true;
}

// Mentions multiple files/components
const filePattern = /\b\d+\s*(files?|components?|services?|tests?)\b/i;
if (filePattern.test(prompt)) {
  multiStep = true;
}
```

**4. Cross-Cutting Concerns**
```typescript
const crossCutting = [
  /\bacross\s+\w+\s+and\s+\w+\b/i,  // "across X and Y"
  /\bmultiple\s+(apps?|projects?|services?)\b/i,
  /\ball\s+\w+\b/i  // "all components", "all tests"
];

if (crossCutting.some(pattern => pattern.test(prompt))) {
  multiStep = true;
}
```

### Examples

**Multi-Step (Enforce Todos):**
```
✅ "Add authentication to login page and write tests"
   → 2 verbs (add, write), conjunction (and)

✅ "Refactor UserService across sportsbook and raf-app"
   → Cross-cutting (across X and Y)

✅ "Create API endpoint, update Redux state, and add UI"
   → 3 verbs (create, update, add), conjunctions (and)

✅ "Implement login flow with validation, error handling, and tests"
   → Complex (>200 chars), conjunctions, multiple aspects
```

**Single-Step (No Todos Required):**
```
❌ "Fix typo in README"
   → 1 verb (fix), single file

❌ "Add import statement to helpers.ts"
   → 1 verb (add), trivial change

❌ "Run tests"
   → 1 verb (run), single command
```

## Enforcement Flow

### Step 1: Detect Multi-Step Task

```typescript
function detectMultiStep(prompt: string): boolean {
  let score = 0;
  
  // Count action verbs
  const verbCount = countActionVerbs(prompt);
  if (verbCount >= 2) score += 2;
  
  // Check for conjunctions
  if (hasConjunctions(prompt)) score += 1;
  
  // Check complexity
  if (prompt.length > 200) score += 1;
  if (mentionsMultipleFiles(prompt)) score += 1;
  
  // Check cross-cutting concerns
  if (hasCrossCutting(prompt)) score += 2;
  
  // Multi-step if score >= 2
  return score >= 2;
}
```

### Step 2: Check for Existing Todos

```typescript
function checkExistingTodos(): boolean {
  // Query OpenCode session state
  const currentSession = getSessionState();
  return currentSession.todos && currentSession.todos.length > 0;
}
```

### Step 3: Block or Allow

```typescript
async function todoEnforcer(context: ExecutionContext): Promise<EnforcementResult> {
  const userPrompt = context.message;
  
  // Detect multi-step task
  const isMultiStep = detectMultiStep(userPrompt);
  
  if (!isMultiStep) {
    // Single-step task, proceed normally
    return {
      blockExecution: false,
      message: null
    };
  }
  
  // Multi-step task detected, check for todos
  const hasTodos = checkExistingTodos();
  
  if (hasTodos) {
    // Todos already exist, proceed
    return {
      blockExecution: false,
      message: null
    };
  }
  
  // Multi-step + no todos = BLOCK
  return {
    blockExecution: true,
    message: generateTodoRequiredMessage(userPrompt)
  };
}
```

### Step 4: Generate Enforcement Message

```typescript
function generateTodoRequiredMessage(prompt: string): string {
  return `
🚦 MULTI-STEP TASK DETECTED

This request appears to have multiple steps. Please create a todo list before proceeding.

**Why todos are required:**
1. **Visibility** - User can track progress in real-time
2. **Recovery** - Resume work if interrupted
3. **Clarity** - Break down complex task into atomic steps
4. **Quality** - Less likely to forget steps

**How to proceed:**
1. Call \`todowrite\` tool with task breakdown
2. Then I'll proceed with implementation

**Example breakdown for your task:**
${generateSuggestedTodos(prompt)}

After creating todos, I'll begin work immediately.
  `.trim();
}

function generateSuggestedTodos(prompt: string): string {
  // Use simple heuristics to suggest todo breakdown
  const verbs = extractActionVerbs(prompt);
  const suggestions = verbs.map((verb, index) => {
    return `  ${index + 1}. ${capitalizeFirst(verb)} [specific task based on context]`;
  }).join('\n');
  
  return `
\`\`\`typescript
todowrite([
${suggestions}
])
\`\`\`
  `.trim();
}
```

## Integration Points

### Hook Registration

```typescript
// In OpenCode TUI configuration
{
  "hooks": {
    "pre-execution": [
      {
        "name": "todo-enforcer",
        "path": "~/.config/opencode/hooks/todo-enforcer.ts",
        "enabled": true,
        "priority": 10  // Run early (higher = earlier)
      }
    ]
  }
}
```

### Session State Management

```typescript
interface SessionState {
  todos: Todo[];
  currentTodo: string | null;
  history: Message[];
}

interface Todo {
  id: string;
  content: string;
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled';
  priority: 'low' | 'medium' | 'high';
  createdAt: Date;
  updatedAt: Date;
}
```

## Configuration

### User Preferences

```typescript
// In ~/.config/opencode/config.json
{
  "hooks": {
    "todo-enforcer": {
      "enabled": true,
      "sensitivity": "medium",  // low, medium, high
      "autoSuggest": true,      // Suggest todo breakdown
      "allowOverride": false    // Allow user to skip todos (not recommended)
    }
  }
}
```

### Sensitivity Levels

**Low (score >= 3 to trigger):**
- Only very obvious multi-step tasks
- Fewer false positives
- More user discretion

**Medium (score >= 2 to trigger) [Recommended]:**
- Balanced approach
- Most multi-step tasks caught
- Minimal false positives

**High (score >= 1 to trigger):**
- Very aggressive
- Catches borderline cases
- May have false positives

## Testing

### Test Cases

```typescript
describe('Todo Enforcer', () => {
  it('should detect multi-step task with multiple verbs', () => {
    const prompt = "Add authentication and write tests";
    expect(detectMultiStep(prompt)).toBe(true);
  });
  
  it('should detect multi-step task with cross-cutting concerns', () => {
    const prompt = "Refactor auth across sportsbook and raf-app";
    expect(detectMultiStep(prompt)).toBe(true);
  });
  
  it('should NOT detect single-step task', () => {
    const prompt = "Fix typo in README";
    expect(detectMultiStep(prompt)).toBe(false);
  });
  
  it('should allow execution if todos exist', () => {
    const prompt = "Add auth and tests";
    mockSessionState({ todos: [{ id: '1', content: 'test', status: 'pending' }] });
    const result = todoEnforcer({ message: prompt });
    expect(result.blockExecution).toBe(false);
  });
  
  it('should block execution if multi-step and no todos', () => {
    const prompt = "Add auth and tests";
    mockSessionState({ todos: [] });
    const result = todoEnforcer({ message: prompt });
    expect(result.blockExecution).toBe(true);
  });
});
```

### Manual Testing

**Test 1: Simple Task (Should NOT Block)**
```
User: "Fix typo in README"
Expected: Executes immediately, no todos required
```

**Test 2: Multi-Step Task (Should Block)**
```
User: "Add authentication and write tests"
Expected: Blocks with message asking for todos
```

**Test 3: Multi-Step with Todos (Should NOT Block)**
```
User: "Add authentication and write tests"
Agent: Creates todos first
User: Continues
Expected: Executes normally since todos exist
```

**Test 4: Borderline Case**
```
User: "Refactor authentication"  (single verb, but potentially complex)
Expected: Depends on sensitivity setting
- Low: Likely allows (score < 3)
- Medium: Might block (depends on length/context)
- High: Likely blocks (score >= 1)
```

## Metrics

### Success Metrics

**Todo Adoption Rate:**
```
Target: 90%+ of multi-step tasks have todos
Measure: (multi-step tasks with todos) / (total multi-step tasks)
```

**False Positive Rate:**
```
Target: <10% of single-step tasks incorrectly flagged
Measure: (single-step incorrectly flagged) / (total single-step tasks)
```

**Task Completion Rate:**
```
Target: 95%+ of tasks with todos reach completion
Measure: (todos completed) / (todos created)
```

### Monitoring

```typescript
interface TodoEnforcerMetrics {
  totalTasksAnalyzed: number;
  multiStepDetected: number;
  singleStepDetected: number;
  todosCreated: number;
  tasksBlocked: number;
  falsePositives: number;  // User-reported
  userOverrides: number;   // If allowOverride enabled
}
```

## Future Enhancements

### Phase 4.5: Smart Todo Suggestions

```typescript
// Use LLM to generate better todo breakdown
async function generateSmartTodos(prompt: string): Promise<Todo[]> {
  const llmResponse = await callLLM({
    prompt: `Break down this task into atomic todos: "${prompt}"`,
    temperature: 0.3
  });
  
  return parseTodoList(llmResponse);
}
```

### Phase 4.6: Todo Templates

```typescript
// Pre-defined templates for common tasks
const todoTemplates = {
  'authentication': [
    'Create auth service with login/logout methods',
    'Add auth state management (Redux/Zustand)',
    'Create login UI component',
    'Add protected route wrapper',
    'Write unit tests for auth service',
    'Write E2E tests for login flow'
  ],
  'api-endpoint': [
    'Define API route and handler',
    'Add request/response types',
    'Implement business logic',
    'Add error handling',
    'Write unit tests',
    'Update API documentation'
  ]
};
```

### Phase 4.7: Todo Progress Tracking

```typescript
// Real-time progress visualization
interface TodoProgress {
  total: number;
  completed: number;
  inProgress: number;
  pending: number;
  percentComplete: number;
  estimatedTimeRemaining: number;  // Based on historical data
}
```

## Rollback

If todo enforcement causes issues:

```typescript
// Disable in config
{
  "hooks": {
    "todo-enforcer": {
      "enabled": false
    }
  }
}

// Or remove hook file
rm ~/.config/opencode/hooks/todo-enforcer.ts
```

## References

- **oh-my-opencode**: Original todo enforcement concept
- **User preferences**: Manual tracking, explicit approval
- **Session state management**: OpenCode TUI session handling
- **Hook system**: OpenCode TUI plugin architecture

---

**Created:** 2026-02-02  
**Status:** Specification (awaiting OpenCode TUI implementation)  
**Phase:** 4 (Todo Enforcement)
