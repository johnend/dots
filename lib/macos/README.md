# macOS Development Environment Setup

A comprehensive package and tool collection for macOS development, featuring a unified version management system and cross-platform shell tools that work seamlessly with the Linux configurations in this repository.

## ✨ What You Get

A complete development environment featuring:

- **mise** - Unified version manager (replaces asdf, pyenv, nvm, etc.)
- **Starship** - Fast, customizable shell prompt
- **Oh-My-Zsh** - Enhanced shell with plugins
- **Complete development toolchain** - Docker, Kubernetes, Terraform, and more
- **Modern CLI tools** - bat, eza, fd, ripgrep, fzf, zoxide, and more
- **Cross-platform consistency** - Same tools as Linux setup

## 📁 What's Included

| File        | Purpose                                    |
| ----------- | ------------------------------------------ |
| `Brewfile`  | Complete list of packages via Homebrew    |
| `README.md` | This documentation                        |

## 🚀 Quick Installation

### Prerequisites

- macOS (tested on recent versions)
- Xcode Command Line Tools
- Internet connection

### Installation Steps

1. **Install Homebrew** (if not already installed)

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Clone this repository**

   ```bash
   git clone <this-repo>
   cd <repo>
   ```

3. **Run common installation script**

   This installs oh-my-zsh, Starship prompt, mise, TPM, and configures bat:

   ```bash
   bash common/install.sh
   ```

4. **Install packages from Brewfile**

   ```bash
   brew bundle --file=lib/macos/Brewfile
   ```

5. **Stow your dotfiles**

   ```bash
   stow common -t $HOME
   stow macos -t $HOME
   ```

6. **Install language versions**

   ```bash
   mise install
   ```

## 📦 What Gets Installed

### Version Management

- **mise** - Unified version manager for Node.js, Python, Ruby, Go, and more
  - Replaces: asdf, pyenv, nvm, nodenv, rbenv, goenv, jenv
  - Config: `~/.config/mise/config.toml`
  - Legacy support: Reads `.tool-versions`, `.node-version`, `.python-version`, etc.

### Shell & Prompt

- **Starship** - Fast, customizable prompt with git status, language versions, cloud contexts
- **Oh-My-Zsh** - Plugin framework (installed via `common/install.sh`)
- **fzf** - Fuzzy finder for command history and file navigation
- **zoxide** - Smarter `cd` command

### Development Tools

#### Editors
- Neovim
- Emacs
- nano with nanorc

#### Git Tools
- GitHub CLI (`gh`)
- lazygit
- git-delta (better diffs)

#### Build Tools
- automake
- cmake
- make
- gcc

#### Container & Kubernetes
- Docker (requires separate installation)
- docker-credential-helper
- colima (Docker runtime for macOS)
- kubectl
- helm
- k9s
- lazydocker
- minikube

#### Infrastructure as Code
- Terraform
- granted (AWS profile manager)

#### Programming Languages
- PHP with Composer
- Deno
- Julia
- OpenJDK 21

#### Language Tools
- luarocks
- stylua (Lua formatter)
- tree-sitter-cli

### Command Line Utilities

#### Modern Replacements
- **bat** → Better `cat` with syntax highlighting
- **eza** → Enhanced `ls` with icons
- **fd** → Faster `find`
- **ripgrep** → Blazing fast grep
- **fzf** → Fuzzy finder
- **zoxide** → Smarter `cd`
- **thefuck** → Command correction

#### File Management
- stow (dotfile manager)
- tree
- yazi (terminal file manager)
- rsync

#### System Utilities
- btop (system monitor)
- fastfetch (system info)
- watchman (file watcher)
- pv (pipe viewer)
- tldr (simplified man pages)

#### Compression & Archives
- sevenzip
- unrar

#### Text Processing
- jq (JSON processor)
- grep (GNU version)
- sed (GNU version)

#### Media & Images
- imagemagick
- ghostscript
- poppler (PDF tools)
- ffmpegthumbnailer

#### Document Processing
- pandoc
- tectonic (modern TeX)
- mermaid-cli

#### Network Tools
- curl
- wget
- mkcert (local SSL certificates)
- unbound
- gnutls

#### Terminal & tmux
- tmux
- tmuxinator (installed via `common/install.sh`)

#### Python Tooling
- pipx (isolated Python app installer)

#### Database Clients
- mysql-client
- mysql@8.0
- postgresql@14

### Spotify
- spotify_player (terminal Spotify client)

### QMK Firmware
- qmk (keyboard firmware toolkit)
- qemu (for QMK testing)

### macOS Specific
- borders (window borders for tiling WMs)

### GUI Applications (Casks)
- 1password-cli
- AeroSpace (tiling window manager)
- Alacritty (terminal)
- Font: Recursive Mono Nerd Font
- Neovide (GUI Neovim)
- OpenLens (Kubernetes UI)
- QMK Toolbox
- Rancher Desktop
- WezTerm (terminal)

## 🔧 Configuration

### mise (Version Manager)

mise replaces multiple version managers with a single unified tool:

```bash
# List available versions
mise ls-remote node

# Install a version
mise use --global node@22

# Install from .tool-versions
mise install

# Show current versions
mise current

# Update mise itself
mise self-update
```

**Config location:** `~/.config/mise/config.toml`

### Starship (Prompt)

Starship provides a fast, feature-rich prompt:

- Git status and branch info
- Language versions (Node, Python, Go, etc.)
- Cloud contexts (AWS, Kubernetes)
- Execution time for long commands
- Exit codes

**Config location:** `~/.config/starship.toml`

### Homebrew

Keep your system updated:

```bash
# Update Homebrew and packages
brew update && brew upgrade

# Check for issues
brew doctor

# Cleanup old versions
brew cleanup

# Generate updated Brewfile
brew bundle dump --file=lib/macos/Brewfile --force
```

## 🎯 Cross-Platform Consistency

This setup maintains consistency with the Linux configuration:

| Tool Category     | macOS                 | Linux                 |
| ----------------- | --------------------- | --------------------- |
| Version Manager   | mise                  | mise                  |
| Prompt            | Starship              | Starship              |
| Shell Framework   | Oh-My-Zsh             | Oh-My-Zsh             |
| Terminal          | Alacritty/WezTerm     | Ghostty/Alacritty     |
| Editor            | Neovim                | Neovim                |
| File Manager      | yazi (CLI)            | yazi (CLI), Nemo (GUI)|
| System Monitor    | btop                  | btop                  |
| Git UI            | lazygit               | lazygit               |
| Container UI      | lazydocker            | lazydocker            |
| Kubernetes UI     | k9s                   | k9s                   |

## 🤝 Adaptation and Customization

To customize for your needs:

1. **Modify Brewfile**: Add or remove packages
2. **Test installation**: Run `brew bundle --file=lib/macos/Brewfile --dry-run`
3. **Apply changes**: Run `brew bundle --file=lib/macos/Brewfile`
4. **Update Brewfile**: Run `brew bundle dump --force` to regenerate

### Adding New Packages

```bash
# Search for a package
brew search <package>

# Get package info
brew info <package>

# Add to Brewfile
echo 'brew "<package>"' >> lib/macos/Brewfile

# Install
brew bundle --file=lib/macos/Brewfile
```

## 🆘 Troubleshooting

### Homebrew Issues

```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/Homebrew

# Reinstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### mise Issues

```bash
# Verify installation
mise doctor

# Clear cache
rm -rf ~/.local/share/mise

# Reinstall
brew reinstall mise
```

### Shell Issues

```bash
# Reload shell configuration
source ~/.zshrc

# Check shell
echo $SHELL

# Set default shell to zsh
chsh -s $(which zsh)
```

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [mise Documentation](https://mise.jdx.dev/)
- [Starship Documentation](https://starship.rs/)
- [Oh-My-Zsh Documentation](https://ohmyz.sh/)

---

**Enjoy your macOS development environment!** 🍎✨
