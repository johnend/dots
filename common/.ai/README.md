# Shared AI configuration

Source of truth for configuration shared by Claude Code and Codex. Stowed to
`~/.ai` (whole-directory symlink).

## Layout

- `AGENTS.md` - global instructions for both tools. Edit this, never the links.
  - Codex: `~/.codex/AGENTS.md` -> `../.ai/AGENTS.md`
  - Claude: `~/.claude/CLAUDE.md` imports it with `@~/.ai/AGENTS.md`, then adds
    Claude-only notes (sandbox, hooks)
- `skills/` - shared skills. `agents/openai.yaml` inside a skill is Codex metadata.
  - Claude: `~/.claude/skills` -> `.ai/skills`
  - Codex: `common/.agents/skills/<name>` relative links, stowed into
    `~/.agents/skills/` (the only user-level path Codex scans; `~/.codex/skills`
    is legacy). `twg*` dirs there are real copies managed by the twg installer,
    so they are not in the repo
- `hooks/` - guard and nudge scripts. Both tools send `tool_input.command` (Bash)
  and `prompt` (UserPromptSubmit), and both block on exit 2 with a stderr reason
  - Claude: wired in `.claude/settings.json`; `.claude/hooks` -> `.ai/hooks`
  - Codex: wired in `.codex/hooks.json`. The Write|Edit shell checks are
    Claude-only, because Codex edits via `apply_patch`
- `rules/` - context-discipline `.md` rules. Claude auto-loads them via
  `~/.claude/rules`. Codex only reads `*.rules` execpolicy files
  (`default.rules`), so AGENTS.md points Codex at the `.md` files instead
- `_template.SKILL.md` - starter template for a new skill

## Adding a skill

1. Create `skills/<name>/SKILL.md` (and `agents/openai.yaml` for Codex)
2. `ln -s ../../.ai/skills/<name> common/.agents/skills/<name>` (from the repo root), then `stow -t ~ common`

## Learning loop

The `retro` skill and the `nudge-learning-capture.sh` UserPromptSubmit hook keep
`## Applied Learning` in `AGENTS.md` current. Skill and hook changes are proposed,
not written directly.
