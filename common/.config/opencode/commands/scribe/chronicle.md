---
description: Create rich documentation in Obsidian vault with smart location routing
agent: scribe
---

# Chronicle - Document to Obsidian Vault

Create comprehensive documentation in your Obsidian vault (`~/Developer/personal/Obsidian/`) with automatic location routing and rich formatting.

## How It Works

1. **Detects working directory** → Determines if work or personal project
2. **Infers Obsidian location** → Uses fuzzy matching to find appropriate folder
3. **Asks for confirmation** → First time in each project (then caches)
4. **Detects content type** → Code, workflow, learning, tool, or concept
5. **Creates template** → With appropriate structure and formatting
6. **You fill in details** → Using session context and natural writing

## Location Routing

### Work Projects (`~/Developer/fanduel/*`)
- **Code/workflow docs** → `Work/Domains/{Project}/` (e.g., Refer-a-Friend)
- **General patterns** → `Work/Knowledge/` (reusable across projects)

### Personal Projects (everywhere else)
- **Learning notes** → `Personal/Learning/Notes/`
- **Tool guides** → `Personal/Knowledge/Tools/`
- **Project-specific** → `Personal/Projects/{Project}/`

## Content Types (Auto-detected)

The system detects content type from keywords in the request:

- **code** - Functions, classes, APIs, components
- **workflow** - Processes, deployments (includes Mermaid diagrams)
- **learning** - Concepts, technologies learned
- **tool** - Setup guides, configurations
- **concept** - General patterns, design principles

## Workflow

### Step 1: Call Chronicle Hook

```bash
node ~/.config/opencode/hooks/scribe-chronicle.js "<user request>" "<working-dir>"
```

The hook returns JSON with one of three states:

**A) Success** - File created, ready to fill in:
```json
{
  "success": true,
  "filePath": "/Users/john.enderby/Developer/personal/Obsidian/...",
  "contentType": "workflow",
  "projectName": "raf-app"
}
```

**B) Needs Confirmation** - Location found but not cached:
```json
{
  "success": false,
  "needsConfirmation": true,
  "location": {
    "obsidianPath": "Work/Domains/Refer-a-Friend",
    "confidence": 0.85
  }
}
```

**C) File Exists** - File already present at target location:
```json
{
  "success": false,
  "fileExists": true,
  "filePath": "/path/to/existing/file.md"
}
```

### Step 2: Handle Response

**If Success:**
- Read the created template file
- Fill in content using session context
- Use your natural writing style (you're Scribe!)
- Include code examples, Mermaid diagrams as appropriate
- Save the completed documentation

**If Needs Confirmation:**
```
I found a potential match for this documentation.

Project: {projectName}
Suggested location: {obsidianPath}
Confidence: {confidence}%

Is this the correct location? (yes/no)
```

Wait for user response. If yes:
```bash
node ~/.config/opencode/hooks/obsidian-mapper.js cache {work|personal} {projectName} "{obsidianPath}"
```

Then call chronicle hook again.

**If File Exists:**
```
⚠️  A file already exists at this location:
{filePath}

What would you like to do?
1. Overwrite the existing file
2. Append to the existing file  
3. Create a new file with a different name

Please choose 1, 2, or 3:
```

Handle based on user's choice.

### Step 3: Fill In Documentation

Once the template is created, you fill in the content with:

**For Code Documentation:**
- Clear overview of what the code does
- Implementation details with code examples
- Usage patterns
- Edge cases and notes
- Related documentation links

**For Workflow Documentation:**
- Step-by-step process explanation
- **Mermaid diagram** showing the flow visually
- Concrete examples with commands
- Troubleshooting section
- Related workflows

**For Learning Notes:**
- What you learned and why it matters
- Key concepts explained clearly
- Practical examples
- Resources for further learning
- Next steps

**For Tool Guides:**
- Purpose and use cases
- Installation/setup steps
- Configuration examples
- Common tasks
- Troubleshooting

**For Concepts/Patterns:**
- Problem it solves
- How it works
- When to use (and when NOT to)
- Trade-offs and considerations
- Examples and related concepts

## Writing Style

Use your natural, human writing voice:

✅ **Good:**
```markdown
# Authentication Flow

We moved from localStorage to httpOnly cookies because of XSS vulnerabilities. 
Not the most exciting refactor, but necessary for security.

## How It Works

When a user logs in, the backend sets two cookies: an access token (15 min) 
and a refresh token (7 days). The frontend makes requests with cookies 
automatically. When the access token expires, the refresh token gets a new one.

Simple but effective.
```

❌ **Bad (AI-sounding):**
```markdown
# Authentication Flow System

This document describes the authentication flow implementation which utilizes 
httpOnly cookies to enhance security posture. Furthermore, the system 
implements a comprehensive token refresh mechanism...
```

## Manual Location Override

If user specifies a location:
```
User: /chronicle Document this in Work/Research/ instead
```

Override the auto-detected location and use their specified path.

## Caching System

The obsidian-mapper caches confirmed mappings in:
`~/.config/opencode/obsidian-mappings.json`

Format:
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

Subsequent calls to the same project use cached locations instantly.

## Available CLI Commands

```bash
# Infer Obsidian location for a project
node ~/.config/opencode/hooks/obsidian-mapper.js infer <working-dir>

# Cache a confirmed mapping
node ~/.config/opencode/hooks/obsidian-mapper.js cache <work|personal> <project> "<path>"

# List all cached mappings
node ~/.config/opencode/hooks/obsidian-mapper.js list

# Remove a cached mapping
node ~/.config/opencode/hooks/obsidian-mapper.js remove <work|personal> <project>

# Create documentation (main command)
node ~/.config/opencode/hooks/scribe-chronicle.js "<request>" <working-dir>
```

## Examples

### Example 1: Document Code
```
User: /chronicle Document the password reset API

You:
[Call chronicle hook → Creates Work/Domains/Refer-a-Friend/Password-Reset-API.md]
[Read the template]
[Analyze the code]
[Fill in with clear explanations, code examples, usage patterns]
[Natural writing style throughout]
```

### Example 2: Document Workflow
```
User: /chronicle How we deploy to production

You:
[Call chronicle hook → Creates Work/Domains/Refer-a-Friend/Production-Deployment.md]
[Ask follow-ups if needed about deployment process]
[Fill in with step-by-step guide]
[Include Mermaid diagram showing deployment flow]
[Add troubleshooting section]
```

### Example 3: Learning Note
```
User: /chronicle What I learned about React Server Components

You:
[Call chronicle hook → Creates Personal/Learning/Notes/React-Server-Components.md]
[Extract learnings from session context]
[Explain key concepts clearly]
[Add practical examples]
[Include resources for further learning]
```

## Integration with Context System

Chronicle works alongside `/ctx-create`:
- **Context system** tells agents about project structure and patterns
- **Chronicle** documents what you learn and build
- Both maintain **single source of truth** in their respective locations
- Context in OpenCode config, chronicles in Obsidian vault

## Tips

1. **Use session context** - Review conversation history for details
2. **Ask follow-ups** - Better to clarify than guess
3. **Include examples** - Code snippets, commands, before/after
4. **Visual for workflows** - Always use Mermaid diagrams for processes
5. **Natural voice** - Write like a human documenting their own work
6. **Be honest** - "Simple but works" > pretending it's perfect

## Remember

You're creating documentation in the user's **personal Obsidian vault** - a single source of truth for knowledge. Make it clear, useful, and genuinely helpful. Write like you're explaining to a colleague, not generating corporate documentation.

The goal: someone reading this in 6 months (including the user) should immediately understand what was built and why.
