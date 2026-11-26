# Upstream

Vendored unchanged from https://github.com/addyosmani/clarity (MIT, see `LICENSE`).

- Commit: `e27ceeff60368cf6966b4ea00a5b9b36418ee9a0` (2026-09-04), skill version 0.2.1
- Copied: `SKILL.md`, `LICENSE`, `references/*.md`, `scripts/prose_stats.py`, `scripts/strip_markdown.py`
- Added locally: `agents/openai.yaml` (Codex metadata) and this file
- Left out: the website, evals, samples, CI, Claude command wrappers and `scripts/validate_package.py`, because the skill doesn't use them at runtime

To update, clone the repo, diff the copied files against this folder, read the changes, then copy them over and update the commit above. Keep local edits out of these files so updates stay a straight copy; put local writing rules in the "Writing for People" section of `common/.ai/AGENTS.md` instead.
