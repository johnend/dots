# .zprofile - Login shell configuration (runs BEFORE .zshrc)
#
# Use this file for:
# - Setting up PATH (before interactive tools need it)
# - Initializing language version managers (asdf, rvm, pyenv, etc.)
# - One-time login setup
#
# Load order: .zshenv → .zprofile → .zshrc → .zlogin

# ————————————————————————————————————————————————
# Homebrew (macOS & Linux)
# ————————————————————————————————————————————————
# This must be early so brew-installed tools are available
if [[ -x /opt/homebrew/bin/brew ]]; then
  # macOS Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  # macOS Intel or Linuxbrew
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ————————————————————————————————————————————————
# Amazon Q (AWS CLI assistant)
# ————————————————————————————————————————————————
# Q pre block
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && \
  builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

# ————————————————————————————————————————————————
# Android SDK (macOS)
# ————————————————————————————————————————————————
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  # Only add to PATH if not already present (prevents duplicates on re-sourcing)
  [[ ":$PATH:" != *":$ANDROID_HOME/emulator:"* ]] && export PATH="$PATH:$ANDROID_HOME/emulator"
  [[ ":$PATH:" != *":$ANDROID_HOME/tools:"* ]] && export PATH="$PATH:$ANDROID_HOME/tools"
  [[ ":$PATH:" != *":$ANDROID_HOME/tools/bin:"* ]] && export PATH="$PATH:$ANDROID_HOME/tools/bin"
  [[ ":$PATH:" != *":$ANDROID_HOME/platform-tools:"* ]] && export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

# ————————————————————————————————————————————————
# Granted CLI (AWS assume role tool)
# ————————————————————————————————————————————————
# Add completions to fpath if granted is installed
if [[ -d "$HOME/.granted/zsh_autocomplete" ]]; then
  fpath=("$HOME/.granted/zsh_autocomplete/assume" $fpath)
  fpath=("$HOME/.granted/zsh_autocomplete/granted" $fpath)
fi

# ————————————————————————————————————————————————
# Amazon Q (post-hook)
# ————————————————————————————————————————————————
# Q post block
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh" ]] && \
  builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh"
