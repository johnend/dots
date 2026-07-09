# .zshenv - Environment variables for ALL shells (login, interactive, scripts)
#
# IMPORTANT: This file is sourced by ALL zsh invocations
# - Only put environment variables here (export FOO=bar)
# - NO aliases (they won't work in non-interactive shells)
# - NO functions
# - NO complex logic that could slow down scripts
#
# Load order: .zshenv → .zprofile → .zshrc → .zlogin

# ════════════════════════════════════════════════════════════════════════════════
# PATH CONFIGURATION
# ════════════════════════════════════════════════════════════════════════════════

# ────────────────────────────────────────────────────────────────────────────────
# Core paths (highest priority)
# ────────────────────────────────────────────────────────────────────────────────
typeset -gU PATH path
path=(
  "$HOME/bin"
  "$HOME/.config/emacs/bin"
  "$HOME/.local/share/mise/shims"
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  "$HOME/.cache/.bun/bin"
  $path
)

# DOOM
if [[ -d "$HOME/.config/emacs/bin" ]]; then
  export DOOMDIR="$HOME/.config/doom"
fi

# ────────────────────────────────────────────────────────────────────────────────
# macOS-specific paths
# ────────────────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  export PATH="$PATH:$HOME/Library/Python/3.9/bin"
  export PATH="$PATH:$HOME/.rd/bin"   # Rancher Desktop
  export PATH="$HOME/.codeium/windsurf/bin:$PATH"
fi

# ────────────────────────────────────────────────────────────────────────────────
# Linux-specific paths
# ────────────────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Ensure basic system paths exist (idempotent)
  [[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="$PATH:/usr/local/bin"
  [[ ":$PATH:" != *":/usr/bin:"* ]] && export PATH="$PATH:/usr/bin"
  [[ ":$PATH:" != *":/bin:"* ]] && export PATH="$PATH:/bin"
  [[ ":$PATH:" != *":/usr/sbin:"* ]] && export PATH="$PATH:/usr/sbin"
  [[ ":$PATH:" != *":/sbin:"* ]] && export PATH="$PATH:/sbin"
  
  # Language-specific paths
  export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
  
  # Go (macOS gets this from /etc/paths.d/go)
  [[ -d "/usr/local/go/bin" ]] && [[ ":$PATH:" != *":/usr/local/go/bin:"* ]] && export PATH="$PATH:/usr/local/go/bin"
fi

: "${GOPATH:=$HOME/go}"
[[ -d "$GOPATH/bin" ]] && export PATH="$GOPATH/bin:$PATH"

# ────────────────────────────────────────────────────────────────────────────────
# ════════════════════════════════════════════════════════════════════════════════
# ENVIRONMENT VARIABLES
# ════════════════════════════════════════════════════════════════════════════════

# ────────────────────────────────────────────────────────────────────────────────
# XDG Base Directory Specification
# ────────────────────────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ────────────────────────────────────────────────────────────────────────────────
# Editor configuration
# ────────────────────────────────────────────────────────────────────────────────
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

# Visual editor (defaults to EDITOR if not set)
export VISUAL="$EDITOR"

# ────────────────────────────────────────────────────────────────────────────────
# Pager configuration
# ────────────────────────────────────────────────────────────────────────────────
export PAGER="less"
export MANPAGER="nvim +Man!"

# ────────────────────────────────────────────────────────────────────────────────
# Locale and language
# ────────────────────────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ────────────────────────────────────────────────────────────────────────────────
# Shell-specific settings
# ────────────────────────────────────────────────────────────────────────────────
# ZSH autosuggestion styling
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ca9ee6"

# History file location (available to all shells)
export HISTFILE="$HOME/.zsh_history"

# Skip global compinit for faster startup (let .zshrc handle it)
skip_global_compinit=1

# ────────────────────────────────────────────────────────────────────────────────
# Project directories (OS-dependent)
# ────────────────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export DOTS="$HOME/Developer/dots"
  export PACMAN_CACHE="/var/cache/pacman"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTS="$HOME/Developer/personal/dots"
fi

# ────────────────────────────────────────────────────────────────────────────────
# Tool-specific settings
# ────────────────────────────────────────────────────────────────────────────────
# Zoxide exclude directories
export _ZO_EXCLUDE_DIRS="$HOME/.local/share/nvim/jdtls-workspace/*"

# Codex/Claude bash output length
export BASH_MAX_OUTPUT_LENGTH=15000

# ────────────────────────────────────────────────────────────────────────────────
# Security certificates (Netskope)
# ────────────────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == darwin* && -f "$HOME/netskope/certs/nscacert_combined.pem" ]]; then
  export REQUESTS_CA_BUNDLE=/opt/netskope/certs/nscacert_combined.pem
  export CURL_CA_BUNDLE=/opt/netskope/certs/nscacert_combined.pem
  export SSL_CERT_DIR=/opt/netskope/certs/nscacert_combined.pem
  export PIP_CERT=/opt/netskope/certs/nscacert_combined.pem
  export NODE_EXTRA_CA_CERTS=/opt/netskope/certs/nscacert_combined.pem
  export GIT_SSL_CAPATH=/opt/netskope/certs/nscacert_combined.pem
  export SSL_CERT_FILE=/opt/netskope/certs/nscacert_combined.pem
  export HTTPLIB2_CA_CERTS=/opt/netskope/certs/nscacert_combined.pem
  export DENO_TLS_CA_STORE=system
fi

# ════════════════════════════════════════════════════════════════════════════════
# DEVELOPMENT TOOLS
# ════════════════════════════════════════════════════════════════════════════════
