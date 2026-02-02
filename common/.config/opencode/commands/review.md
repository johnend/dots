---
description: Review code changes against project standards
agent: investigator
---

# Code Review

Review current changes (git diff) against project standards and best practices.

## Review Criteria

1. **Code Quality**
   - Readability and clarity
   - Naming conventions
   - Code organization
   - Comments where needed

2. **Project Patterns**
   - Load project context for standards
   - Check consistency with existing code
   - Verify pattern adherence

3. **Potential Issues**
   - Logic errors
   - Edge cases
   - Performance concerns
   - Security issues

4. **Test Coverage**
   - Are tests included?
   - Do tests cover edge cases?
   - Test quality and clarity

5. **TypeScript/Type Safety** (if applicable)
   - No `any` types
   - No type assertions (`as`, `!`)
   - Proper error handling

## Process

1. Load project context (tech stack, patterns)
2. Run `git diff` to see changes
3. Analyze each change against criteria
4. Provide constructive feedback

## Output Format

```
Code Review
===========

✅ Looks Good:
- Clean function naming
- Proper error handling
- Tests included

💡 Suggestions:
- Consider extracting this into a separate function
- Could add edge case test for empty array

⚠️  Concerns:
- Using 'any' type on line 45 - specify proper type
- Missing null check before accessing property

Overall: Ready to commit with suggested improvements
```
