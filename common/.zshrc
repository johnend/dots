# Load env vars and system config
source "$HOME/.zsh_env"
source "$HOME/.zsh_path"
source "$HOME/.zsh_functions"

# Enable powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh core
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(zsh-vi-mode fzf-tab gh git zsh-autosuggestions command-not-found colored-man-pages)

source "$ZSH/oh-my-zsh.sh"

# History settings
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history share_history hist_expire_dups_first hist_ignore_dups hist_verify

# Aliases
source "$HOME/.zsh_aliases"

# FZF
source "$HOME/.zsh_fzf"

# Powerlevel10k prompt
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Envman
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

# zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# thefuck
command -v thefuck &> /dev/null && eval "$(thefuck --alias)"

# jenv
command -v jenv &> /dev/null && eval "$(jenv init -)"

# Netskope certs (mac-specific)
if [[ "$OSTYPE" == darwin* && -f "$HOME/netskope/certs/nscacert_combined.pem" ]]; then
  export SSL_CERT_DIR="$HOME/netskope/certs"
  export REQUESTS_CA_BUNDLE="$SSL_CERT_DIR/nscacert_combined.pem"
  export CURL_CA_BUNDLE="$REQUESTS_CA_BUNDLE"
  export SSL_CERT_FILE="$REQUESTS_CA_BUNDLE"
  export NODE_EXTRA_CA_CERTS="$REQUESTS_CA_BUNDLE"
  export GIT_SSL_CAPATH="$REQUESTS_CA_BUNDLE"
  export PIP_CERT="$REQUESTS_CA_BUNDLE"
  export DENO_TLS_CA_STORE=system
fi

# 🤫
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
