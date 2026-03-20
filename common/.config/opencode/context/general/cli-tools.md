# Modern CLI Tools

## Replacements (always prefer these)

| Traditional | Modern | Purpose |
|-------------|--------|---------|
| `grep` | `rg` (ripgrep) | Code search |
| `find` | `fd` | File finding |
| `cat` | `bat` | Syntax-highlighted file viewing |
| `ls` | `eza` | File listing with icons/colors |
| `diff` | `delta` | Git diffs (auto-configured) |
| `cd` | `zoxide` (`z`) | Frecency-based directory jumping |

## TUI Tools

- **lazygit** (`gg`) — terminal git UI
- **yazi** — terminal file manager
- **btop** — resource monitor
- **k9s** — Kubernetes TUI
- **lazydocker** — Docker TUI
- **fzf** — fuzzy finder (integrated into shell: Ctrl+R history, Ctrl+T files)
- **fastfetch** — system info

## Other

- **jq** — JSON processing
- **gh** — GitHub CLI
- **shellcheck** — shell script linting
- **shfmt** — shell script formatting
- **stow** — dotfiles symlink management

## For AI Agents

Priority: 1) Specialized tools (Read/Grep/Glob) 2) Modern CLI (rg/fd/bat) in Bash 3) Traditional tools only as fallback
