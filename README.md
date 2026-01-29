# Dotfiles

Hey there 👋

Welcome to my dotfiles! These are set up to fit my workflow across both Mac and Linux. Feel free to explore, steal bits, and make them your own.

## 🚀 Quick Start

### Linux (EndeavourOS/Arch)

```bash
# Clone the repository
git clone <this-repo>
cd dots

# Run the Sway installer (installs everything)
sudo ./lib/sway/sway-install.sh

# Stow your dotfiles
stow common -t ~
stow linux -t ~

# Install language versions
mise install
```

See [`lib/sway/README.md`](lib/sway/README.md) for detailed installation instructions.

### macOS

```bash
# Clone the repository
git clone <this-repo>
cd dots

# Install common shell tools
bash common/install.sh

# Install packages via Homebrew
brew bundle --file=lib/macos/Brewfile

# Stow your dotfiles
stow common -t ~
stow macos -t ~

# Install language versions
mise install
```

See [`lib/macos/README.md`](lib/macos/README.md) for detailed installation instructions.

---

## 📁 Repository Structure

```
dots/
├── common/               # Cross-platform dotfiles
│   ├── .config/         # App configs (nvim, starship, mise, etc.)
│   ├── .zshrc           # Zsh configuration
│   ├── .tmux.conf       # Tmux configuration
│   └── install.sh       # Common installation script
│
├── linux/               # Linux-specific configs
│   ├── sway/           # Sway window manager
│   ├── hyprland/       # Hyprland (legacy)
│   └── kde/            # KDE Plasma
│
├── macos/               # macOS-specific configs
│   └── .config/        # macOS app overrides
│
└── lib/                 # Installation scripts and assets
    ├── sway/           # Sway installer and packages
    └── macos/          # macOS Brewfile
```

### Key Concepts

**common/** - Shared configurations that work across all platforms:
- Neovim, Tmux, Git, Shell (zsh), Starship prompt
- CLI tools: bat, eza, ripgrep, fzf, etc.
- Version manager: mise (replaces asdf, pyenv, nvm)

**linux/** - Linux desktop environment configurations:
- Window manager configs (Sway, Hyprland, KDE)
- Wayland-specific tools (Waybar, Rofi, SwayNC)

**macos/** - macOS-specific overrides:
- Font sizes for Retina displays
- macOS-specific keybindings

**lib/** - Installation tooling:
- Automated installers
- Package lists
- Validation scripts

---

## 🖥️ Screenshots

### Linux (Sway, Hyprland, KDE)

![image](https://github.com/user-attachments/assets/0b36b509-ab04-44a4-a9ed-5149191dc0f5)

My Linux machines run Sway and KDE. The `linux/` tree keeps shared and environment-specific configs under the same roof. Any common assets are stored in `common/.config`, while the Sway, Hyprland, and KDE setups live in `linux/sway`, `linux/hyprland`, and `linux/kde`, respectively.

See [`linux/sway/README.md`](linux/sway/README.md) for screenshots and details.

### macOS

![image](https://github.com/user-attachments/assets/fcfe09b8-98c5-4e51-960d-3121b8d752d4)

---

## 🛠️ Tools and Stack

### Shell & Prompt
- **Zsh + Oh My Zsh** - Enhanced shell with plugins (autosuggestions, syntax highlighting, fzf-tab)
- **Starship** - Fast, customizable prompt (replaced Powerlevel10k)
- **mise** - Unified version manager (replaced asdf, pyenv, nvm, etc.)

### Terminal Emulators
- **Linux:** Ghostty (primary), Alacritty
- **macOS:** Alacritty, WezTerm

### Window Managers
- **Linux Laptop:** Sway (Wayland) - Lightweight and efficient
- **Linux Desktop:** KDE Plasma - Full-featured for GUI-heavy work
- **macOS:** AeroSpace - Tiling window manager

### Editor
- **NeoVim** - All configs in `common/.config/nvim`
- **Neovide** - GUI wrapper for NeoVim (both platforms)

### Development Tools
- **Version Control:** Git, lazygit, GitHub CLI
- **Containers:** Docker, k9s, lazydocker, kubectl, helm
- **Languages:** Node.js, Python, Ruby, Go, Rust, PHP, Julia, Deno (managed via mise)
- **Infrastructure:** Terraform, Kubernetes tooling

### Modern CLI Tools

Replacing traditional Unix tools with modern alternatives:

| Traditional | Modern Alternative | Purpose                    |
| ----------- | ------------------ | -------------------------- |
| `cat`       | `bat`             | Syntax highlighting        |
| `ls`        | `eza`             | Icons and colors           |
| `find`      | `fd`              | Faster, simpler syntax     |
| `grep`      | `ripgrep`         | Blazing fast search        |
| `cd`        | `zoxide`          | Frecency-based navigation  |
| `diff`      | `delta`           | Better git diffs           |

### File Management
- **Linux GUI:** Nemo
- **CLI (both):** yazi (terminal file manager)

### System Monitoring
- **btop** - Resource monitor
- **fastfetch** - System info

---

## 📚 Documentation

Detailed documentation for each component:

- **[Common Installation](common/install.sh)** - Shell, prompt, version manager setup
- **[Linux/Sway Setup](lib/sway/README.md)** - Complete Sway desktop installation
- **[macOS Setup](lib/macos/README.md)** - Homebrew package management
- **[NeoVim Config](common/.config/nvim/README.md)** - Editor configuration
- **[Sway Configs](linux/sway/README.md)** - Window manager showcase

---

## 🔄 Installation Scripts

### `common/install.sh`

Cross-platform script that installs:
- oh-my-zsh and plugins (autosuggestions, syntax highlighting, fzf-tab)
- Starship prompt
- mise version manager
- Tmux Plugin Manager (TPM)
- bat cache rebuild

### `lib/sway/sway-install.sh`

Complete Sway desktop installation for Arch/EndeavourOS:
1. Calls `common/install.sh` first
2. Installs 200+ packages
3. Sets up system services
4. Creates required directories
5. Enables greetd, NetworkManager, Bluetooth, Docker

### `lib/macos/Brewfile`

Homebrew package manifest:
- Development tools
- CLI utilities
- GUI applications
- VS Code extensions
- Maintains parity with Linux package list

---

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Open issues for questions
- Suggest improvements
- Fork and adapt for your own use

---

## 📝 Notes

### Split Configurations

Some app configs (like Ghostty and Kitty) are split between `common/` and the OS-specific folder, using imports in the OS's config file. This allows tweaking platform-specific settings (like font sizes for Retina displays) without duplicating everything.

### Version Manager Migration

Recently migrated from **asdf** to **mise**:
- mise is faster and more compatible
- Reads legacy `.tool-versions` files
- Supports `.node-version`, `.python-version`, etc.
- Configuration: `~/.config/mise/config.toml`

### Prompt Migration

Recently migrated from **Powerlevel10k** to **Starship**:
- Written in Rust (much faster)
- Cross-platform consistency
- Easier to configure
- Configuration: `~/.config/starship.toml`

---
