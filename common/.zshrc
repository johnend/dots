# Load env vars and system config
source "$HOME/.zsh_env"
source "$HOME/.zsh_path"
source "$HOME/.zsh_functions"

source "$HOME/.asdf/plugins/java/set-java-home.zsh"

# Enable powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh core
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(asdf zsh-vi-mode fzf-tab gh git zsh-autosuggestions command-not-found colored-man-pages)

source "$ZSH/oh-my-zsh.sh"

# History settings
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
[[ -f "$HOME/.zsh_setopt" ]] && source "$HOME/.zsh_setopt"

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
# command -v jenv &> /dev/null && eval "$(jenv init -)"

# Netskope certs (mac-specific)
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

# 🤫
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
