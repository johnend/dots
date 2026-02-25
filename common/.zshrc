# ————————————————————————————————————————————————
# Deduplicate PATH automatically (zsh unique array)
# ————————————————————————————————————————————————
# This must be at the very top to ensure PATH stays unique throughout initialization
typeset -U PATH path

# Load system config
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"


# ————————————————————————————————————————————————————
# Powerlevel10k (disabled in favor of starship)
# ————————————————————————————————————————————————————
# Enable powerlevel10k instant prompt
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# oh-my-zsh core
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# ZSH_THEME="powerlevel10k/powerlevel10k"  # Disabled in favor of starship
ZSH_THEME=""  # Disable oh-my-zsh theme for starship

# TODO: Some things to look at for plugins:
# tmux, zsh-syntax-highlighting, zsh-completions
plugins=(
  colored-man-pages
  command-not-found
  fzf-tab
  gh
  git
  gradle
  yarn
  zsh-autosuggestions
  zsh-vi-mode
)

source "$ZSH/oh-my-zsh.sh"

# ————————————————————————————————————————————————————
# Zsh Vi Mode - Export mode for Starship
# ————————————————————————————————————————————————————
# Initialize VIM_MODE variable
export VIM_MODE="ins"
export STARSHIP_VIM_MODE="ins"

# Hook into zsh-vi-mode to export VIM_MODE variable and refresh prompt
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      STARSHIP_VIM_MODE="cmd"
      ;;
    $ZVM_MODE_INSERT)
      STARSHIP_VIM_MODE="ins"
      ;;
    $ZVM_MODE_VISUAL)
      STARSHIP_VIM_MODE="vis"
      ;;
    $ZVM_MODE_VISUAL_LINE)
      STARSHIP_VIM_MODE="vis"
      ;;
    $ZVM_MODE_REPLACE)
      STARSHIP_VIM_MODE="rep"
      ;;
    *)
      STARSHIP_VIM_MODE="ins"
      ;;
  esac
  # Force prompt refresh
  zle reset-prompt
}

# Also hook into the init to set initial mode
function zvm_after_init() {
  STARSHIP_VIM_MODE="ins"
}

# History settings
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
[[ -f "$HOME/.zsh_setopt" ]] && source "$HOME/.zsh_setopt"

# Aliases
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

# FZF
[[ -f "$HOME/.zsh_fzf" ]] && source "$HOME/.zsh_fzf"

# Completions
[[ -f "$HOME/.zsh_completions" ]] && source "$HOME/.zsh_completions"

# ————————————————————————————————————————————————————
# Powerlevel10k prompt (disabled in favor of starship)
# ————————————————————————————————————————————————————
# [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ————————————————————————————————————————————————————
# Starship prompt
# ————————————————————————————————————————————————————
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# mise (development tool version manager)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# Envman
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

# zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# thefuck
command -v thefuck &> /dev/null && eval "$(thefuck --alias)"

# jenv
# command -v jenv &> /dev/null && eval "$(jenv init -)"

# ————————————————————————————————————————————————————
# Additional config files
# ————————————————————————————————————————————————————
# Note: These files may contain environment variables
# Consider moving purely env-related content to .zshenv

# Secrets and credentials (should contain only env vars)
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Security
[[ -f "$HOME/.zsh_certs" ]] && source "$HOME/.zsh_certs"
