# Git Status Checker

**Purpose:** Detects what the user has done since last interaction, providing context to AI agents.

## Overview

This CLI analyzes git repository state and provides:
- **Staged changes** - User is preparing to commit (valuable context)
- **Unstaged changes** - User is actively working on (valuable context)
- File diffs for both staged and unstaged modifications
- Previews of new files
- Recent commits (for context on what user just accomplished)
- Branch tracking information

## Philosophy

**Current work matters most:**
- Staged + unstaged changes show what user is actively working on
- Diffs reveal intent and approach
- This is where agents can provide most value

**Committed work is context:**
- Recent commits show what user accomplished
- Provides background for current changes
- Less valuable since user was satisfied enough to commit

## Token Management

The hook is intelligent about token usage:

- **Small changes (<5 files):** Full diffs included
- **Medium changes (5-15 files):** Summaries with stat lines
- **Large changes (>15 files):** Grouped summaries only
- **New files:** First 20 lines preview
- **Large diffs:** Truncated at 5000 characters

## Usage

### Basic (Human-readable format)
```bash
node cli.js [workdir]
```

### JSON format
```bash
node cli.js --json [workdir]
```

### Examples

```bash
# Check current directory
node cli.js

# Check specific directory
node cli.js ~/Developer/my-project

# Get JSON output for programmatic use
node cli.js --json
```

## Output Format

### Human-Readable (Agent Format)

```
📊 Git Status Summary
══════════════════════════════════════════════════

Branch: feature/password-reset
Tracking: origin/feature/password-reset (2 ahead)

Total files changed: 3
  Modified: 2 file(s)
  Added: 1 file(s)

Staged: 1 file(s)
Unstaged: 2 file(s)

Recent Commits:
──────────────────────────────────────────────────
abc123 - feat: add password reset API
  Author: John Enderby
  Files: src/api/password-reset.ts, src/api/index.ts

Changed Files:
──────────────────────────────────────────────────

📝 Modified:
  🟢 src/api/auth.ts (staged)
     +15 -3 lines
  🔴 src/components/LoginForm.tsx (unstaged)
     +8 -2 lines

➕ Added:
  🔴 src/api/password-reset.ts (unstaged)
     87 lines

══════════════════════════════════════════════════
Diffs:
══════════════════════════════════════════════════

File: src/api/auth.ts (staged)
──────────────────────────────────────────────────
[unified diff format...]
```

### JSON Format

```json
{
  "hasChanges": true,
  "isRepo": true,
  "summary": {
    "modified": ["src/api/auth.ts", "src/components/LoginForm.tsx"],
    "added": ["src/api/password-reset.ts"],
    "deleted": [],
    "renamed": [],
    "staged": ["src/api/auth.ts"],
    "unstaged": ["src/components/LoginForm.tsx", "src/api/password-reset.ts"]
  },
  "diffs": {
    "modified": [
      {
        "file": "src/api/auth.ts",
        "staged": true,
        "summary": "+15 -3 lines",
        "patch": "..."
      }
    ],
    "added": [
      {
        "file": "src/api/password-reset.ts",
        "staged": false,
        "summary": "87 lines (new file)",
        "lines": 87,
        "preview": "..."
      }
    ]
  },
  "recentCommits": [
    {
      "hash": "abc123",
      "message": "feat: add password reset API",
      "author": "John Enderby",
      "timestamp": "2026-02-02T22:00:00Z",
      "filesChanged": ["src/api/password-reset.ts", "src/api/index.ts"]
    }
  ],
  "branch": "feature/password-reset",
  "tracking": {
    "remote": "origin/feature/password-reset",
    "ahead": 2,
    "behind": 0
  }
}
```

## Integration with Agents

### Artificer Integration

Called at:
1. Session start (before GloomStalker)
2. After user says "continue", "done", "I'm back"

Example:
```typescript
// In Artificer workflow
const gitStatus = execSync('node ~/.config/opencode/hooks/git-status-checker/cli.js').toString();

if (gitStatus.includes('hasChanges: true')) {
  // Report to user what they've done
  // Adjust implementation strategy
}
```

### Mentor Integration

Called at:
1. Session start
2. After each user response

Enables Mentor to:
- See what user tried ("I see you attempted to add middleware...")
- Tailor guidance to their approach
- Recognize progress ("Great, you added the function!")

## Configuration

Token limits can be adjusted in `detector.ts`:

```typescript
const MAX_DIFF_SIZE = 5000; // characters
const MAX_FILES_FOR_FULL_DIFF = 5;
const PREVIEW_LINES = 20;
```

## Development

```bash
# Install dependencies
npm install

# Build
npm run build

# Test manually
node cli.js
node cli.js --json
```

## Notes

- Reports **both staged and unstaged changes** (current work in progress)
- Diffs provided for both staged and unstaged modifications
- Recent commits provide context on what user just accomplished
- Diffs use unified format for easy parsing
- Handles large repositories gracefully

