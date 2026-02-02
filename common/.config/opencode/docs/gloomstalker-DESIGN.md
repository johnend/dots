# GloomStalker Agent Design

**Version:** 1.0.0  
**Status:** Design Complete ✅  
**Phase:** 2 (Context Discovery)

## Purpose

**GloomStalker** is a specialized agent that **scouts ahead** before code generation, discovering and loading the minimal necessary context for a given task. Named after the D&D Ranger subclass that excels at scouting in darkness.

## Core Concept

```
User Task → GloomStalker Analyzes → Loads Minimal Context → Main Agent Executes
     ↓              ↓                       ↓                      ↓
 "Add test"    Detects keywords      testing-patterns.md    Artificer writes test
                                     + project testing
```

## Design Principles

### 1. Scout Before Build
- **Never** start code generation without context
- **Always** load relevant patterns first
- **Minimize** token usage (only load what's needed)

### 2. Hierarchical Loading
Load in order of specificity:
```
1. General (Personal) - Always loaded (user-preferences)
2. Work/Personal (Context-specific) - Based on project type
3. Core (Patterns) - If keywords match
4. Domain (UI/Backend) - If task involves UI/backend
5. Project (Specific) - Current project context
```

### 3. Keyword-Based Discovery
Analyze user task for keywords:
```
"Add a test for login form"
  ↓
Keywords: ["test", "login", "form"]
  ↓
Load: testing-patterns.md, react-patterns.md
```

### 4. Metadata-Driven
Use `project-metadata.json` to determine which files to load:
```json
{
  "contextFiles": {
    "testing.md": {
      "keywords": ["test", "jest", "cypress"],
      "priority": 2
    }
  }
}
```

## Agent Behavior

### Input
- **User task** (string)
- **Current working directory** (path)
- **Current project** (detected from directory)

### Process
1. **Detect project** from working directory (work/personal/unknown)
2. **Determine project type** (work or personal)
3. **Extract keywords** from user task
4. **Match keywords** against pattern files
5. **Load context files** in hierarchical order (general → work/personal → project)
6. **Return context** to main agent

### Output
- **Context files** (list of file paths)
- **Priority order** (which to load first)
- **Summary** (what was loaded and why)

## Keyword Detection

### Universal Keywords (Core Patterns)
```typescript
const CORE_KEYWORDS = {
  'testing-patterns.md': [
    'test', 'spec', 'jest', 'cypress', 'detox', 'e2e',
    'unit test', 'integration test', 'component test',
    'pact', 'contract', 'storybook', 'percy', 'chromatic'
  ],
  'state-management.md': [
    'state', 'redux', 'store', 'slice', 'selector',
    'zustand', 'tanstack query', 'query', 'mutation',
    'cache', 'recoil', 'context'
  ],
  'api-patterns.md': [
    'api', 'fetch', 'axios', 'graphql', 'apollo',
    'endpoint', 'request', 'response', 'auth', 'token',
    'jwt', 'authentication', 'authorization'
  ],
  'nx-monorepo.md': [
    'nx', 'monorepo', 'affected', 'workspace', 'library',
    'lib', 'project.json', 'nx.json'
  ],
  'react-native-patterns.md': [
    'react native', 'native', 'ios', 'android',
    'platform', 'navigation', 'navigation stack',
    'flatlist', 'flashlist', 'detox', 'reanimated'
  ]
};
```

### Domain Keywords (UI/Backend)
```typescript
const DOMAIN_KEYWORDS = {
  'react-patterns.md': [
    'react', 'component', 'hook', 'useeffect', 'usestate',
    'props', 'jsx', 'tsx', 'render', 'memo', 'callback'
  ],
  'fela-styling.md': [
    'fela', 'style', 'css', 'styling', 'theme',
    'formation', 'rule', 'renderer'
  ],
  'styled-components.md': [
    'styled-components', 'styled', 'emotion', 'css',
    'theme', 'global style'
  ]
};
```

### Fuzzy Matching
Use fuzzy matching for flexibility:
```typescript
'testing' → matches 'test'
'authentication' → matches 'auth'
'component test' → matches 'test' AND 'component'
```

## Context Loading Strategy

### Always Load (Priority 1)
```
1. general/user-preferences.md (always)
2. work/conventions.md (work projects only)
3. personal/projects/{project}/context.md (personal projects only)
4. work/projects/{project}/core.md (work projects only)
```

### Conditionally Load (Priority 2-5)
Based on keywords detected in task and project type:
```
Priority 2: Core patterns matching keywords
  - general/core/* (for personal/unknown projects)
  - work/core/* (for work projects)
  
Priority 3: Domain patterns matching keywords
  - general/ui/* (for personal/unknown projects)
  - work/ui/* (for work projects)
  
Priority 4: Project-specific files matching keywords
  - work/projects/{project}/* (work projects)
  - personal/projects/{project}/* (personal projects)
  
Priority 5: Related contexts from metadata
```

### Example: "Add a test for the login form in sportsbook"

**Keyword Analysis:**
- "test" → testing-patterns.md
- "login form" → react-patterns.md
- "sportsbook" → projects/sportsbook/*

**Loading Order:**
```
Priority 1 (Always):
1. general/user-preferences.md
2. work/conventions.md
3. work/projects/sportsbook/core.md

Priority 2 (Core - Keywords matched):
4. work/core/testing-patterns.md (keyword: "test")

Priority 3 (Domain - Keywords matched):
5. work/ui/web/react-patterns.md (keyword: "form")

Priority 4 (Project - Keywords matched):
6. work/projects/sportsbook/testing.md (keyword: "test" + project match)

Skipped (No match):
- work/core/state-management.md (no state keywords)
- work/core/api-patterns.md (no API keywords)
- work/ui/web/fela-styling.md (no styling keywords)
```

**Token Savings:**
- Without GloomStalker: Load all 9 core files (~1,380 lines)
- With GloomStalker: Load 6 files (~795 lines)
- **Savings: 42% fewer tokens**

## Integration with Artificer

### Before GloomStalker
```
User: "Add a test for login"
  ↓
Artificer: Loads ALL context files
  ↓
Artificer: Writes test (using 1,380 lines of context)
```

### After GloomStalker
```
User: "Add a test for login"
  ↓
GloomStalker: Analyzes task → Detects "test" + "login"
  ↓
GloomStalker: Loads testing-patterns.md + react-patterns.md
  ↓
Artificer: Writes test (using 305 lines of context)
  ↓
Token savings: 78%
```

## Metadata File Format

### Structure
```json
{
  "version": "2.0.0",
  "project": "sportsbook",
  "description": "Brief project description",
  "contextFiles": {
    "core.md": {
      "alwaysLoad": true,
      "priority": 1,
      "description": "Core tech stack and structure"
    },
    "testing.md": {
      "alwaysLoad": false,
      "priority": 2,
      "keywords": ["test", "jest", "cypress", "detox"],
      "description": "Testing strategies and tools"
    }
  },
  "relatedContexts": [
    "~/.config/opencode/context/work/core/nx-monorepo.md",
    "~/.config/opencode/context/work/core/testing-patterns.md"
  ],
  "tags": ["react-native", "web", "nx", "monorepo"]
}
```

### Fields
- `alwaysLoad`: Load regardless of keywords (true for core.md)
- `priority`: Loading order (1 = first)
- `keywords`: Keywords that trigger loading
- `description`: Human-readable summary
- `relatedContexts`: Other files that might be useful
- `tags`: Project categorization

## Implementation Plan

### Phase 2.1: Keyword Detector
**File:** `~/.config/opencode/agents/gloomstalker/keyword-detector.ts`

```typescript
interface KeywordMatch {
  file: string;
  keywords: string[];
  priority: number;
}

export const detectKeywords = (task: string): KeywordMatch[] => {
  // Extract keywords from task
  // Match against CORE_KEYWORDS and DOMAIN_KEYWORDS
  // Return matched files with priority
};
```

### Phase 2.2: Context Loader
**File:** `~/.config/opencode/agents/gloomstalker/context-loader.ts`

```typescript
interface ContextFile {
  path: string;
  priority: number;
  reason: string;
}

export const loadContext = (
  task: string,
  projectPath: string
): ContextFile[] => {
  // Detect project from path
  // Detect keywords from task
  // Load metadata files
  // Determine which files to load
  // Return ordered list
};
```

### Phase 2.3: Integration Hook
**File:** `~/.config/opencode/agents/gloomstalker/hook.ts`

```typescript
export const gloomstalkerHook = async (
  task: string,
  workingDir: string
): Promise<string[]> => {
  // Analyze task
  // Load context files
  // Return file paths to load
};
```

### Phase 2.4: Artificer Integration
Update Artificer system prompt:
```markdown
Before executing any task:
1. Call GloomStalker to determine context needs
2. Load only the context files returned
3. Proceed with task execution

DO NOT load all context files by default.
```

## Success Metrics

### Token Efficiency
- **Target:** 40-60% token reduction on average tasks
- **Measure:** Compare tokens used before/after GloomStalker

### Accuracy
- **Target:** 95%+ correct context loading
- **Measure:** Did agent have necessary context to complete task?

### Speed
- **Target:** <1 second context discovery
- **Measure:** Time from task received to context loaded

### User Satisfaction
- **Target:** Faster response times, accurate results
- **Measure:** User feedback, task completion rate

## Edge Cases

### 1. No Keywords Detected
**Scenario:** "Do something"  
**Behavior:** Load only Priority 1 (always load) files

### 2. Too Many Keywords
**Scenario:** "Test the API auth state management"  
**Behavior:** Load all matching files, respect priority

### 3. Project Not Detected
**Scenario:** Working in unknown directory  
**Behavior:** Load only general patterns (user-preferences), no work/personal context

### 4. Personal Project Detected
**Scenario:** Working in `~/Developer/personal/my-project`  
**Behavior:** Load general patterns + personal project context (no work patterns)

## Testing Strategy

### Unit Tests
```typescript
describe('GloomStalker', () => {
  it('should detect test keywords', () => {
    const result = detectKeywords('Add a test');
    expect(result).toContain('testing-patterns.md');
  });

  it('should load hierarchically', () => {
    const result = loadContext('Add a test', '~/work/sportsbook');
    expect(result[0].path).toContain('user-preferences.md');
    expect(result[1].path).toContain('conventions.md'); // work project
  });
});
```

### Integration Tests
```typescript
describe('GloomStalker Integration', () => {
  it('should reduce token usage by 40%+', async () => {
    const withoutGS = await loadAllContext();
    const withGS = await gloomstalkerHook('Add a test', '~/work/sportsbook');
    
    const reduction = (withoutGS.length - withGS.length) / withoutGS.length;
    expect(reduction).toBeGreaterThan(0.4);
  });
});
```

### Manual Testing
```
Test Case 1: Simple task
Task: "Add a test"
Expected: Load testing-patterns.md only
Result: ✅ Passed

Test Case 2: Complex task
Task: "Add Redux state for API auth with tests"
Expected: Load state-management.md, api-patterns.md, testing-patterns.md
Result: ✅ Passed

Test Case 3: Unknown project
Task: "Do something" (in ~/random-project)
Expected: Load only core patterns
Result: ✅ Passed
```

## Future Enhancements

### Phase 2.5: Learning System
- Track which context files are actually used
- Improve keyword detection over time
- Suggest new keywords for metadata

### Phase 2.6: Context Caching
- Cache loaded context files
- Reuse if same task repeated
- Invalidate on file changes

### Phase 2.7: Smart Prefetching
- Predict likely next tasks
- Prefetch context files
- Reduce latency

## Risks & Mitigations

### Risk: Miss necessary context
**Mitigation:** Start with broader keywords, narrow over time

### Risk: Load too much context
**Mitigation:** Strict priority enforcement, keyword thresholds

### Risk: Slow keyword detection
**Mitigation:** Use regex, not AI, for keyword matching

### Risk: Metadata out of sync
**Mitigation:** Validation script, CI checks

## Deployment

### Phase 2.1: Prototype (This Session)
- Implement keyword detector
- Test with sample tasks
- Measure token reduction

### Phase 2.2: Beta (Next Session)
- Full context loader implementation
- Integration with Artificer
- Real-world testing

### Phase 2.3: Production (Week 2)
- Enable by default
- Monitor performance
- Gather user feedback

---

**Status:** Design complete, ready for implementation  
**Next Step:** Implement keyword detector
