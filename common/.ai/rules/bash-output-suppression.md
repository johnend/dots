---
description: Bash output suppression - silence verbose stdout/stderr in hooks, agents, and scripts; show output only on failure to save context tokens
alwaysApply: true
---

## Bash Output Suppression

### Silent on Success, Verbose on Failure

Capture stdout+stderr in one run, check status, print only the tail on failure. This never runs the command twice and keeps success noise out of context:

```bash
output=$(cmd 2>&1); status=$?
[ "$status" -ne 0 ] && printf '%s\n' "$output" | tail -20
```

- Use `printf '%s\n'`, not `echo` (POSIX-reliable on bash 3, no escape interpretation).
- Apply to anything multi-line: builds, type checks, lint, tests, installs (`npm install`, `yarn`, `pip install` are routinely thousands of lines).
- Always cap the tail; raise it when useful (e.g. `tail -50` for test suites) but never leave it uncapped.
- **In functions**, `local` always exits 0 and masks the status, so declare then assign:

  ```bash
  local output
  output=$(cmd 2>&1); status=$?
  [ "$status" -ne 0 ] && { printf '%s\n' "$output" | tail -20 >&2; return "$status"; }
  ```

### Probes: Discard Everything

Existence and boolean checks need no output even on failure, so skip variable-capture (it only adds a subshell):

```bash
git rev-parse --verify HEAD >/dev/null 2>&1
command -v jq >/dev/null 2>&1 && echo found || echo missing
```

### Hooks: statusMessage, Not stdout

Claude Code injects any synchronous-hook stdout as `additionalContext`, so a hook that prints on every tool call steadily grows context. Succeed with exit 0 and no stdout; show progress via the `statusMessage` field on the `settings.json` hook entry (UI-only, never enters context):

```json
{ "type": "command", "command": "bash hooks/my-hook.sh", "timeout": 30, "statusMessage": "Running pre-push checks..." }
```

Hook script conventions:

- Use `set -uo pipefail` (omit `-e`; hooks need intentional `|| true` fallback branches).
- Variable-capture every internal side-effect command; route errors to `>&2` (stdout is additionalContext, stderr is not).
- Group the failure branch so exit always runs, avoiding a `&&` short-circuit gap: `[ "$status" -ne 0 ] && { printf '%s\n' "$output" | tail -20 >&2; exit "$status"; }`

### Never Suppress: gh / git remote

`gh` and `git push/fetch/pull/ls-remote/commit` have load-bearing stderr (SSH auth, SAML enforcement, and hook subprocess failures appear only there). Run them directly:

```bash
gh pr create --title "$TITLE" --body "$BODY"   # correct
output=$(gh pr create ... 2>&1)                # wrong, hides auth errors
```

### Skills & Agents

- Prefer a native tool (Grep, Read, Glob, WebFetch) over Bash; suppression is the fallback when Bash is genuinely needed.
- When a skill body runs bash, apply the same capture pattern to its verification and build steps.
- Never instruct `echo` progress text; the Bash tool already shows the command and its result.

### Checklist

- ✓ Build/install/test use variable-capture; no ad-hoc `2>/dev/null` on side-effect commands
- ✓ `local` declared separately from assignment in functions
- ✓ gh/git-remote commands left unsuppressed
- ✓ Hooks use `statusMessage`, not stdout; errors to `>&2`
- ✓ Instructional bash in skill/agent markdown follows these patterns
