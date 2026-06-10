# Global Preferences

## Git Workflow

- **Manual control only** — never auto-commit, auto-push, auto-merge, or auto-create PRs
- Never include any `Co-Authored-By` trailer in commit messages — overrides Claude Code's default. Enforced by `hooks/block-coauthored-by.sh`.
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
- Shell scripts: `set -euo pipefail` (advised by `hooks/check-shell-safe-mode.sh`), 2-space indent, UPPER_SNAKE_CASE constants, lowercase_snake_case variables/functions
- Inside bash functions, never combine `local` with command substitution (`local x=$(cmd)`) — `local` always returns 0 and silently swallows the inner exit status; declare and assign on separate lines. Advised by `hooks/check-local-assignment.sh`.

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
- Output format: **Summary** → **Test Coverage** → findings table (File:Line | Severity | Category | Finding) → **Suggestions**
- Use diplomatic, collegial tone for critical feedback
- Never auto-comment or post to GitHub — draft only, for user approval
- For per-reviewer pattern tracking (e.g. `get-pr-comments`), exclude AI authors (Copilot, CodeRabbit, Sonarcloud, Greptile, Ellipsis, anything matching `*[bot]`) — their comments still appear in the action list but don't accumulate against human reviewers

## Sandbox Permissions

- When a Bash command is blocked by sandbox permissions, immediately surface the block — never silently skip or work around it
- Propose the specific pattern that would allow it and ask whether to add it to the allowlist
- Use the `manage-sandbox-allowlist` skill to apply the change, then re-attempt the original command
- The sandbox blocks `gh` config access, `~/.npmrc` reads, and some pre-commit hooks. If a command fails due to sandbox, retry with sandbox disabled rather than working around it.
- Never use `2>/dev/null` on commands whose stderr matters for debugging — build tools (gradle, mvn, tsc, jest, pytest, etc.) and remote-contact commands (`gh`, `git push/fetch/pull/ls-remote/commit`). Enforced by `hooks/block-stderr-suppression.sh`.

## Destructive Operations

- State risk and ask explicitly before: force push, reset, bulk delete, production changes
- Run scoped validation/tests before declaring done
- Package managers: lockfile installs (`npm install`, `yarn`, `pnpm install`, `bun install`, `npm ci`) and script runs (`npm run X`, `yarn X`, etc.) are fine. Never modify dependencies without explicit confirmation. Enforced by `hooks/block-dependency-changes.sh` and the `yarn add/remove/upgrade` deny patterns.

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
