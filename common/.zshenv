# config home
export XDG_CONFIG_HOME="$HOME/.config"
# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#a6adc8,fg+:#d0d0d0,bg:-1,bg+:#1e1e2e
  --color=hl:#7287fd,hl+:#5fd7ff,info:#cba6f7,marker:#a6e3a1
  --color=prompt:#b4befe,spinner:#cba6f7,pointer:#cba6f7,header:#87afaf
  --color=border:#313244,label:#aeaeae,query:#d0d0d0
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt=" "
  --marker=">" --pointer="" --separator="󰇜" --scrollbar="󱋱"
'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"


export FZF_ALT_C_COMMAND="fd --type d . --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# change default editor to nvim
export EDITOR=nvim

export PACMAN_CACHE=/var/cache/pacman/

# Firefox developer edition user directory
export FFD_USER_DIR=$HOME/.mozilla/firefox/6dh274r9.dev-edition-default/

# Autosuggestions highlight color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ca9ee6"

# Source cargo env
. "$HOME/.cargo/env"
