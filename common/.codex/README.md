# Codex CLI user configuration (dotfiles source of truth)

This directory stores your Codex behavior config in dotfiles, similar to your
OpenCode/Cursor setup.

Reference: https://developers.openai.com/codex/cli/slash-commands

## What lives here

- `config.toml` - managed baseline config
- `skills/` - reusable Codex skills (workflow + guardrails)
- `prompts/` - native Codex slash commands (`/name`)

## Why this layout

Codex reads runtime state from `~/.codex` (auth, sessions, logs, caches).  
This dotfiles package is intentionally rooted at `common/.codex` so stow places
managed config directly where Codex reads it.

## Install / sync

Use stow to manage this directory into your home dotfiles setup.

After stow/sync, each prompt file becomes a slash command in Codex CLI:

- `prompts/code-review.md` -> `/code-review`
- `prompts/test-fix.md` -> `/test-fix`
- `prompts/implement-brief.md` -> `/implement-brief`

## Command wrappers

`common/bin` includes wrappers that map your Cursor/OpenCode-style workflows:

- `codex-review`
- `codex-debug-with-me`
- `codex-test-fix`
- `codex-add-tests`
- `codex-implement-brief`
- `codex-chronicle`

These wrappers use prompt templates from `~/.codex/prompts/`.
They are optional; native slash commands work directly in Codex after sync.
No shell aliases are configured for these wrappers right now.
