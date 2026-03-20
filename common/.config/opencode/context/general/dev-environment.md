# Development Environment

## Terminal & Shell

- **Terminal:** Ghostty (primary), Alacritty (fallback)
- **Shell:** Zsh + Oh My Zsh, Starship prompt, vi-mode (`zsh-vi-mode`)
- **Multiplexer:** Tmux with TPM
- **File manager:** yazi (CLI)

## Editor

- **Primary:** Neovim (`nvim`, alias `v`)
- **GUI:** Neovide (macOS and Linux)
- **EDITOR variable:** `qvim` (custom wrapper)

## Version Management

**mise** (not asdf/nvm/pyenv). Reads `.tool-versions`, `.node-version`, etc.
- `mise install`, `mise use node@20`, `mise ls`, `mise current`

## Package Managers

- **Node:** Yarn (primary), npm, bun
- **Java:** Gradle
- **macOS:** Homebrew
- **Linux:** pacman/yay (Arch-based)
- **Dotfiles:** GNU Stow

## Window Managers

- **macOS:** AeroSpace
- **Linux laptop:** Sway (Wayland)
- **Linux desktop:** KDE Plasma

## Containers

Docker, docker-compose, Kubernetes (kubectl, helm, k9s), Terraform
