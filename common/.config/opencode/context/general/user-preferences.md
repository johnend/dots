# User Preferences & Working Style

**Last Updated:** 2026-02-02  
**Source:** Personal dotfiles + working patterns

## Development Environment

### Terminal & Shell

- **Primary Shell:** Zsh + Oh My Zsh
- **Terminal Emulators:**
  - macOS: Ghostty (primary), Alacritty
  - Linux: Ghostty (primary), Alacritty
- **Prompt:** Starship (Rust-based, fast)
- **Multiplexer:** Tmux with TPM (Tmux Plugin Manager)
- **Vi Mode:** zsh-vi-mode plugin enabled (INSERT/NORMAL/VISUAL modes)

### Zsh Plugins

- `colored-man-pages`
- `command-not-found`
- `fzf-tab` - FZF completion
- `gh` - GitHub CLI
- `git`
- `gradle`
- `yarn`
- `zsh-autosuggestions`
- `zsh-vi-mode`

### Editor Preferences

- **Primary Editor:** Neovim (nvim)
- **GUI Wrapper:** Neovide (both macOS and Linux)
- **EDITOR Variable:** `qvim` (custom wrapper for compatibility with AI tools)
- **Config Locations:** `~/.config/nvim/` and `~/.config/qvim`
- **Vi Mode:** Enabled everywhere (shell, editor)

### OpenCode Configuration

- **Config Location:** `~/.config/opencode/opencode.jsonc`
- **Commands:** Prefers markdown files in `~/.config/opencode/commands/*.md` (easier to read/edit)
- **OpenCode Docs:** https://github.com/anomalyco/opencode/tree/dev/packages/web/src/content/docs
  - **IMPORTANT:** When editing opencode.jsonc, reference the MDX docs in the GitHub repo above
  - Contains schema documentation, examples, and feature explanations
  - Prefer markdown command files over inline JSON commands

### Git Workflow

- **Core:**
  - Editor: nvim
  - Pager: delta (side-by-side, catppuccin-mocha theme)
  - Default branch: main
  - Merge conflict style: diff3
- **Commit Template:** Uses `~/.gitsettings/.gitmessage.txt`
- **Commit Style:** Conventional Commits via git aliases
  - `git fix "message"` → `fix: message`
  - `git feat "message"` → `feat: message`
  - `git chore`, `git docs`, `git style`, `git refactor`, `git test`
- **Branch Naming:** `<area>: <scope> - <summary>` pattern
- **Commit Guidelines:**
  - Imperative tense
  - Under 72 characters
  - Group related edits into single commit
  - **CRITICAL:** Never commit without owner sign-off
  - Post `git status` and `git diff --stat` for inspection first
- **Force Push:** Uses `--force-with-lease` (safer than `--force`)
- **GitHub:** Authenticated via gh CLI
- **LFS:** Enabled

### Version Management

- **Tool:** mise (migrated from asdf/pyenv/nvm)
- **Config:** `~/.config/mise/config.toml`
- **Features:**
  - Reads legacy `.tool-versions` files
  - Reads `.node-version`, `.python-version`, etc.
  - Faster than asdf
  - Task runner disabled globally
- **Managed Languages:** Node.js, Python, Ruby, Java, Go, Rust, PHP, Julia, Deno
- **Global Tools:** yarn 1.22

## Modern CLI Tools (Rust Replacements)

| Traditional | Replacement | Purpose                   |
| ----------- | ----------- | ------------------------- |
| `cat`       | `bat`       | Syntax highlighting       |
| `ls`        | `eza`       | Icons and colors          |
| `find`      | `fd`        | Faster, simpler syntax    |
| `grep`      | `ripgrep`   | Blazing fast search       |
| `cd`        | `zoxide`    | Frecency-based navigation |
| `diff`      | `delta`     | Better git diffs          |

### Additional CLI Tools

- **lazygit** - Git TUI
- **yazi** - Terminal file manager
- **btop** - Resource monitor
- **fastfetch** - System info
- **fzf** - Fuzzy finder (heavily used)
- **tmux-sessionizer** - Quick tmux session management
- **k9s** - Kubernetes TUI
- **lazydocker** - Docker TUI

## Work Preferences

### UI/Frontend Work

- **Preference:** ⚠️ **Prefers doing frontend work himself**
- **AI Behavior:**
  - ❌ NEVER implement UI without asking first
  - ✅ ALWAYS ask: "Would you like me to implement this UI, create basic structure, or just provide guidance?"
- **Reasoning:** Values control over visual/UX decisions

### Code Quality

- **Philosophy:** 🎯 **Readability over cleverness**
- **Comments:** Explain WHY, not WHAT (actionable comments only)
- **Testing:** Run validation scripts; prefer script-provided validation
- **Style:**
  - Shell scripts: 2-space indentation
  - Safe mode flags: `set -euo pipefail` for Bash
  - Constants: UPPER_SNAKE_CASE
  - Variables: lowercase_snake_case

### Git Commit Behavior

- **Preference:** ⚠️ **Manual git operations ONLY**
- **AI Behavior:**
  - ✅ DO: Make code changes
  - ✅ DO: Run tests
  - ✅ DO: Show `git status` and `git diff`
  - ❌ DON'T: Auto-commit
  - ❌ DON'T: Auto-push
  - ❌ DON'T: Create PRs automatically
  - ❌ DON'T: Amend commits without explicit request
- **Reasoning:** Wants to review and control all git operations
- **Workflow:** Post git status + git diff (preferably via delta), then wait for approval

### Testing Philosophy

- Execute validation scripts with `--dry-run` before touching live systems
- Rerun validation after modifying configs
- Test shell configs in subshell: `env ZDOTDIR=$(pwd)/common zsh -f`
- Manual test steps should be documented when automation is impossible
- Run `shellcheck` locally before committing complex scripts

## Project Organization

### Directory Structure

- **Work Projects:** `~/Developer/work/` (or similar)
- **Personal Projects:** `~/Developer/personal/`
- **Dotfiles:** `~/Developer/personal/dots`

### Dotfiles Structure

```
dots/
├── common/         # Cross-platform (nvim, zsh, git, tmux, starship, mise)
├── linux/          # Linux desktop (Sway, KDE, Hyprland)
├── macos/          # macOS-specific overrides
└── lib/            # Installation scripts
```

### Stow Workflow

```bash
stow common -t ~    # Symlink common configs
stow linux -t ~     # Linux-specific (if on Linux)
stow macos -t ~     # macOS-specific (if on macOS)
```

## Window Managers

- **Linux Laptop:** Sway (Wayland) - Lightweight and efficient
- **Linux Desktop:** KDE Plasma - Full-featured for GUI-heavy work
- **macOS:** AeroSpace - Tiling window manager

## Development Tools

### Containers & Orchestration

- Docker
- Kubernetes (kubectl, helm, k9s)
- Terraform

### Languages (via mise)

- Node.js, Python, Ruby, Go, Rust, PHP, Julia, Deno, Java, TypeScript, JavaScript

### File Management

- **Linux GUI:** Nemo
- **CLI:** yazi (terminal file manager)

## Communication Style

### Interaction Preferences

- **Verbosity:** Concise but complete
- **Detail Level:** Technical depth appreciated
- **Mode Support:**
  - `plan-first:` - Show detailed plan, wait for approval
  - `pause:` - Interactive step-by-step
  - `ultrawork:` or `ulw:` - Maximum automation, minimal interruption

### Decision Making

- **Autonomy:** Appreciates AI taking initiative on non-critical tasks in ultrawork mode
- **Critical Decisions:** ALWAYS consult on:
  - UI implementation
  - Git operations (commit, push, PR)
  - Deployment
  - Dependency changes
  - System-wide changes

## Tool Preferences

### Package Management

- **Node:** Yarn (primary)
- **Java:** Gradle
- **System (Linux):** pacman/yay (Arch-based)
- **System (macOS):** Homebrew
- **Dotfiles:** GNU Stow

### Shell Environment

- **Login Shell Setup:** `.zprofile` (Homebrew, PATH, version managers)
- **Environment Variables:** `.zshenv` (loaded by ALL shells)
- **Interactive Config:** `.zshrc` (aliases, functions, prompts)
- **Load Order:**
  1. `.zshenv` - ALWAYS
  2. `.zprofile` - Login shells
  3. `.zshrc` - Interactive shells

## Notes for AI Agents

### ALWAYS Remember

1. ⚠️ **Ask before implementing UI/frontend**
2. ⚠️ **Never auto-commit or auto-push**
3. 🎯 **Prefer readability over cleverness**
4. 📦 **User works with legacy code and monorepos**
5. 📝 **Use conventional commit format (fix:, feat:, etc.)**
6. 🔍 **Show git status + diff before committing**
7. 🧪 **Run tests and validation before declaring success**

### Preferred Workflows

- Use git aliases for commits: `git fix "message"`, `git feat "message"`
- Use delta for readable diffs
- Use lazygit for complex git operations
- Use tmux-sessionizer for project switching
- Use mise for version management (not asdf/nvm/pyenv)

### Code Style

- Shell: 2-space indent, safe mode flags
- TypeScript: Follow project ESLint/Prettier
- Readability > cleverness
- Explain WHY in comments, not WHAT

### Context Loading

This file should be loaded alongside project-specific context to provide personalized assistance.

---

**Source Files:**

- `~/Developer/personal/dots/.gitconfig`
- `~/Developer/personal/dots/AGENTS.md`
- `~/Developer/personal/dots/README.md`
- `~/Developer/personal/dots/common/.zshrc`
- `~/Developer/personal/dots/common/.config/starship.toml`
- `~/Developer/personal/dots/common/.config/mise/config.toml`
