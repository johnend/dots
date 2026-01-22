# Zsh Configuration Refactor - January 2026

## Overview
This document details the refactoring of zsh configuration files to fix load order issues, eliminate redundant PATH manipulation, and properly separate environment variables from aliases and functions.

## Problems Fixed

### 1. **EDITOR Variable Not Set for qvim**
- **Issue**: OpenCode AI was calling `nvim` instead of `qvim` because EDITOR was set to `nvim`
- **Fix**: Created `common/bin/qvim` wrapper script and updated EDITOR to use it
- **Files Changed**: 
  - Created `common/bin/qvim` (managed in dotfiles)
  - Updated `common/.zsh_env:41` (EDITOR="qvim")
  - Updated `common/.zsh_path:6` (added ~/bin to PATH)
  - Updated `common/.zsh_aliases:57-62` (removed redundant qvim alias)

### 2. **Aliases in Wrong File (.zshenv)**
- **Issue**: `~/.zshenv` contained aliases which don't work in non-interactive shells
- **Fix**: Moved aliases to `common/.zsh_aliases`
- **Aliases Moved**:
  - `alias assume=". assume"`
  - `alias postraf="posting --env ..."`

### 3. **Critical Environment Variables Not in Dotfiles**
- **Issue**: Homebrew shellenv, Android SDK, granted, RVM, Amazon Q were in unmanaged files
- **Fix**: Created `common/.zprofile` with all login shell configuration
- **Files Created**: `common/.zprofile`

### 4. **Missing .zshenv in Dotfiles**
- **Issue**: No managed `.zshenv` file; important env vars were scattered
- **Fix**: Created `common/.zshenv` with only environment variables
- **Files Created**: `common/.zshenv`

### 5. **Missing File Existence Checks**
- **Issue**: `.zshrc` would error if optional files weren't present
- **Fix**: Added `[[ -f ... ]]` checks before sourcing
- **Files Changed**: `common/.zshrc:2-6, 43-46`

### 6. **Duplicate PATH Manipulation**
- **Issue**: asdf shims were added to PATH in both `.zsh_env` and by the asdf plugin
- **Fix**: Removed manual PATH addition from `.zsh_env:12`
- **Files Changed**: `common/.zsh_env:12` (removed)

### 7. **Duplicate ZSH_CUSTOM Export**
- **Issue**: ZSH_CUSTOM was set in both `.zsh_env:29` and `.zshrc:15`
- **Fix**: Removed from `.zsh_env` (it's set in `.zshrc` before oh-my-zsh loads)
- **Files Changed**: `common/.zsh_env:29` (removed)

### 8. **Redundant FZF Sourcing**
- **Issue**: `fzf --zsh` already loads keybindings, but we were loading them again manually
- **Fix**: Removed manual sourcing of keybindings and completion
- **Files Changed**: `common/.zsh_fzf:45-51` (removed)

## New File Structure

```
common/
├── bin/
│   └── qvim             # Neovim wrapper script for EDITOR compatibility
├── .zshenv              # Environment variables only (loaded by ALL shells)
├── .zprofile            # Login shell setup (Homebrew, PATH, version managers)
├── .zshrc               # Interactive shell config (aliases, functions, prompts)
├── .zsh_env             # Additional env vars (sourced by .zshrc)
├── .zsh_path            # PATH configuration (sourced by .zshrc)
├── .zsh_aliases         # All aliases
├── .zsh_functions       # Custom functions
├── .zsh_fzf             # FZF configuration
├── .zsh_setopt          # Shell options
└── .p10k.zsh            # Powerlevel10k theme
```

## Load Order (Correct Zsh Behavior)

1. `.zshenv` - **ALWAYS** (login, interactive, non-interactive, scripts)
2. `.zprofile` - Login shells only
3. `.zshrc` - Interactive shells only
4. `.zlogin` - Login shells (after .zshrc)
5. `.zlogout` - When logging out

## Files That Remain Unmanaged (Intentionally)

- `~/.zsh_secrets` - Local secrets (build flags, pyenv, MySQL paths)
- `~/.zsh_certs` - Certificate configurations
- `~/.fzf.zsh` - Can be deleted (redundant with common/.zsh_fzf)

## Installation Instructions

### For Fresh Machine Setup

1. Clone dotfiles repo
2. Run `stow common -t $HOME` from dotfiles directory
   - This will symlink `common/bin/` to `~/bin/` (among other files)
   - The `qvim` script will be available system-wide
3. Create `~/.zsh_secrets` with machine-specific secrets (see template below)
4. Create `~/.zsh_certs` with machine-specific cert configs (if needed)
5. Restart shell or run `exec zsh`

### For Updating Existing Machine

1. **Backup existing config**:
   ```bash
   mkdir -p ~/zsh-backup-$(date +%Y%m%d)
   cp ~/.zshenv ~/.zprofile ~/.zlogin ~/zsh-backup-$(date +%Y%m%d)/
   ```

2. **Stow new files**:
   ```bash
   cd ~/Developer/personal/dots
   stow common -t $HOME
   ```

3. **Update secrets file** (if needed):
   - Review `~/.zsh_secrets` and ensure it has necessary content
   - See template below

4. **Delete redundant files** (optional):
   ```bash
   rm ~/.fzf.zsh  # Redundant with common/.zsh_fzf
   ```

5. **Restart shell**:
   ```bash
   exec zsh
   ```

### Template for ~/.zsh_secrets (Local Only)

```bash
# Build flags for compilation (macOS)
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# MySQL (Homebrew)
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# Build flags
export LDFLAGS="-L/usr/local/lib"
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/jpeg/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/mysql@8.0/lib $LDFLAGS"

export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"
export CPPFLAGS="-I/opt/homebrew/opt/jpeg/include $CPPFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/mysql@8.0/include $CPPFLAGS"

export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/jpeg/lib/pkgconfig:/opt/homebrew/opt/mysql@8.0/lib/pkgconfig"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
```

## Testing

After applying changes, test the following:

1. **Test qvim works as EDITOR**:
   ```bash
   echo $EDITOR  # Should output: qvim
   qvim --version  # Should launch nvim with NVIM_APPNAME=qvim
   ```

2. **Test OpenCode AI**:
   ```bash
   opencode
   # Try opening a file - should use qvim config
   ```

3. **Test aliases work**:
   ```bash
   type assume  # Should show: assume is an alias for . assume
   type postraf  # Should show: postraf is an alias for posting...
   ```

4. **Test PATH order**:
   ```bash
   echo $PATH | tr ':' '\n' | head -10
   # Should see ~/bin near the top
   ```

5. **Test no errors on startup**:
   ```bash
   zsh -lc 'echo "Success"'  # Should output: Success (no errors)
   ```

## Rollback Instructions

If something breaks:

1. **Restore backup**:
   ```bash
   cp ~/zsh-backup-YYYYMMDD/.zshenv ~/
   cp ~/zsh-backup-YYYYMMDD/.zprofile ~/
   cp ~/zsh-backup-YYYYMMDD/.zlogin ~/
   ```

2. **Unstow dotfiles**:
   ```bash
   cd ~/Developer/personal/dots
   stow -D common -t $HOME
   ```

3. **Restart shell**:
   ```bash
   exec zsh
   ```

## Notes

- The `qvim` script is now managed in `common/bin/` and will be available on all machines via stow
- `~/.zsh_secrets` should NEVER be committed to version control
- The refactor maintains backward compatibility with existing workflows
- Add other useful scripts to `common/bin/` as needed

## Adding New Scripts to common/bin/

To add new utility scripts that should be available across all your machines:

1. Create the script in `common/bin/`:
   ```bash
   touch ~/Developer/personal/dots/common/bin/myscript
   chmod +x ~/Developer/personal/dots/common/bin/myscript
   ```

2. Write your script with a proper shebang:
   ```bash
   #!/bin/sh
   # or #!/usr/bin/env bash, #!/usr/bin/env python3, etc.
   ```

3. Commit to dotfiles:
   ```bash
   cd ~/Developer/personal/dots
   git add common/bin/myscript
   git commit -m "common: bin - add myscript utility"
   ```

4. On other machines, run `stow common -t $HOME` to get the new script

## Date Applied
January 22, 2026
