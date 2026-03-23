---
name: manage-sandbox-allowlist
description: "Add or remove CLI tool patterns from Claude Code's sandbox permissions allowlist and denylist. Triggered proactively by user request or reactively when a Bash command is blocked."
---

# Manage Sandbox Allowlist

Use this skill to add or remove patterns from the Claude Code sandbox permissions in `settings.json`.

## Triggers

- **Proactive**: user asks to add/allow/block a command or tool
- **Reactive**: a Bash command is denied by sandbox permissions — immediately offer to add it to the allowlist, show the pattern that would be added, and wait for confirmation before proceeding

## File Location

Always edit `~/.claude/settings.json`. On this setup it is a symlink into the dotfiles repo, so edits are automatically versioned. To find the real path if needed: `readlink -f ~/.claude/settings.json`.

## Schema

```json
{
  "permissions": {
    "allow": ["Bash(<pattern>)", "Read(<path>)", "Edit(<path>)"],
    "deny":  ["Bash(<pattern>)"]
  }
}
```

**Pattern format:**
- `Bash(git log*)` — matches `git log` and any arguments
- `Bash(npm run *)` — matches `npm run <anything>`
- `Bash(* --version)` — matches any command with `--version`
- `Read(~/.config/**)` — matches all files under `~/.config/`
- `Edit(~/Developer/personal/**)` — matches any edit under that path

## Workflow

### 1. Identify the pattern

For a blocked or requested command, derive the minimal safe pattern:
- Prefer specific patterns (`Bash(npm run *)`) over broad ones (`Bash(npm *)`)
- Use `*` at the end for commands that take arguments
- For tools with subcommands, scope to the subcommand where appropriate

### 2. Safety checks

Before writing any change:
- Check `allow` array: is this pattern already present (exact or covered by a broader entry)?
- Check `deny` array: would this conflict with an existing deny rule?
- If a conflict exists, surface it to the user and ask how to proceed

### 3. Show the change

Display the exact line that will be added or removed. Get explicit confirmation before writing.

### 4. Apply the change

- Read the current `settings.json`
- Insert into (or remove from) the correct array, preserving the existing grouping and ordering
- Keep related tools grouped (git commands together, docker together, etc.)
- Validate that the resulting JSON is well-formed

### 5. Verify

Show `git diff` on `settings.json` after writing so the user can review the final state.

## Reactive Blocking Behaviour

When a Bash command is blocked mid-task:

1. State what was blocked: `"Command blocked: <command>"`
2. Propose the pattern: `"To allow this, I'd add: Bash(<pattern>) to the allowlist"`
3. Ask: `"Add it now and continue?"`
4. If yes — apply the change, then re-attempt the original command
5. If no — find an alternative approach or stop and explain the constraint

Do not silently skip blocked commands or work around them without surfacing the block.
