# .zshenv - Environment variables for ALL shells (login, interactive, scripts)
#
# IMPORTANT: This file is sourced by ALL zsh invocations
# - Only put environment variables here (export FOO=bar)
# - NO aliases (they won't work in non-interactive shells)
# - NO functions
# - NO complex logic that could slow down scripts
#
# Load order: .zshenv → .zprofile → .zshrc → .zlogin

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Default editor
# Note: qvim is a wrapper script in ~/bin that launches nvim with NVIM_APPNAME=qvim
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
elif command -v qvim &>/dev/null; then
  export EDITOR="qvim"
elif command -v nvim &>/dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

# Visual editor (defaults to EDITOR if not set)
export VISUAL="$EDITOR"

# Pager
export PAGER="less"
export MANPAGER="nvim +Man!"

# Language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ZSH-specific variables
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ca9ee6"

# History file location (set here so it's available to all shells)
export HISTFILE="$HOME/.zsh_history"

# Dotfiles location (OS-dependent)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export DOTS="$HOME/Developer/dots"
  export PACMAN_CACHE="/var/cache/pacman"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTS="$HOME/Developer/personal/dots"
fi

# Zoxide exclude directories
export _ZO_EXCLUDE_DIRS="$HOME/.local/share/nvim/jdtls-workspace/*"

# Skip global compinit for faster startup (let .zshrc handle it)
skip_global_compinit=1
