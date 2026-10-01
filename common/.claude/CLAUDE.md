<!--
Shared instructions live in ~/.ai/AGENTS.md (also read by Codex). Edit that file.
Only Claude Code specifics belong below the import.
-->

@~/.ai/AGENTS.md

# Claude Code Specifics

## Sandbox Permissions

- When a Bash command is blocked by the sandbox, surface it immediately; never silently skip or work around it
- Propose the specific allow pattern and ask; apply it with the `manage-sandbox-allowlist` skill, then retry
- The sandbox blocks `gh` config, `~/.npmrc` and some pre-commit hooks; retry those single commands with the sandbox disabled rather than working around it
- Never use `2>/dev/null` on build tools or remote-contact commands (`gh`, `git push/fetch/pull/ls-remote/commit`)

## Hooks (enforced, `~/.ai/hooks/`)

Commit attribution trailers, dependency changes and stderr suppression are blocked; shell-script safety is checked after edits; correction phrasing in my prompts triggers a reminder to record the lesson.
