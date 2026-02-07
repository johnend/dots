# Development Environment

**Last Updated:** 2026-02-05  
**Keywords:** terminal, shell, editor, nvim, neovim, zsh, tmux, starship, mise, opencode

---

## Terminal & Shell

### Terminal Emulators
- **macOS:** Ghostty (primary), Alacritty
- **Linux:** Ghostty (primary), Alacritty

### Shell Configuration
- **Primary Shell:** Zsh + Oh My Zsh
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

### Shell Environment Load Order
1. `.zshenv` - ALWAYS loaded (environment variables)
2. `.zprofile` - Login shells (Homebrew, PATH, version managers)
3. `.zshrc` - Interactive shells (aliases, functions, prompts)

---

## Editor

### Primary Editor: Neovim
- **Binary:** nvim
- **GUI Wrapper:** Neovide (both macOS and Linux)
- **EDITOR Variable:** `qvim` (custom wrapper for compatibility with AI tools)
- **Config Locations:** 
  - `~/.config/nvim/` - Main Neovim config
  - `~/.config/qvim/` - qvim wrapper config
- **Vi Mode:** Enabled everywhere (shell, editor)

---

## OpenCode Configuration

### Configuration
- **Config Location:** `~/.config/opencode/opencode.jsonc`
- **Commands:** Prefers markdown files in `~/.config/opencode/commands/*.md` (easier to read/edit)
- **Context:** `~/.config/opencode/context/` directory

### Documentation Reference
- **OpenCode Docs:** https://github.com/anomalyco/opencode/tree/dev/packages/web/src/content/docs
- **IMPORTANT:** When editing opencode.jsonc, reference the MDX docs in the GitHub repo above
- Contains schema documentation, examples, and feature explanations
- Prefer markdown command files over inline JSON commands

---

## Version Management

### Mise (Modern Version Manager)
- **Tool:** mise (migrated from asdf/pyenv/nvm)
- **Config:** `~/.config/mise/config.toml`

### Features
- Reads legacy `.tool-versions` files
- Reads `.node-version`, `.python-version`, etc.
- Faster than asdf
- Task runner disabled globally

### Managed Languages
- Node.js
- Python
- Ruby
- Java
- Go
- Rust
- PHP
- Julia
- Deno
- TypeScript
- JavaScript

### Global Tools
- yarn 1.22

### Usage
```bash
mise install         # Install versions from config
mise use node@20     # Use specific version
mise ls              # List installed versions
mise current         # Show current versions
```

---

## Package Management

### By Language/Platform
- **Node:** Yarn (primary), npm, bun
- **Java:** Gradle
- **System (Linux):** pacman/yay (Arch-based)
- **System (macOS):** Homebrew
- **Dotfiles:** GNU Stow

---

## Window Managers

### By Platform
- **Linux Laptop:** Sway (Wayland) - Lightweight and efficient
- **Linux Desktop:** KDE Plasma - Full-featured for GUI-heavy work
- **macOS:** AeroSpace - Tiling window manager

---

## Container & Orchestration Tools

- **Docker** - Container runtime
- **docker-compose** - Multi-container orchestration
- **Kubernetes** - kubectl, helm, k9s
- **Terraform** - Infrastructure as code

---

## File Management

- **Linux GUI:** Nemo
- **CLI:** yazi (terminal file manager)

---

## Shell Scripting Style

### Bash/Zsh Style Guidelines
- **Indentation:** 2 spaces
- **Safety:** Always use `set -euo pipefail` at the top of scripts
- **Constants:** UPPER_SNAKE_CASE
- **Variables:** lowercase_snake_case
- **Functions:** lowercase_snake_case

### Example
```bash
#!/usr/bin/env bash
set -euo pipefail

readonly MAX_RETRIES=3
retry_count=0

check_service_status() {
  # Function implementation
}
```

---

## Key Environment Variables

- `EDITOR=qvim` - Primary editor
- `SHELL=/bin/zsh` - Login shell
- `TERM=xterm-256color` - Terminal type
- Various mise-managed language paths

---

**Related Files:**
- `ai-working-style.md` - Critical rules for AI behavior
- `git-workflow.md` - Git configuration and workflow
- `cli-tools.md` - Modern CLI tools reference
- `project-organization.md` - Directory structure and dotfiles
