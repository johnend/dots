# Codex CLI user configuration

This directory stores Codex-specific user config that you stow into your home
directory.

Reference: https://developers.openai.com/codex/skills

## Current layout

- `config.toml` - managed Codex configuration
- `skills/` - symlink to the shared global skills tree at `~/.ai/skills`
- `prompts/` - optional local prompt templates kept alongside Codex config

## Notes

- Codex reads runtime state from `~/.codex`, so this directory is kept in
  dotfiles and stowed directly into that location.
- Shared skills live in `~/.ai/skills`. `~/.codex/skills` should point to that
  directory.
- Skills are the reusable workflow mechanism. `prompts/` is separate and not
  required for shared skill discovery.
