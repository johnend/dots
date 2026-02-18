# Project Organization

**Last Updated:** 2026-02-05  
**Keywords:** directory, structure, dotfiles, stow, organization, projects

---

## Directory Structure

### Top-Level Organization
```
~/Developer/
├── work/           # Work-related projects
└── personal/       # Personal projects
    └── dots/       # Dotfiles repository
```

### Standard Paths
- **Work Projects:** `~/Developer/work/` (or similar)
- **Personal Projects:** `~/Developer/personal/`
- **Dotfiles:** `~/Developer/personal/dots`

---

## Dotfiles Structure

### Repository Layout
```
dots/
├── common/         # Cross-platform configs (nvim, zsh, git, tmux, starship, mise)
├── linux/          # Linux desktop specific (Sway, KDE, Hyprland)
├── macos/          # macOS-specific overrides
└── lib/            # Installation scripts
```

### Common Configs Included
- Neovim (`~/.config/nvim/`)
- Zsh (`~/.zshrc`, `~/.zshenv`, `~/.zprofile`)
- Git (`~/.gitconfig`, `~/.gitsettings/`)
- Tmux (`~/.tmux.conf`, `~/.config/tmux/`)
- Starship (`~/.config/starship.toml`)
- Mise (`~/.config/mise/config.toml`)

### Platform-Specific Configs
**Linux:**
- Sway window manager config
- KDE Plasma settings
- Hyprland config (if used)

**macOS:**
- AeroSpace window manager config
- macOS-specific overrides

---

## GNU Stow Workflow

### What is Stow?
GNU Stow creates symlinks from a repository to the home directory, making dotfiles management clean and version-controlled.

### Basic Commands
```bash
# From dots/ directory

# Symlink common configs
stow common -t ~

# Symlink platform-specific configs
stow linux -t ~     # On Linux
stow macos -t ~     # On macOS

# Remove symlinks (if needed)
stow -D common -t ~
```

### How It Works
```
dots/common/.config/nvim/init.lua
                    ↓ (stow creates symlink)
~/.config/nvim/init.lua
```

### Configuration
- **Stow Config:** `dots/.stowrc`
- Ignores: `.git`, `README.md`, `LICENSE`, etc.

---

## Window Manager Setup

### By Platform

**Linux Laptop:**
- **WM:** Sway (Wayland compositor)
- **Reason:** Lightweight and efficient for laptops
- **Config:** `dots/linux/.config/sway/config`

**Linux Desktop:**
- **WM:** KDE Plasma
- **Reason:** Full-featured for GUI-heavy work
- **Config:** `dots/linux/.config/plasma/`

**macOS:**
- **WM:** AeroSpace
- **Reason:** Tiling window manager for macOS
- **Config:** `dots/macos/.config/aerospace/`

---

## Project-Specific Files

### Common Project Files
- `.tool-versions` - mise version specifications (legacy)
- `.mise.toml` - mise configuration (modern)
- `.node-version` - Node.js version
- `.python-version` - Python version
- `.ruby-version` - Ruby version
- `.nvmrc` - nvm version (legacy, mise reads it)

### AI Agent Files
- `AGENTS.md` - Project-specific AI instructions (if exists in project root)
- `.ai/` - Custom AI commands and workflows (if exists)

---

## Context System Organization

### OpenCode Context Structure
```
~/.config/opencode/context/
├── general/                      # Always-available context
│   ├── ai-working-style.md      # Core AI behavior (always load)
│   ├── code-style.md            # Coding standards
│   ├── dev-environment.md       # Dev setup
│   ├── git-workflow.md          # Git conventions
│   ├── cli-tools.md             # CLI tool reference
│   └── project-organization.md  # This file
├── work/                         # Work-specific context
│   ├── conventions.md           # Work coding standards
│   ├── core/                    # Core patterns
│   ├── ui/                      # UI patterns
│   └── projects/                # Project-specific context
└── personal/                     # Personal projects context
    └── projects/                # Project-specific context
```

### Context Loading via GloomStalker
- **Priority 1:** Always-load files (`ai-working-style.md`, etc.)
- **Priority 2:** Core patterns matching keywords
- **Priority 3:** Project-specific context (auto-detected)
- **Priority 4:** Related contexts from metadata

---

## Dotfiles Management Best Practices

### When Making Changes
1. Edit files in `dots/` repository
2. Commit changes to git
3. Stow will automatically reflect changes (symlinks)
4. Test in subshell if modifying shell configs:
   ```bash
   env ZDOTDIR=$(pwd)/common zsh -f
   ```

### Adding New Configs
1. Place in appropriate directory (`common/`, `linux/`, `macos/`)
2. Follow existing structure (`.config/app/` pattern)
3. Run stow to create symlinks
4. Test thoroughly

### Sharing Across Machines
1. Push to git remote
2. Clone on new machine
3. Run stow commands
4. Machine-specific overrides go in platform directories

---

**Related Files:**
- `ai-working-style.md` - Critical rules for AI behavior
- `dev-environment.md` - Development environment setup
- `git-workflow.md` - Git workflow for dotfiles
