# Shared AI configuration

Source of truth for configuration shared by Claude Code and Codex. Stowed to
`~/.ai` (whole-directory symlink).

## Layout

- `AGENTS.md` - global instructions for both tools. Edit this, never the links.
  - Codex: `~/.codex/AGENTS.md` -> `../.ai/AGENTS.md`
  - Claude: `~/.claude/CLAUDE.md` imports it with `@~/.ai/AGENTS.md`, then adds
    Claude-only notes (sandbox, hooks)
- `context/` - shared guidance read only for matching tasks, using the index in
  `AGENTS.md`. These are ordinary Markdown files, outside Claude's auto-loaded
  rules directory; do not import the whole directory into either tool.
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

The `retro` skill and the `nudge-learning-capture.sh` UserPromptSubmit hook direct
reusable lessons to the relevant `context/` module or project guidance. The global
`AGENTS.md` holds preferences, permission boundaries and the conditional reading
index, rather than a growing list of technical lessons.

Both tools run retro automatically before finishing substantive work, after
generalisable corrections and before session wrap-up. This is part of the agent's
completion instructions, not a background process that runs after a session is
closed. Reviews with nothing useful to record stay silent.

Applied learning is portable Markdown: Claude and Codex read and update the same
`context/` files and the same shared retro skill. Project-specific guidance stays
with the project. Across machines, use the usual approved dotfiles/project Git
workflow to carry those changes with you.

Read the destination before updating it and preserve the conditions that make the
lesson useful. Either tool may create focused modules and sensible topic/stack
directories when an existing module does not fit. Add the new module's task
condition and link to the relevant reading index in the same change. Avoid folders
for individual incidents, empty scaffolding and eagerly importing the modules.

Routine guidance and index maintenance needs no separate approval. Permission,
global preference, executable hook and procedural skill changes retain their
normal approval rules unless already authorised for the current task. Commits
and pushes still require explicit approval.
