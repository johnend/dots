# Code Style Guidelines

**Last Updated:** 2026-02-05  
**Applies To:** All code written by AI agents

## Core Philosophy

**Readability over cleverness** - Write code that's easy to understand, maintain, and debug.

---

## Commenting Rules

### The Core Question:
**"Would a competent developer, familiar with the domain, struggle to understand WHY this code exists or WHY it's written this way?"**

If **YES** → Comment  
If **NO** → Skip the comment

### Guiding Principle:
**"Explain WHY, not WHAT (actionable comments only)"**

Comments should provide context, reasoning, and warnings - not play-by-play descriptions of obvious operations.

---

## When Comments ARE Needed

### 1. **Non-Obvious Workarounds / Hacks**
```typescript
// ✅ NEEDED - Not obvious why we're doing this weird thing
// HACK: setTimeout(0) defers execution to avoid race condition with Redux middleware.
// Direct dispatch causes stale state reads. Remove once middleware refactored.
setTimeout(() => dispatch(updateUser(data)), 0);
```

### 2. **Counter-Intuitive Logic**
```typescript
// ✅ NEEDED - This looks like a bug but isn't
// Intentionally using > instead of >= because the API returns
// inclusive ranges but our UI displays exclusive upper bounds
if (value > maxValue) {
  showError();
}
```

### 3. **Performance Optimizations**
```typescript
// ✅ NEEDED - Why we're doing something inefficient-looking
// Cache miss is expensive (~500ms API call), so we pre-fetch
// even though it wastes memory for users who never expand the section
await prefetchUserDetails(userId);
```

### 4. **Security Considerations**
```typescript
// ✅ NEEDED - Security rationale not obvious from code
// Must sanitize here (not just in DB layer) to prevent XSS in error messages
// which bypass our usual template escaping
const sanitizedInput = escapeHtml(userInput);
```

### 5. **External Constraints (APIs, Libraries, Browsers)**
```typescript
// ✅ NEEDED - External behavior that's not documented or surprising
// Safari 15.x has a bug where FormData.get() returns null for files > 50MB.
// Workaround: Access via entries() iterator instead
for (const [key, value] of formData.entries()) { ... }
```

### 6. **Temporal Context (Will Change Soon)**
```typescript
// ✅ NEEDED - Temporary code that shouldn't be permanent
// TODO(2026-Q2): Remove this fallback once all clients upgraded to v3 API
if (!response.newField) {
  response.newField = legacyTransform(response.oldField);
}
```

### 7. **Magic Numbers / Constants**
```typescript
// ✅ NEEDED - Non-obvious constant
// 43200000ms = 12 hours. Matches server-side session timeout.
const SESSION_TIMEOUT = 43200000;

// ❌ NOT NEEDED - Obvious constant
const MILLISECONDS_PER_SECOND = 1000; // This is self-explanatory
```

### 8. **Complex Algorithms**
```typescript
// ✅ NEEDED - Explain the algorithm choice
// Using Levenshtein distance instead of Jaro-Winkler because
// we care about transposition cost more than prefix matching
const distance = levenshtein(str1, str2);
```

---

## When Comments Are NOT Needed

### 1. **Standard Business Logic**
```typescript
// ❌ NOT NEEDED - This is standard business logic
// UK regulations require explicit consent for each marketing channel
if (user.region === 'UK') {
  requireExplicitConsent = true;
}

// Code is clear without comment:
if (user.region === 'UK') {
  requireExplicitConsent = true;
}
```
**Why skip?** Any dev working on consent features should understand regional compliance requirements. It's domain knowledge, not code knowledge.

### 2. **Self-Documenting Code**
```typescript
// ❌ NOT NEEDED - Function name explains everything
// Calculate the total price including tax
const totalWithTax = calculateTotalWithTax(price, taxRate);

// Just write:
const totalWithTax = calculateTotalWithTax(price, taxRate);
```

### 3. **Standard Patterns**
```typescript
// ❌ NOT NEEDED - This is a standard React pattern
// Use effect hook to fetch data when component mounts
useEffect(() => {
  fetchUserData();
}, []);

// Just write:
useEffect(() => {
  fetchUserData();
}, []);
```

### 4. **Type Definitions / Interfaces**
```typescript
// ❌ NOT NEEDED - Types are self-documenting
interface User {
  id: string;        // The user's unique identifier
  name: string;      // The user's full name
  email: string;     // The user's email address
}

// Just write:
interface User {
  id: string;
  name: string;
  email: string;
}
```

### 5. **Simple Validation**
```typescript
// ❌ NOT NEEDED - Obvious validation
// Check if email is valid before proceeding
if (!isValidEmail(email)) {
  return;
}

// Just write:
if (!isValidEmail(email)) {
  return;
}
```

---

## Gray Areas - Use Judgment

### External Dependencies Behavior
```typescript
// 🤔 MAYBE NEEDED - Depends on how well-known the library is

// Common library (lodash, React):
const uniqueUsers = _.uniqBy(users, 'id'); // No comment needed

// Obscure library or surprising behavior:
// library-x has a bug where uniqBy mutates the original array
// https://github.com/library-x/issues/1234
const uniqueUsers = _.cloneDeep(users).uniqBy('id');
```

### Business Rules (When to Comment)
- **Simple rules**: Skip comment
- **Complex multi-step rules**: Add comment explaining the full context
- **Rules with exceptions**: Comment the exceptions

```typescript
// ❌ NOT NEEDED - Simple rule
if (user.isPremium) {
  features.push('advanced-analytics');
}

// ✅ NEEDED - Complex rule with exceptions
// Premium users get advanced analytics UNLESS they're on legacy plan (pre-2024)
// or in beta regions (APAC) where analytics aren't available yet.
// See: JIRA-1234 for full requirements
if (user.isPremium && !user.isLegacyPlan && !isBetaRegion(user.region)) {
  features.push('advanced-analytics');
}
```

---

## Testing the "Should I Comment?" Question

Ask yourself:
1. **"Is this surprising?"** → Comment
2. **"Did I have to look something up to write this?"** → Comment
3. **"Will this confuse someone during code review?"** → Comment
4. **"Is there a gotcha or edge case?"** → Comment
5. **"Is this temporary or a hack?"** → Comment
6. **"Is this standard practice in our domain?"** → Skip comment

---

## Special Cases

### Config Files (e.g., opencode.jsonc)
```jsonc
// ✅ GOOD - Config benefits from explaining sections
"agent": {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🚫 DISABLED NATIVE AGENTS
  // Native OpenCode agents disabled in favor of custom agent system.
  // To re-enable, uncomment and set "disable": false
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  "build": {
    "disable": true
  }
}
```
**Config files** are different - they're read/edited infrequently, so more comments = better.

---

## Summary - When to Comment

### ✅ **DO Comment:**
- Workarounds / hacks
- Counter-intuitive logic
- Performance trade-offs
- Security decisions
- External constraints (browser bugs, API quirks)
- TODOs with timeline
- Magic numbers (when not extractable to constant)
- Complex algorithms (explain the choice)

### ❌ **DON'T Comment:**
- Standard business logic
- Self-documenting code
- Standard patterns (React hooks, common algorithms)
- Type definitions
- Simple validation
- Obvious operations

### 🤔 **Use Judgment:**
- External library behavior (common vs obscure)
- Complex business rules (simple vs multi-conditional)
- Domain knowledge (is this common knowledge in our field?)

---

## Language-Specific Style Guidelines

### Shell Scripts (Bash/Zsh)
- **Indentation:** 2 spaces
- **Safety:** Always use `set -euo pipefail` at the top
- **Constants:** UPPER_SNAKE_CASE
- **Variables:** lowercase_snake_case
- **Functions:** lowercase_snake_case

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly MAX_RETRIES=3
retry_count=0

check_service_status() {
  # Function body
}
```

### TypeScript/JavaScript
- **Style:** Follow project ESLint/Prettier configuration
- **Naming:**
  - Constants: UPPER_SNAKE_CASE or camelCase (depending on project)
  - Variables: camelCase
  - Classes: PascalCase
  - Private members: _prefixWithUnderscore (if project convention)

### General Principles
- **Prefer explicit over implicit**
- **Prefer verbose names over abbreviations** (unless widely known: `id`, `url`, `api`)
- **Use descriptive variable names** that explain intent
- **Keep functions small and focused** (single responsibility)

---

## Code Review Considerations

When reviewing code (or having code reviewed):
- **If you need to explain the code verbally** → Add a comment
- **If the reviewer asks "why?"** → Add a comment
- **If you had to debug this once** → Add a comment explaining the gotcha
- **If it took you >5 minutes to understand** → Consider refactoring or commenting

---

**Remember:** The best code needs no comments because it's self-explanatory. The second-best code has comments that explain the non-obvious. The worst code has comments that restate the obvious.

**Key Insight:** Comment the surprising, not the standard.
