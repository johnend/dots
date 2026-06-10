<!--
This file mirrors ~/.claude/CLAUDE.md (source: common/.claude/CLAUDE.md).
Keep them in sync. The Sandbox Permissions section from CLAUDE.md is omitted
here — those rules target Claude Code's ~/.claude/settings.json allowlist.
Codex sandbox config lives in ~/.codex/config.toml and uses a different model.
-->

# Global Preferences

Do not make any changes until you have 95% confidence in what you need to build. Ask me follow up questions until you reach that confidence level.

## Git Workflow

- **Manual control only** — never auto-commit, auto-push, auto-merge, or auto-create PRs
- Show `git status` and `git diff --stat` before suggesting any commit
- Before suggesting a commit, invoke the `review-local` skill on the staged diff and surface findings. Skip only if the user explicitly opts out (e.g. "skip the review", "just commit")
- Follow the repo's existing commit style (check `git log` first) — only use conventional commits (`fix:`, `feat:`, etc.) when the repo already does
- Branch naming: follow repo convention; default to `<type>: <scope> - <summary>` for personal repos
- When on a ticket branch (e.g. `ABC-123-some-feature`), prepend the ticket number to the first commit on the branch: `ABC-123 commit message`. Infer the ticket from the branch name.
- Use `--force-with-lease` over `--force`
- Git aliases available: `git fix "msg"`, `git feat "msg"`, `git chore "msg"`, etc.
- Delta configured as git pager (side-by-side, catppuccin-mocha)
- When committing multiple changes, chunk them into logical commits rather than one large commit.
- Commit before replying to PR review comments when both are requested.

## Code Quality

- Readability over cleverness
- Comments explain WHY, not WHAT — skip comments for standard patterns, self-documenting code, and obvious operations
- Comment workarounds, counter-intuitive logic, performance tradeoffs, security decisions, external constraints, TODOs with timeline
- Prefer explicit over implicit; verbose names over abbreviations
- Shell scripts: `set -euo pipefail`, 2-space indent, UPPER_SNAKE_CASE constants, lowercase_snake_case variables/functions

## Communication

- Concise, technical, direct — no filler or exaggerated praise
- Technical depth appreciated
- Check official docs before implementing with unfamiliar libraries — don't iterate blindly on failed approaches
- Check local docs first (plugin `/doc/`, `node_modules/*/README.md`), then online via webfetch

## UI/Frontend

- Always ask before implementing UI: "implement, structure-only, or guidance?"
- Never implement frontend without consent

## PR Reviews

- When asked to review a PR (any phrasing), produce a structured review directly — do NOT enter plan mode or implement changes
- Output format: **Header** (Summary, Overall assessment, Test coverage, Already flagged, severity tally) → **Findings**, severity-grouped (Critical → Warning → Suggestion → Nit → Question), each severity introduced by a box-drawing header, one self-contained block per finding (location + category + code snippet + paste-ready comment), thick `━` rule between findings within a section. Full spec lives in the `/review-pr` skill.
- Use diplomatic, collegial tone for critical feedback
- Never auto-comment or post to GitHub — draft only, for user approval
- For per-reviewer pattern tracking (e.g. `get-pr-comments`), exclude AI authors (Copilot, CodeRabbit, Sonarcloud, Greptile, Ellipsis, anything matching `*[bot]`) — their comments still appear in the action list but don't accumulate against human reviewers

## Destructive Operations

- State risk and ask explicitly before: force push, reset, bulk delete, production changes
- Run scoped validation/tests before declaring done
- Package managers: installing from a lockfile (`yarn`, `npm install`, `pnpm install`, `bun install`) and running scripts (`yarn <script>`, `npm run <script>`, `bun run <script>`, etc.) are fine. Never modify dependencies without explicit confirmation — applies to all package managers (`yarn add/remove/upgrade`, `npm install <pkg>`, `npm uninstall`, `pnpm add/remove`, `bun add/remove`, `pip install`, `poetry add`, `cargo add`, `bundle add`, etc.)

## Planning & Options

- For any non-trivial implementation (new features, refactors, config changes, integrations), always plan before writing code
- Present 2-3 viable approaches with explicit pros and cons for each — never default to one solution without considering alternatives
- Wait for explicit approval of the chosen approach before executing
- For simple, mechanical tasks (typo fix, single import, obvious one-liner), proceed directly without a plan

## Research & Implementation

For non-trivial work (features, subtle bugs, integrations, dependency/config changes), don't start editing immediately:

1. **Discover** — Read the smallest set of relevant docs, configs, and code paths. Prefer existing implementations over inventing a new pattern. Map the affected flow and dependencies before editing.
2. **Verify** — Confirm the likely data flow, ownership, and change surface. Identify blockers and risky assumptions. Ask a focused question when a key requirement cannot be inferred safely.
3. **Execute** — Implement once the path is clear. Prefer extending existing code over introducing parallel abstractions.
4. **Close the loop** — Run the narrowest useful validation. Update existing docs when the change makes them stale. Fix nearby instances when the same issue pattern clearly repeats.

Trust code/config over stale documentation when they differ. Mechanical tasks (typo, single import, obvious one-liner) skip this and go straight to the edit.

## Scope Discipline

- Do not modify shared/infrastructure files (Dockerfile, base images, shared build configs) to fix a local-only issue unless explicitly asked.
- Do not fabricate items in PR descriptions (e.g., 'approaches tried'). Only include what was actually done in the session.
- When uncertain about an experiment key, config key, or override value, ask rather than guess.

## Environment

- **Shell:** Zsh + Oh My Zsh, vi-mode, Starship prompt
- **Editor:** Neovim (Neovide GUI), `v` alias
- **Multiplexer:** Tmux with TPM
- **Version management:** mise (not asdf/nvm/pyenv)
- **Package managers:** Yarn (primary JS), Homebrew (macOS), pacman/yay (Arch)
- **Dotfiles:** GNU Stow from `~/Developer/personal/dots` → `common/`, `linux/`, `macos/`
- **Window managers:** AeroSpace (macOS), Sway (Linux laptop), KDE (Linux desktop)
- **Knowledge base:** Obsidian at `~/Developer/personal/Obsidian`

## CLI Tool Preferences

Prefer modern replacements over traditional Unix tools:

| Use              | Instead of             |
| ---------------- | ---------------------- |
| `rg` (ripgrep)   | `grep`                 |
| `fd`             | `find`                 |
| `bat`            | `cat`                  |
| `eza`            | `ls`                   |
| `delta`          | `diff`                 |
| `zoxide` (`z`)   | `cd`                   |
| `lazygit` (`gg`) | complex git operations |
| `yazi`           | file browsing          |
| `btop`           | `top`/`htop`           |
| `k9s`            | raw kubectl            |
| `lazydocker`     | raw docker commands    |

Also available: `jq`, `fzf`, `shellcheck`, `shfmt`, `stylua`, `fastfetch`, `gh`, `stow`, `mise`

## Applied learning

When something failed repeatedly, when the user has to re-explain, or when a workaround is found for a platform/tool limitation, add a one-line bullet here. Keep each bullet under 15 words. No explanations. Only add things that will save time in future sessions.
