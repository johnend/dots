# Risk Assessor

Automatic risk assessment for destructive operations in OpenCode.

## Purpose

Evaluates safety of operations before execution to prevent:
- **Irreversible data loss** - Blocked at critical risk level
- **Production incidents** - Extra scrutiny for prod environments
- **Accidental deletions** - Warn before removing critical files
- **Git history corruption** - Prevent dangerous force pushes/resets

## Architecture

```
risk-assessor/
├── cli.js          # CLI wrapper for command-line execution
├── detector.ts     # Destructive operation detection patterns
├── assessor.ts     # Risk scoring and categorization
├── package.json    # NPM configuration
├── tsconfig.json   # TypeScript configuration
└── dist/          # Compiled JavaScript (gitignored)
```

## Usage

### From Command Line

```bash
# Assess risk of operation
node cli.js "git push --force origin main"

# Output: JSON with risk assessment
{
  "riskLevel": "critical",
  "shouldBlock": true,
  "score": 12,
  "recommendations": ["🛑 STOP: This operation is extremely dangerous", ...],
  "operations": [{type: "git-force", severity: "critical"}],
  "criticalTargets": ["main"]
}
```

### From Artificer Agent

Artificer automatically calls risk-assessor before destructive operations:

```
1. User requests destructive operation
2. Artificer runs: node ~/.config/opencode/hooks/risk-assessor/cli.js "operation"
3. If riskLevel=critical → BLOCK and explain
4. If riskLevel=high → ASK user for confirmation
5. If riskLevel=medium → WARN and proceed
6. If riskLevel=low/none → Proceed normally
```

## Risk Levels

| Level | Score | Action | Description |
|-------|-------|--------|-------------|
| **Critical** | 10+ | ❌ Block | Extremely dangerous, cannot proceed |
| **High** | 7-9 | ⏸️ Ask | High risk, requires user confirmation |
| **Medium** | 4-6 | ⚠️ Warn | Moderate risk, show recommendations |
| **Low** | 1-3 | ℹ️ Info | Minor risk, proceed with note |
| **None** | 0 | ✅ Safe | No risk detected |

## Detection Patterns

### Git Operations

| Pattern | Type | Severity | Score |
|---------|------|----------|-------|
| `git push --force` | git-force | critical | 10 |
| `git push -f` | git-force | critical | 10 |
| `git reset --hard` | git-rewrite | critical | 10 |
| `git branch -D` | git-delete | high | 8 |
| `git rebase` | git-rewrite | medium | 5 |
| `git commit --amend` | git-rewrite | medium | 4 |

### File Operations

| Pattern | Type | Severity | Score |
|---------|------|----------|-------|
| `rm -rf` | file-delete | critical | 10 |
| `del /s` (Windows) | file-delete | high | 8 |
| `> file` (overwrite) | file-overwrite | medium | 4 |
| `mv` (can overwrite) | file-overwrite | low | 2 |

### Database Operations

| Pattern | Type | Severity | Score |
|---------|------|----------|-------|
| `DROP DATABASE` | database-drop | critical | 10 |
| `TRUNCATE TABLE` | database-truncate | high | 8 |
| `DELETE FROM` (no WHERE) | database-truncate | critical | 10 |
| `DELETE FROM ... WHERE` | database-truncate | medium | 5 |

### System Commands

| Pattern | Type | Severity | Score |
|---------|------|----------|-------|
| `sudo rm` | system-command | critical | 10 |
| `kill -9` | system-command | medium | 5 |
| `chmod 000` | system-command | high | 7 |

### Critical Targets (Bonus Score)

Operations targeting these get +2 score per target:
- System directories: `/usr`, `/etc`, `/var`, `/root`
- Important files: `package.json`, `.env`, `.git`
- Main branches: `main`, `master`
- Production: `production`, `prod`
- Dependencies: `node_modules`

## CLI Options

```bash
# Basic usage
node cli.js "command or operation"

# Production environment (adds +5 to score)
node cli.js "DROP DATABASE myapp" --production

# Has backup (removes "no backup" warning)
node cli.js "git reset --hard" --has-backup

# User confirmed (high risk operations proceed)
node cli.js "git branch -D old-feature" --confirmed

# Debug mode
node cli.js "rm -rf node_modules" --debug

# Show help
node cli.js --help
```

## Exit Codes

- **0** = Safe to proceed (low/none risk)
- **1** = Should warn (medium/high risk with confirmation)
- **2** = Blocked (critical risk)

## Examples

### Critical Risk (BLOCKED)

```bash
$ node cli.js "git push --force origin main"
Exit code: 2

{
  "riskLevel": "critical",
  "shouldBlock": true,
  "recommendations": [
    "🛑 STOP: This operation is extremely dangerous",
    "Create a backup before proceeding",
    "Review git documentation for safer approaches"
  ],
  "criticalTargets": ["main"]
}
```

### High Risk (CONFIRMATION REQUIRED)

```bash
$ node cli.js "git branch -D feature-old"
Exit code: 1

{
  "riskLevel": "high",
  "shouldWarn": true,
  "shouldProceed": false,
  "recommendations": [
    "⚠️ HIGH RISK: Proceed with extreme caution",
    "Ensure you have a backup"
  ]
}
```

### Medium Risk (WARNING)

```bash
$ node cli.js "git commit --amend"
Exit code: 1

{
  "riskLevel": "medium",
  "shouldWarn": true,
  "shouldProceed": true,
  "recommendations": [
    "⚡ MEDIUM RISK: Review carefully before proceeding"
  ]
}
```

### Low Risk (INFO)

```bash
$ node cli.js "npm uninstall lodash"
Exit code: 0

{
  "riskLevel": "low",
  "shouldProceed": true,
  "recommendations": [
    "ℹ️ LOW RISK: Operation appears safe but review first"
  ]
}
```

### No Risk (SAFE)

```bash
$ node cli.js "npm install lodash"
Exit code: 0

{
  "riskLevel": "none",
  "shouldProceed": true,
  "recommendations": []
}
```

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
# Test safe operation
node cli.js "npm install"

# Test low risk
node cli.js "npm uninstall lodash"

# Test medium risk
node cli.js "git commit --amend"

# Test high risk
node cli.js "git branch -D old-feature"

# Test critical risk
node cli.js "git push --force origin main"

# Test with flags
node cli.js "DROP DATABASE prod" --production
node cli.js "git reset --hard" --has-backup --debug
```

## Integration

This CLI is automatically called by the Artificer agent at Step 6 (EXECUTE) before destructive operations:

```
1. RECEIVE TASK
2. RUN TODO-ENFORCER CLI 🚦
3. CALL GLOOMSTALKER CLI 🔦
4. VERIFY PROJECT CONTEXT
5. ANALYZE & CATEGORIZE
6. EXECUTE
   ├─ RUN RISK-ASSESSOR CLI 🛡️  ← HERE
   ├─ If critical → BLOCK
   ├─ If high → ASK
   ├─ If medium → WARN
   └─ If low/none → PROCEED
7. VERIFY EXECUTION
...
```

See `agents/artificer.md` for full workflow.

## Status

✅ **Phase 3 Complete** - Risk assessment active and working

- Detector with 30+ destructive patterns
- Risk scoring with 5 levels
- CLI wrapper functional
- Integrated into Artificer workflow
- Examples and documentation complete

## Related

- **Todo Enforcer** (`hooks/todo-enforcer/`) - Multi-step task detection
- **GloomStalker** (`agents/gloomstalker/`) - Smart context loading
- **Artificer** (`agents/artificer.md`) - Main builder agent
