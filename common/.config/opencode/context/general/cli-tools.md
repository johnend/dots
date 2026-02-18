# Modern CLI Tools

**Last Updated:** 2026-02-05  
**Keywords:** bat, eza, fd, ripgrep, rg, fzf, lazygit, yazi, btop, delta, zoxide, k9s, lazydocker

---

## Rust-Based Replacements (Preferred)

**Philosophy:** Prefer modern Rust-based tools over traditional Unix tools for better performance and UX.

| Traditional | Modern Replacement | Purpose                   | Install Status |
| ----------- | ------------------ | ------------------------- | -------------- |
| `cat`       | `bat`              | Syntax highlighting       | ✅ Installed   |
| `ls`        | `eza`              | Icons and colors          | ✅ Installed   |
| `find`      | `fd`               | Faster, simpler syntax    | ✅ Installed   |
| `grep`      | `ripgrep` (`rg`)   | Blazing fast search       | ✅ Installed   |
| `cd`        | `zoxide` (`z`)     | Frecency-based navigation | ✅ Installed   |
| `diff`      | `delta`            | Better git diffs          | ✅ Installed   |

---

## Tool Usage Examples

### bat (Better cat)

```bash
bat file.txt              # Syntax highlighted output
bat -n file.txt           # Show line numbers
bat --style=plain file.txt # Plain output (no decorations)
```

### eza (Better ls)

```bash
eza                       # Basic listing with colors
eza -l                    # Long format
eza -la                   # Long format with hidden files
eza --tree                # Tree view
eza --git                 # Show git status
```

### fd (Better find)

```bash
fd pattern                # Find files matching pattern
fd -e js                  # Find all .js files
fd -H pattern             # Include hidden files
fd -t f pattern           # Files only
fd -t d pattern           # Directories only
```

### ripgrep (Better grep)

```bash
rg pattern                # Search for pattern
rg -i pattern             # Case insensitive
rg -t js pattern          # Search only .js files
rg --hidden pattern       # Include hidden files
rg -l pattern             # List files with matches
```

### zoxide (Better cd)

```bash
z project                 # Jump to most frecent match
z proj                    # Fuzzy matching works
zi                        # Interactive selection with fzf
```

### delta (Better diff)

```bash
# Automatically used by git (configured)
git diff                  # Uses delta
git show                  # Uses delta
git log -p                # Uses delta for commit diffs
```

---

## Additional TUI Tools

### Git Management

- **lazygit** - Terminal UI for git operations
  - Launch: `lazygit`
  - Features: Stage files, commit, push, rebase, resolve conflicts
  - Keybindings: Vi-style navigation

### File Management

- **yazi** - Terminal file manager
  - Launch: `yazi`
  - Features: Preview files, bulk operations, tabs
  - Keybindings: Vi-style navigation

### System Monitoring

- **btop** - Resource monitor (CPU, RAM, disk, network)
  - Launch: `btop`
  - Features: Interactive, mouse support, filtering

### System Information

- **fastfetch** - Fast system info display
  - Launch: `fastfetch`
  - Features: Logo, hardware info, package counts

### Fuzzy Finder

- **fzf** - Fuzzy finder (heavily used)
  - Integrated into shell (Ctrl+R for history, Ctrl+T for files)
  - Used by: zsh completions, tmux-sessionizer, other tools

### Container Management

- **k9s** - Kubernetes TUI
  - Launch: `k9s`
  - Features: View/manage pods, logs, deployments, services
  - Keybindings: Vi-style navigation

- **lazydocker** - Docker TUI
  - Launch: `lazydocker`
  - Features: View/manage containers, images, volumes, networks
  - Keybindings: Vi-style navigation

### Session Management

- **tmux-sessionizer** - Quick tmux session management
  - Launch: Custom keybinding (configured in tmux)
  - Features: Fuzzy find projects, create/switch sessions

---

## Installation Locations

### Via Homebrew (macOS)

```bash
/opt/homebrew/bin/bat
/opt/homebrew/bin/eza
/opt/homebrew/bin/fd
/opt/homebrew/bin/rg
/opt/homebrew/bin/delta
/opt/homebrew/bin/jq
/opt/homebrew/bin/fzf
/opt/homebrew/bin/gh
```

### Via Package Manager (Linux)

- Arch: `pacman -S bat eza fd ripgrep git-delta fzf`
- Ubuntu/Debian: Via apt or build from source

---

## Tool Preferences for AI Agents

When performing operations, prefer modern tools:

1. **Search code:** Use `rg` (ripgrep) over `grep`
2. **Find files:** Use `fd` over `find`
3. **View files:** Use `bat` over `cat` (when syntax highlighting helpful)
4. **List files:** Use `eza` over `ls` (when colors/icons helpful)
5. **Git diffs:** Use `git diff` (delta configured automatically)
6. **JSON processing:** Use `jq` for parsing/filtering

---

## GitHub CLI (gh)

### Installed: ✅

```bash
which gh  # /opt/homebrew/bin/gh
```

### Common Commands

```bash
# Repository
gh repo view
gh repo clone owner/repo

# Pull Requests
gh pr list
gh pr view <number>
gh pr create
gh pr checkout <number>

# Issues
gh issue list
gh issue view <number>
gh issue create

# Actions
gh run list
gh run view <id>
gh run watch

# API
gh api /user
gh api repos/:owner/:repo/issues
```

---

## JSON Processor (jq)

### Installed: ✅

```bash
which jq  # /opt/homebrew/bin/jq
```

### Common Usage

```bash
# Pretty print JSON
echo '{"name":"John"}' | jq

# Extract field
echo '{"name":"John"}' | jq '.name'

# Filter arrays
echo '[{"id":1},{"id":2}]' | jq '.[0]'

# Complex queries
cat data.json | jq '.users[] | select(.active == true) | .name'
```

---

**Related Files:**

- `ai-working-style.md` - Critical rules for AI behavior
- `dev-environment.md` - Development environment setup
- `git-workflow.md` - Git configuration (uses delta)
