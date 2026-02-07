# Scribe Commands

Commands for Scribe, the natural voice writing specialist who creates documentation that sounds genuinely human.

## Overview

Scribe excels at:
- Documentation (READMEs, guides, architecture docs)
- Pull request descriptions
- Commit messages
- Technical writing with natural flow
- **Chronicling to Obsidian vault**

## Available Commands

### `/chronicle`

**Purpose:** Create rich documentation in Obsidian vault with smart location routing

**When to use:**
- Document code you just wrote or explored
- Capture workflow/process you just learned
- Record learnings from session
- Create tool/setup guides
- Document concepts and patterns

**How it works:**
1. Detects working directory (work vs personal)
2. Infers appropriate Obsidian folder
3. Asks for confirmation (first time per project)
4. Caches mapping for future use
5. Creates template based on content type
6. You fill in with natural writing

**Content types auto-detected:**
- **Code** - Functions, classes, APIs, components
- **Workflow** - Processes, deployments (with Mermaid diagrams)
- **Learning** - Concepts and technologies learned
- **Tool** - Setup guides and configurations
- **Concept** - General patterns and design principles

**Location routing:**
- Work projects → `Work/Domains/{Project}/` or `Work/Knowledge/`
- Personal projects → `Personal/Projects/{Project}/`, `Personal/Learning/Notes/`, or `Personal/Knowledge/Tools/`

[See full specification →](./chronicle.md)

## Usage

### During a Scribe Session

When you're working with Scribe (via `@Scribe` in chat), you can use:

```
/chronicle Document the authentication flow we just implemented
/chronicle How to setup DynamoDB local for development
/chronicle What I learned about React Server Components
```

Scribe will:
1. Call the chronicle hook to set up file structure
2. Handle location confirmation if needed
3. Fill in the documentation using session context
4. Write in natural, human voice (Scribe's specialty)

### Standalone Usage

You can also invoke Scribe specifically for chronicling:

```
@Scribe /chronicle Document the password reset API endpoint
```

## Command Philosophy

**Scribe's chronicling principles:**

1. **Single source of truth** - Obsidian vault is the knowledge repository
2. **Context-aware** - Uses session history and code analysis
3. **Natural voice** - Writes like a human, not a documentation bot
4. **Practical focus** - Includes examples, edge cases, troubleshooting
5. **Visual when helpful** - Mermaid diagrams for workflows
6. **Honest about tradeoffs** - "Simple but works" > pretending it's perfect

## Integration with Context System

Chronicle complements the context management system:

- **Context system** (`/ctx-create`, `/ctx-update`, `/ctx-verify`)
  - Lives in: `~/.config/opencode/context/`
  - Purpose: Tell agents about project structure
  - Auto-loaded by agents when working

- **Chronicle system** (`/chronicle`)
  - Lives in: `~/Developer/personal/Obsidian/`
  - Purpose: Document what you learn and build
  - User's personal knowledge base

Both maintain single sources of truth in their respective domains.

## Examples

### Example 1: Document After Implementation

```
User: @Scribe We just implemented password reset. Can you document it?

Scribe: /chronicle Document the password reset API endpoint

[Calls chronicle hook → Creates Work/Domains/Refer-a-Friend/Password-Reset-API.md]
[Analyzes the code we just wrote]
[Fills in with clear explanations, code examples, usage patterns]

Here's the documentation I created:
[Shows path and summary]

Want me to add anything else?
```

### Example 2: Document Learning

```
User: @Scribe I finally understand how React Server Components work!

Scribe: That's great! Want me to document what you learned?

User: Yes please

Scribe: /chronicle What I learned about React Server Components

[Calls chronicle hook → Creates Personal/Learning/Notes/React-Server-Components.md]
[Reviews our conversation for key learnings]
[Writes in natural voice with examples]

Documented your learnings about RSC. I captured:
- The mental model you developed
- The "aha" moment about server-side rendering
- Practical examples from our discussion
- Resources for further learning

Check it out at: Personal/Learning/Notes/React-Server-Components.md
```

### Example 3: Document Workflow

```
User: @Scribe Can you document our deployment process?

Scribe: Absolutely! I'll need some details:
- What's the starting point? (Code merged to main?)
- What are the key steps?
- Any manual approvals or checks?
- What tools are involved?

User: [Provides details]

Scribe: /chronicle Production deployment workflow

[Calls chronicle hook → Creates Work/Domains/Refer-a-Friend/Production-Deployment.md]
[Creates step-by-step guide]
[Includes Mermaid diagram visualizing the flow]
[Adds troubleshooting section]

Created deployment workflow doc with:
- Step-by-step process
- Visual flow diagram (Mermaid)
- Commands and examples
- Common issues and solutions

Location: Work/Domains/Refer-a-Friend/Production-Deployment.md
```

## Technical Details

### Under the Hood

Chronicle uses two CLI tools:

**1. obsidian-mapper.js**
- Infers Obsidian location using fuzzy matching
- Caches confirmed mappings
- Commands:
  ```bash
  node ~/.config/opencode/hooks/obsidian-mapper.js infer <working-dir>
  node ~/.config/opencode/hooks/obsidian-mapper.js cache <type> <project> <path>
  node ~/.config/opencode/hooks/obsidian-mapper.js list
  ```

**2. scribe-chronicle.js**
- Creates documentation template
- Detects content type
- Determines target folder
- Handles file conflicts
- Commands:
  ```bash
  node ~/.config/opencode/hooks/scribe-chronicle.js "<request>" <working-dir>
  ```

### Caching System

Mappings cached in: `~/.config/opencode/obsidian-mappings.json`

```json
{
  "work": {
    "raf-app": "Work/Domains/Refer-a-Friend",
    "account-e2e": "Work/Domains/Account-E2E"
  },
  "personal": {
    "dotfiles": "Personal/Projects/Dotfiles"
  }
}
```

First time per project: confirms location  
Subsequent times: uses cached mapping

## Future Enhancements

**Potential additions:**
- `/chronicle-session` - Document entire session summary
- `/chronicle-refactor` - Document before/after of refactor
- `/chronicle-bug` - Document bug investigation and fix
- Template customization per user/project

## Notes

- Chronicle is **Scribe-only** - natural writing is the key feature
- Documents go to **Obsidian vault**, not project directory
- **Work docs are gitignored** in Obsidian (private)
- **Personal docs are tracked** in Obsidian (public)
- Scribe's natural voice makes docs actually useful to read

---

**Last Updated:** 2026-02-06  
**Commands:** 1 (/chronicle)  
**Integration:** Obsidian vault + context system
