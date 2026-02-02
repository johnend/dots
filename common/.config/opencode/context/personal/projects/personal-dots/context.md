# personal-dots Context

**Project Path:** `~/Developer/personal/dots`

## Overview

Personal dotfiles repository for cross-platform development environment. Manages shell configurations, editor setup (Neovim), terminal tools, window managers (Sway/KDE for Linux), and development tooling across macOS and Linux (EndeavourOS/Arch).

**Purpose:** Portable, reproducible development environment setup

## Tech Stack

### Shell & Terminal
- **Shell:** Zsh + Oh My Zsh
- **Prompt:** Starship (Rust-based, fast)
- **Multiplexer:** Tmux (with custom config)
- **Terminal Emulator:** 
  - macOS: Kitty, iTerm2
  - Linux: Kitty, foot (Wayland)

### Editor
- **Primary:** Neovim (qvim distribution)
- **GUI:** Neovide (Neovim GUI)
- **Config:** Lua-based (LazyVim/LunarVim style)

### CLI Tools
- **File listing:** eza (modern ls), lsd
- **File viewing:** bat (syntax-highlighted cat)
- **Search:** ripgrep (rg), fd (find replacement)
- **Navigation:** zoxide (smart cd), fzf
- **Git:** lazygit (TUI), delta (diff tool)
- **Process viewer:** bottom (btm), htop

### Version Management
- **mise:** Unified version manager (replaces asdf, nvm, pyenv, rbenv)
- **Languages:** Node.js, Python, Ruby, Rust, Go

### Linux Desktop (Sway/KDE)
- **Window Manager:** Sway (i3-like Wayland compositor)
- **Status Bar:** Waybar
- **Launcher:** Rofi (Wayland fork)
- **Notifications:** SwayNC
- **Screenshots:** Grim + Slurp
- **Clipboard:** wl-clipboard

### macOS Tools
- **Package Manager:** Homebrew
- **Window Manager:** Yabai (optional)
- **Hotkey Daemon:** skhd (optional)

## Project Structure

```
dots/
├── common/                      # Cross-platform configs
│   ├── .config/
│   │   ├── nvim/               # Neovim config (qvim)
│   │   ├── opencode/           # OpenCode AI agent configs
│   │   │   ├── agents/         # Agent profiles
│   │   │   └── context/        # Project contexts (created recently)
│   │   ├── starship.toml       # Starship prompt
│   │   ├── mise/               # Version manager
│   │   ├── tmux/               # Tmux plugins & config
│   │   ├── bat/                # Bat themes
│   │   ├── lazygit/            # Lazygit config
│   │   ├── kitty/              # Kitty terminal
│   │   └── zsh/                # Zsh scripts
│   ├── .zshrc                  # Main zsh config
│   ├── .tmux.conf              # Tmux config
│   ├── .gitconfig              # Git config (delta, conventional commits)
│   └── install.sh              # Common tools installer
│
├── linux/                      # Linux-specific configs
│   ├── .config/
│   │   ├── sway/              # Sway window manager
│   │   ├── waybar/            # Status bar
│   │   ├── rofi/              # Launcher
│   │   ├── SwayNC/            # Notifications
│   │   ├── hyprland/          # Hyprland (legacy)
│   │   └── kde/               # KDE Plasma
│   └── install.sh             # Linux tools installer
│
├── macos/                      # macOS-specific overrides
│   └── .config/
│       ├── kitty/             # Retina display font sizes
│       └── nvim/              # macOS-specific keybindings
│
├── lib/                        # Installation scripts
│   ├── sway/
│   │   ├── sway-install.sh    # Automated Sway setup
│   │   ├── packages.txt       # AUR/pacman packages
│   │   └── README.md          # Sway installation guide
│   └── macos/
│       ├── Brewfile           # Homebrew packages
│       └── README.md          # macOS installation guide
│
├── AGENTS.md                   # AI agent working guidelines (3246 bytes)
├── ZSH_REFACTOR_2026.md       # Zsh refactor notes (7685 bytes)
├── README.md                   # Main documentation (6834 bytes)
├── .gitconfig                  # Git configuration
├── .gitignore                  # Ignore patterns
└── .stowrc                     # GNU Stow configuration
```

## Key Concepts

### GNU Stow
Dotfiles are managed with **GNU Stow** - symlink farm manager:

```bash
# Stow common configs
stow common -t ~

# Stow platform-specific configs
stow linux -t ~    # Linux
stow macos -t ~    # macOS

# Remove stowed configs
stow -D common -t ~
```

**How it works:**
- `common/` contains dotfiles in their target structure
- `stow common -t ~` creates symlinks in home directory
- Changes to repo immediately reflect in dotfiles

### Platform Separation
- **common/**: Works on both macOS and Linux
- **linux/**: Sway/KDE/Wayland-specific
- **macos/**: macOS-specific overrides (font sizes, keybindings)
- **lib/**: Installation automation

### Version Management (mise)
Replaces multiple version managers with one tool:

```bash
# Install language versions from .mise.toml
mise install

# Manage versions
mise use node@20        # Use Node 20
mise use python@3.12    # Use Python 3.12
```

**Config:** `.config/mise/config.toml`

## Scripts

### Installation
```bash
# Linux (EndeavourOS/Arch)
sudo ./lib/sway/sway-install.sh   # Full Sway setup
stow common -t ~
stow linux -t ~
mise install

# macOS
bash common/install.sh            # Common tools
brew bundle --file=lib/macos/Brewfile
stow common -t ~
stow macos -t ~
mise install
```

### Maintenance
```bash
# Update packages
# macOS
brew update && brew upgrade

# Linux (Arch)
yay -Syu

# Update mise versions
mise upgrade
```

## Environment Setup

### Prerequisites
- **Git:** For cloning repository
- **GNU Stow:** For symlink management
  - macOS: `brew install stow`
  - Linux: `sudo pacman -S stow`

### macOS Setup
1. Install Xcode Command Line Tools: `xcode-select --install`
2. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Clone repo and run install scripts
4. Stow configs
5. Install mise: `brew install mise`
6. Install language versions: `mise install`

### Linux Setup (EndeavourOS/Arch)
1. Install base system
2. Clone repo
3. Run `sudo ./lib/sway/sway-install.sh` (installs Sway + all tools)
4. Stow configs
5. Install language versions: `mise install`

### Common Tools Installation
```bash
# Run common installer (both platforms)
cd ~/Developer/personal/dots
bash common/install.sh
```

## Testing Strategy

**Manual testing:**
- Test configs on fresh VM or clean user account
- Verify symlinks created correctly
- Test shell startup time: `time zsh -i -c exit`
- Test tool availability: `which nvim bat eza rg`

**No automated tests** in repository

## Team & Support

### Ownership
- **Maintainer:** John Enderby (personal project)
- **Usage:** Personal development environment

### Documentation
- **README.md:** Installation guides, structure overview
- **AGENTS.md:** AI agent working guidelines
- **ZSH_REFACTOR_2026.md:** Zsh configuration refactor notes
- **lib/sway/README.md:** Sway installation details
- **lib/macos/README.md:** macOS installation details

## Key Patterns

### Stow Structure
Each platform directory mirrors the home directory structure:

```
common/
  .config/
    nvim/     → ~/.config/nvim/
  .zshrc      → ~/.zshrc
```

When stowed, symlinks are created:
```bash
~/.config/nvim -> ~/Developer/personal/dots/common/.config/nvim
```

### Platform Overrides
macOS-specific configs override common ones:

1. Stow common: `~/.config/kitty -> common/.config/kitty`
2. Stow macos: `~/.config/kitty/font.conf -> macos/.config/kitty/font.conf`

### Zsh Configuration
- **Main:** `.zshrc` sources modular configs
- **Plugins:** Oh My Zsh + custom plugins
- **Prompt:** Starship (configured in `starship.toml`)
- **Aliases:** Defined in `.config/zsh/aliases.zsh`
- **Functions:** Defined in `.config/zsh/functions.zsh`

### Git Configuration
```gitconfig
[user]
    name = John Enderby
    email = john.enderby@fanduel.com

[core]
    pager = delta

[delta]
    navigate = true
    side-by-side = true

[commit]
    template = ~/.config/git/commit-template

[alias]
    # Conventional commits
    feat = "!f() { git commit -m \"feat: $@\"; }; f"
    fix = "!f() { git commit -m \"fix: $@\"; }; f"
```

## Important Notes

### Recent Changes (2026-01-30)
- **Added context system:** `.config/opencode/context/` directory
- **Project contexts:** Created for 8 FanDuel projects
- **User preferences:** Extracted to `user-preferences.md`
- **Agent updates:** Updated Artificer agent profile

### Shell Configuration
- **Vi-mode:** Enabled in Zsh (ESC for normal mode)
- **Starship:** Fast Rust-based prompt
- **Oh My Zsh:** Plugin framework (git, fzf, zoxide, etc.)

### Editor (Neovim/qvim)
- **Distribution:** qvim (custom Neovim config)
- **Language Servers:** Configured for TypeScript, Python, Rust, Go, Java
- **Keybindings:** Leader key = Space
- **Package Manager:** lazy.nvim

### Terminal Multiplexer (Tmux)
- **Prefix:** Ctrl+a (not Ctrl+b)
- **Plugins:** TPM (Tmux Plugin Manager)
- **Mouse support:** Enabled
- **Copy mode:** Vi-style

## Related Tools

### Development Tools
- **Node.js:** Managed by mise
- **Python:** Managed by mise
- **Ruby:** Managed by mise
- **Rust:** Managed by mise (rustup alternative)
- **Go:** Managed by mise

### CLI Replacements
- **ls → eza:** Modern ls with git integration
- **cat → bat:** Syntax highlighting
- **find → fd:** Fast, user-friendly
- **grep → rg:** Blazing fast ripgrep
- **cd → z:** Smart directory jumping (zoxide)
- **diff → delta:** Beautiful git diffs

## Common Tasks

### Adding New Dotfile
```bash
# 1. Add to common/ or platform-specific directory
cd ~/Developer/personal/dots
mkdir -p common/.config/newtool
echo "config" > common/.config/newtool/config.conf

# 2. Restow
stow -R common -t ~

# 3. Commit
git add common/.config/newtool
git commit -m "feat: add newtool config"
```

### Updating Package Lists
```bash
# macOS Brewfile
cd ~/Developer/personal/dots
brew bundle dump --file=lib/macos/Brewfile --force

# Linux packages
# Edit lib/sway/packages.txt manually
```

### Testing on Clean System
```bash
# Use VM or Docker
# macOS: Use Parallels/UTM
# Linux: Use QEMU/VirtualBox

# Clone repo
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Run installer
sudo ./lib/sway/sway-install.sh   # Linux
brew bundle --file=lib/macos/Brewfile  # macOS

# Stow configs
stow common -t ~
stow linux -t ~  # or macos
```

### Backing Up Current Configs
```bash
# Before stowing, backup existing configs
mkdir -p ~/.dotfiles-backup
cp -r ~/.config/nvim ~/.dotfiles-backup/
cp ~/.zshrc ~/.dotfiles-backup/
```

## Troubleshooting

### Stow Conflicts
```bash
# Error: existing target is not a symlink
# Solution: Remove or backup existing file
mv ~/.config/nvim ~/.config/nvim.bak
stow common -t ~
```

### Missing Dependencies
```bash
# macOS: Install from Brewfile
brew bundle --file=lib/macos/Brewfile

# Linux: Check packages.txt
yay -S --needed - < lib/sway/packages.txt
```

### Shell Slow Startup
```bash
# Profile zsh startup
time zsh -i -c exit

# Disable plugins one by one in .zshrc
# Comment out slow-loading plugins
```

### Neovim Issues
```bash
# Rebuild qvim
cd ~/.local/share/nvim
rm -rf lazy-lock.json
nvim  # Let lazy.nvim reinstall plugins
```

## Monitoring & Observability

**No monitoring** - Personal dotfiles repository

## Version Control

### Git Workflow
- **Main branch:** Stable, tested configs
- **Feature branches:** Test new configs before merging
- **Commit messages:** Conventional commits (feat:, fix:, chore:)

### Backup Strategy
- **Git remote:** GitHub (private repository)
- **Push frequency:** After major changes
- **Tags:** Version releases (v1.0.0, v2.0.0)

## Future Enhancements

- [ ] Automated testing with Docker
- [ ] Dotfile validation scripts
- [ ] Ansible playbooks for full system setup
- [ ] Secrets management (age, pass, 1Password CLI)
- [ ] Cross-platform keybinding sync
- [ ] Backup/restore scripts for app data
