# Shared AI configuration

This directory is the source of truth for AI tooling configuration that should
be shared across multiple assistants.

## Layout

- `skills/` - shared global skills consumed by Codex and Cursor via symlinked
  tool-specific directories
- `_template.SKILL.md` - starter template for authoring a new shared skill

## Notes

- Codex-specific optional metadata such as `agents/openai.yaml` can live inside
  a shared skill directory.
- Cursor is expected to ignore tool-specific metadata files that it does not
  understand.
- Claude CLI is not wired into this shared tree yet because its documented
  extension point is `.claude/agents/`, not the same skills directory layout.
