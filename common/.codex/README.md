# Codex CLI user configuration

This directory stores Codex-specific user config that you stow into your home
directory.

Reference: https://developers.openai.com/codex/skills

## Current layout

- `config.toml` - managed Codex configuration
- `low.config.toml`, `med.config.toml`, `high.config.toml` - context limit profiles
- `skills/` - symlink to the shared global skills tree at `~/.ai/skills`
- `prompts/` - optional local prompt templates kept alongside Codex config

## Notes

- Codex reads runtime state from `~/.codex`, so this directory is kept in
  dotfiles and stowed directly into that location.
- Shared skills live in `~/.ai/skills`. `~/.codex/skills` should point to that
  directory.
- Skills are the reusable workflow mechanism. `prompts/` is separate and not
  required for shared skill discovery.

## Context profiles

The base config defaults to high. Each profile inherits the base settings and
overrides the context limit and automatic compaction threshold.

| Profile | Context tokens | Auto compact tokens (75%) |
| --- | ---: | ---: |
| `low` | 272,000 | 204,000 |
| `med` | 572,000 | 429,000 |
| `high` (default) | 872,000 | 654,000 |

Start a new session with `codex` for high, or select a profile explicitly:

```sh
codex --profile low
codex --profile med
codex --profile high
```

Profile files are loaded from `~/.codex/<name>.config.toml`. Stow `common` on
each machine to expose these files. Limits use the current `gpt-6.1-sol`
catalog's default (272,000) and advertised maximum (872,000); configuration
does not increase backend model capacity.

Reference: https://learn.chatgpt.com/docs/config-file/config-advanced#profiles
