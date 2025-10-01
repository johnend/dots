# Sway Desktop Environment Installer

A comprehensive, automated installation toolkit for setting up a complete Sway desktop environment on EndeavourOS and Arch Linux systems. This toolkit provides everything needed to transform a minimal Linux installation into a fully-featured, modern desktop experience.

## ✨ What You Get

A complete desktop environment featuring:

- **Sway** - Modern Wayland compositor
- **Waybar** - Highly customizable status bar
- **Rofi** - Application launcher and dmenu replacement
- **Ghostty** - Modern terminal emulator
- **Firefox Developer Edition** - Web browser
- **Complete development environment** - Multiple programming languages and tools
- **Media applications** - Music, video, and image viewers
- **Rose Pine theme** - Beautiful, consistent theming throughout
- **Oh-My-Zsh** - Enhanced shell experience with plugins
- **149+ carefully curated packages**

## 📁 What's Included

| File                      | Purpose                                                    |
| ------------------------- | ---------------------------------------------------------- |
| `sway-install.sh`         | Main installation script with comprehensive error handling |
| `packages-repository.txt` | Complete list of 149+ packages for the desktop environment |
| `manual-installs.md`      | Guide for components requiring manual installation         |
| `update-packages.sh`      | Maintenance tool to keep package lists current             |
| `validate-environment.sh` | Health checker for troubleshooting installations           |
| `README.md`               | This documentation                                         |

## 🚀 Quick Installation

### Prerequisites

- Fresh EndeavourOS or Arch Linux installation
- `yay` AUR helper installed
- Internet connection
- Basic familiarity with terminal commands

### Installation Process

1. **Download the installer**

   ```bash
   git clone <this-repo>
   cd <repo>/lib/sway
   ```

2. **Test the installation (recommended)**

   ```bash
   sudo ./sway-install.sh --dry-run
   ```

   This shows exactly what will be installed without making any changes.

3. **Run the full installation**

   ```bash
   sudo ./sway-install.sh
   ```

4. **Follow post-installation instructions**
   The script will provide detailed next steps, including:
   - System reboot
   - Dotfiles setup (if using the accompanying configurations)
   - Manual theme installations
   - Service configuration

5. **Validate your installation**
   ```bash
   ./validate-environment.sh
   ```

## 🎯 Key Features

### 🛡️ Safe and Reliable

- **Dry-run mode** - Test before installing
- **Comprehensive error handling** - Graceful failure recovery
- **Detailed logging** - Full installation logs for troubleshooting
- **Package validation** - Ensures all packages exist before installation
- **Backup creation** - Automatic backups of modified configurations

### 🤖 Fully Automated

- **One-command installation** - Complete desktop environment setup
- **Service configuration** - Automatically enables necessary system services
- **Directory creation** - Sets up required folders and permissions
- **Shell enhancement** - Installs and configures oh-my-zsh with plugins
- **User group management** - Adds user to required groups (docker, etc.)

### 🔧 Maintenance Tools

- **Package list updater** - Keeps installations current
- **System validator** - Health checks for troubleshooting
- **Automated backups** - Safe configuration updates
- **Modular design** - Easy to customize and extend

## 📦 What Gets Installed

### Core Desktop Environment

- **Wayland compositor**: Sway with autotiling
- **Status bar**: Waybar with system information modules
- **Application launcher**: Rofi with custom themes
- **Display manager**: Greetd for login management
- **Notifications**: SwayNC notification daemon
- **Screen locking**: GTKLock with idle management

### Applications

- **Terminal**: Ghostty (modern GPU-accelerated terminal)
- **File manager**: Nemo with archive support
- **Web browser**: Firefox Developer Edition
- **Text editor**: Neovim with extensive plugin ecosystem
- **Media players**: Spotify, Clapper video player
- **Image viewer**: Geeqie with thumbnail support
- **Communication**: Vesktop (Discord), Beeper, Aerc email
- **Productivity**: Obsidian notes, QCalculate calculator

### Development Environment

- **Languages**: Node.js, Python, Go, Rust, Ruby, PHP, Julia
- **Tools**: Docker, Git, GitHub CLI, Lazygit
- **Editors**: Neovim, Neovide (GUI Neovim)
- **Version management**: ASDF for multiple language versions
- **Electronics**: KiCad with component libraries

### Command Line Tools

Modern replacements for traditional Unix tools:

- `bat` → Better `cat` with syntax highlighting
- `eza` → Enhanced `ls` with icons and colors
- `fd` → Faster `find` alternative
- `ripgrep` → Blazing fast text search
- `fzf` → Fuzzy finder for everything
- `zoxide` → Smarter `cd` command

### System Integration

- **Audio**: PipeWire with WirePlumber session manager
- **Networking**: NetworkManager with GUI tools
- **Bluetooth**: Full Bluetooth stack with Blueman
- **Fonts**: Comprehensive font collection including Nerd Fonts
- **Themes**: Rose Pine theme ecosystem
- **Screenshots**: Grim + Slurp for Wayland

## 🎨 Customization

The installation creates a cohesive visual experience with:

- **Rose Pine color scheme** throughout all applications
- **Consistent fonts** with proper icon support
- **Unified theming** across GTK applications
- **Custom Waybar configuration** with system monitoring
- **Rofi themes** matching the overall aesthetic

Some components require manual installation for full theming:

- Custom cursor themes
- Icon theme variants
- Advanced color schemes

See `manual-installs.md` for detailed instructions.

## 🔧 Maintenance and Updates

### Keep Your System Current

```bash
# Update package list based on your current system
./update-packages.sh

# Validate system health
./validate-environment.sh

# Check specific components
./validate-environment.sh | grep -E "(✗|!)"
```

### Troubleshooting

The validation script checks:

- Service status (greetd, NetworkManager, bluetooth)
- Core application availability
- Configuration file presence
- Wayland environment setup
- Font installation

## 🤝 Adaptation and Customization

This installer is designed to be adaptable. To customize for your needs:

1. **Modify package list**: Edit `packages-repository.txt`
2. **Test changes**: Use `--dry-run` mode
3. **Update maintenance tools**: Run `update-packages.sh`
4. **Validate modifications**: Use `validate-environment.sh`

### Adding New Packages

```bash
# Add package to packages-repository.txt
echo "new-package" >> packages-repository.txt

# Test the change
sudo ./sway-install.sh --dry-run

# Validate package exists
yay -Si new-package
```

## 🎯 Design Philosophy

This toolkit prioritizes:

- **Reliability**: Extensive error handling and validation
- **Transparency**: Clear logging and dry-run capabilities
- **Maintainability**: Tools for keeping installations current
- **User Experience**: Beautiful interface and helpful guidance
- **Flexibility**: Easy to adapt and customize
- **Completeness**: Everything needed for a production desktop

## ⚠️ Important Notes

- **Backup important data** before running on existing systems
- **Review the dry-run output** to understand what will be changed
- **Some packages are from AUR** and may take time to compile
- **Manual theme installation** may be required for complete visual consistency
- **Reboot required** after installation for all services to function properly

## 🆘 Support

If you encounter issues:

1. Check the installation log (location shown during installation)
2. Run `./validate-environment.sh` for system health check
3. Review `manual-installs.md` for theme-related issues
4. Verify all services are running: `systemctl status greetd NetworkManager bluetooth`

---

**Transform your Linux installation into a modern, beautiful, and productive desktop environment with a single command!** 🌊✨

_This installer has been tested on EndeavourOS and should work on any Arch-based distribution._

