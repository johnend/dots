# Global Preferences

## Git Workflow

- **Manual control only** — never auto-commit, auto-push, auto-merge, or auto-create PRs
- Show `git status` and `git diff --stat` before suggesting any commit
- Follow the repo's existing commit style (check `git log` first) — only use conventional commits (`fix:`, `feat:`, etc.) when the repo already does
- Branch naming: follow repo convention; default to `<type>: <scope> - <summary>` for personal repos
- When on a ticket branch (e.g. `ABC-123-some-feature`), prepend the ticket number to the first commit on the branch: `ABC-123 commit message`. Infer the ticket from the branch name.
- Use `--force-with-lease` over `--force`
- Git aliases available: `git fix "msg"`, `git feat "msg"`, `git chore "msg"`, etc.
- Delta configured as git pager (side-by-side, catppuccin-mocha)

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

## Destructive Operations

- State risk and ask explicitly before: force push, reset, bulk delete, production changes
- Run scoped validation/tests before declaring done

## Multi-Step Tasks

- For broad or multi-step work, propose a short plan first, then execute after confirmation

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

| Use | Instead of |
|-----|-----------|
| `rg` (ripgrep) | `grep` |
| `fd` | `find` |
| `bat` | `cat` |
| `eza` | `ls` |
| `delta` | `diff` |
| `zoxide` (`z`) | `cd` |
| `lazygit` (`gg`) | complex git operations |
| `yazi` | file browsing |
| `btop` | `top`/`htop` |
| `k9s` | raw kubectl |
| `lazydocker` | raw docker commands |

Also available: `jq`, `fzf`, `shellcheck`, `shfmt`, `stylua`, `fastfetch`, `gh`, `stow`, `mise`
