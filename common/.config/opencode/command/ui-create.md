---
description: Create UI component (asks user first)
agent: bard
---

# Create UI Component

**⚠️  IMPORTANT:** User prefers doing frontend work himself. **ASK FIRST** before implementing!

## Process

1. **Ask User First**
   ```
   This involves frontend/UI work. You mentioned you prefer handling UI yourself.
   
   Would you like me to:
   1. Implement the full component with styling
   2. Create basic structure, you add styling/details
   3. Just provide guidance on approach
   
   Please choose an option.
   ```

2. **Wait for User Response**
   - Don't proceed until user chooses option
   - If user chooses option 3, provide guidance only
   - If user chooses option 2, create minimal structure
   - If user chooses option 1, proceed with full implementation

3. **If Implementing (Option 1 or 2)**
   - Load project context for UI patterns
   - Check existing components for style
   - Follow established patterns:
     - Styling approach (CSS-in-JS, Tailwind, modules, etc.)
     - Component structure
     - Props patterns
     - File naming conventions
   - Create component with proper types
   - Include basic tests if applicable

## Output

For **Option 1** (Full Implementation):
- Component file created
- Props properly typed
- Styling following project patterns
- Basic tests included
- Usage example provided

For **Option 2** (Structure Only):
- Component shell with props interface
- No styling (user will add)
- File structure following conventions
- Comments indicating where user should add details

For **Option 3** (Guidance Only):
- Recommended approach
- Pattern references from project
- Example component structures
- No actual code created
