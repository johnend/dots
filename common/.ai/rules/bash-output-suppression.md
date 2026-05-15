---
description: Bash output suppression conventions — silence verbose stdout/stderr in hooks, agents, and scripts to reduce token consumption; show output only on failure
alwaysApply: true
---

## Bash Output Suppression

### Core Pattern: Silent on Success, Verbose on Failure

- Use variable-capture for any command that may produce verbose output — capture stdout+stderr in one run, check exit status, print only the tail on failure; this avoids running the command twice and keeps the context window free of noise on success:

  ```bash
  output=$(cmd 2>&1)
  status=$?
  [ "$status" -ne 0 ] && printf '%s\n' "$output" | tail -20
  ```

  Use `printf '%s\n'` rather than `echo` — `printf` is POSIX-reliable across bash 3 and does not interpret escape sequences

- Apply this pattern to all commands that may produce multi-line output: build steps, type checks, lint runs, test suites, and install commands (`npm install`, `yarn`, `pnpm install`, `pip install`) — install output is routinely thousands of lines; success is silent, failure surfaces the last 20 lines for diagnosis

- Adjust the `tail -20` cap when more diagnostic context is genuinely useful (e.g., `tail -50` for test suite failures) — but always cap; never let failure output grow unbounded into the context window

- **Inside bash functions**: `local` always exits 0, masking the real exit code — declare and assign separately:

  ```bash
  local output
  output=$(cmd 2>&1)
  status=$?
  [ "$status" -ne 0 ] && { printf '%s\n' "$output" | tail -20 >&2; return "$status"; }
  ```

### Probe Commands: Discard All Output

- For existence checks and boolean probes where no output is needed even on failure, discard everything — do not use variable-capture (adds a subshell with no benefit):

  ```bash
  git rev-parse --verify HEAD >/dev/null 2>&1
  command -v jq >/dev/null 2>&1 && echo "jq found" || echo "jq missing"
  ```

### Hook Output: statusMessage Not stdout

- Hook scripts that succeed should exit 0 with no stdout — Claude Code treats any stdout from a synchronous hook as `additionalContext` injected into the session; a hook printing success messages on every tool call steadily grows context

- Use the `statusMessage` field in `settings.json` hook entries to show the user visible progress during suppressed runs — the status message appears in the Claude Code UI while the hook runs and disappears on completion; it does not enter the context window:

  ```json
  {
    "type": "command",
    "command": "bash hooks/my-hook.sh",
    "timeout": 30,
    "statusMessage": "Running pre-push checks..."
  }
  ```

### Exceptions — Never Suppress These Commands

- Do **not** apply output suppression to `gh` CLI, `git push`, `git fetch`, `git pull`, `git ls-remote`, or `git commit` — their stderr is load-bearing: SSH auth failures, SAML enforcement errors, and hook subprocess failures only appear on stderr; suppressing it makes these failures undiagnosable — treat any git or gh operation that contacts a remote as an exception

- Run these commands directly — let their output flow through:

  ```bash
  # Correct — output flows through for auth error visibility
  gh pr create --title "$TITLE" --body "$BODY"

  # Incorrect — suppresses auth errors, creates silent failures
  output=$(gh pr create --title "$TITLE" --body "$BODY" 2>&1)
  ```

### Applying in Hook Scripts

- Apply variable-capture to every internal side-effect command in hook scripts; let the hook's own exit path remain unsuppressed
- Omit `-e` from `set` when the hook needs intentional fallback branches (`|| true`, conditional error handling) — this differs from the `set -euo pipefail` standard for regular scripts; the omission is deliberate:

  ```bash
  #!/usr/bin/env bash
  set -uo pipefail

  INPUT=$(cat)

  # Probe — discard all
  command -v node >/dev/null 2>&1 || { echo "node not found" >&2; exit 1; }

  # Side-effect command — variable-capture
  # >&2 is load-bearing in hooks: hook stdout becomes additionalContext; errors belong on stderr
  output=$(node scripts/my-check.mjs 2>&1)
  status=$?
  # Grouped block ensures exit always runs — avoids && short-circuit gap if printf | tail fails
  [ "$status" -ne 0 ] && { printf '%s\n' "$output" | tail -20 >&2; exit "$status"; }

  # Silent success — no stdout
  exit 0
  ```

### Applying in Skills and Agents

- Before reaching for Bash, check whether a native Claude Code tool (Grep, Read, Glob, WebFetch) eliminates the need for bash entirely; output suppression is the fallback for when Bash is genuinely required

- When a skill body instructs Claude to run bash commands, follow the same patterns — wrap verification and build steps with variable-capture and suppress success output:

  ```
  Run type check silently on success:
  output=$(yarn tsc --noEmit 2>&1); status=$?
  [ "$status" -ne 0 ] && printf '%s\n' "$output" | tail -50
  ```

- Do not instruct Claude to `echo` progress text during bash steps — the Bash tool already shows the command and its result in the tool call; extra echo output inflates the context further

### Review Checklist for New Hooks and Scripts

Before committing hooks or scripts, verify:

- ✓ All build/install/test commands use variable-capture pattern
- ✓ No ad-hoc `2>/dev/null` on side-effect commands
- ✓ `local output` declared separately from assignment inside bash functions
- ✓ gh/git remote commands have NO output suppression
- ✓ Hooks use `statusMessage` field, not stdout, for user feedback
- ✓ Instructional bash blocks in skill/agent markdown follow documented patterns
