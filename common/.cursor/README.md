# Cursor user-level configuration

This directory stores Cursor-specific user config that you stow into your home
directory.

## Current layout

- `rules/` - user rules you keep in version control and paste into Cursor
  Settings when needed
- `commands/` - user slash commands, symlinked into `~/.cursor/commands`
- `agents/` - user subagents, symlinked into `~/.cursor/agents`
- `skills/` - symlink to the shared global skills tree at `~/.ai/skills`

## Notes

- Cursor does not document a disk path for global user rules. Treat `rules/` as
  your source of truth and paste the relevant content into Cursor Settings.
- Shared skills live outside this directory in `~/.ai/skills`. `~/.cursor/skills`
  should point to that directory.
- Shared skills may include Codex-only metadata such as `agents/openai.yaml`.
  Cursor is expected to ignore files it does not use.

## Layout

```text
~/.config/cursor/
├── README.md
├── rules/
├── commands/
├── agents/
└── skills -> ../.ai/skills
```
