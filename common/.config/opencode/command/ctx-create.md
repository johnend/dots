---
description: Create comprehensive project context in OpenCode config
agent: artificer
---

# Create Project Context (Meta Command)

Create a comprehensive context file for the current project in `~/.config/opencode/context/{type}/projects/{project-name}/`.

## Important: This is a Meta Command

This command creates context **in the OpenCode config directory**, NOT in the project directory. The context will be stored in:
- `~/.config/opencode/context/work/projects/{project-name}/` (work projects)
- `~/.config/opencode/context/personal/projects/{project-name}/` (personal projects)

## Step 1: Determine Project Type

**CRITICAL: Ask the user to choose project type:**

```
I'll create a context file for this project.

Is this a work project or a personal project?
1. Work (stored in context/work/ - gitignored)
2. Personal (stored in context/personal/ - tracked in git)

Please choose 1 or 2:
```

**Do NOT auto-detect** - Always ask the user. While you could detect "fanduel" in the path, the user prefers explicit control.

## Step 2: Detect Project Information

- **Project Path:** Current working directory
- **Project Name:** Derive from directory name (e.g., `/Users/john/Developer/fanduel/sportsbook` → `sportsbook`)
- **Project Type:** Based on user's choice in Step 1

## Step 3: Analyze Project

1. **Read Configuration Files:**
   - `package.json` / `build.gradle` / `pom.xml` / `requirements.txt` / `Cargo.toml`
   - `README.md`
   - `AGENTS.md` (if exists)
   - `.ai/` directory (if exists)

2. **Identify Tech Stack:**
   - Framework and versions
   - Language and versions
   - Build tools
   - Key dependencies

3. **Discover Scripts:**
   - npm/yarn scripts
   - gradle tasks
   - make targets
   - Custom scripts

4. **Map Structure:**
   - Root directory layout
   - Key directories (src, lib, apps, etc.)

5. **Find CI/CD:**
   - `.github/workflows/`
   - `.buildkite/`
   - `.gitlab-ci.yml`
   - Jenkins files

6. **Identify Patterns:**
   - Testing patterns
   - Code organization
   - Naming conventions

## Step 4: Create Context Files

Create TWO files in the appropriate directory:

### File 1: `context.md`

Full project documentation:

```markdown
# {Project Name} Context

**Project Path:** `{full-path}`

## Overview
{What is this project? What does it do?}

## Tech Stack

### Core
- **Framework:** {name} {version}
- **Language:** {language} {version}
- **Build Tool:** {tool} {version}
- **Node/JVM/Python:** {runtime} {version}
- **Package Manager:** {manager}

### Key Dependencies
- **{category}:** {package} {version}
  {List major dependencies organized by category}

### Dev Tools
- **Linting:** {tool}
- **Testing:** {framework}
- **Formatting:** {tool}

## Project Structure

```
project/
├── src/          # Source code
├── tests/        # Test files
└── ...           # Other directories
```

## Scripts

### Development
```bash
{command}    # Description
```

### Testing
```bash
{command}    # Description
```

### Build & Deploy
```bash
{command}    # Description
```

## Development Setup

### Prerequisites
- {requirement}

### Setup Steps
1. {step}
2. {step}

## Testing Strategy
- {approach}

## CI/CD
- **Pipeline:** {link if available}
- **Environments:** {list}

## Team & Support
- **Team:** {team name}
- **Slack:** {channels}
- **Docs:** {wiki/runbook links}

## Key Patterns
- {pattern or convention}

## Important Notes
- {gotchas, workarounds, special requirements}
```

### File 2: `project-metadata.json`

Path matching configuration:

```json
{
  "projectPath": "{absolute-path}",
  "projectName": "{name}",
  "lastUpdated": "{YYYY-MM-DD}",
  "contextVersion": "1.0.0",
  "projectType": "{work|personal}",
  "primaryLanguage": "{typescript|java|python|etc}",
  "framework": "{react|spring-boot|django|etc}",
  "matchPatterns": [
    "**/{project-name}/**"
  ],
  "keywords": ["{relevant}", "{keywords}"],
  "alwaysLoad": false,
  "relatedContexts": []
}
```

## Step 5: Confirm Creation

After creating the files, provide:

```
✅ Context created for {project-name}

Location: ~/.config/opencode/context/{type}/projects/{project-name}/

Files created:
- context.md ({lines} lines)
- project-metadata.json

Project Type: {work|personal}
- Work contexts are gitignored (private)
- Personal contexts are tracked in dotfiles (public)

Summary:
- Tech Stack: {framework} + {language}
- {X} scripts documented
- {X} dependencies listed
- {X} key patterns identified

To verify context is accurate: /ctx-verify
To update context later: /ctx-update
```

## Notes

- **Work projects** are stored in `context/work/` and are **gitignored**
- **Personal projects** are stored in `context/personal/` and are **tracked in git**
- Context files follow the same format regardless of type
- GloomStalker will automatically load this context when working in the project
