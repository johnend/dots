#!/bin/bash

# =============================================================================
# Common Dotfiles Installation Script
# =============================================================================
# This script installs shell configuration and common tools that are
# shared across all environments (macOS, Linux).
#
# This script should be called by platform-specific install scripts.
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check for dependencies
command -v git >/dev/null 2>&1 || { log_error "Git is not installed. Please install Git and rerun the script."; exit 1; }
command -v zsh >/dev/null 2>&1 || { log_error "Zsh is not installed. Please install Zsh and rerun the script."; exit 1; }
command -v curl >/dev/null 2>&1 || { log_error "curl is not installed. Please install curl and rerun the script."; exit 1; }

log_info "Starting common dotfiles installation..."
echo

# =============================================================================
# Install Oh My Zsh
# =============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed"
else
    log_success "Oh My Zsh already installed"
fi
echo

# =============================================================================
# Install Zsh Plugins
# =============================================================================
log_info "Installing Zsh plugins..."

# fzf-tab plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]; then
    log_info "Installing fzf-tab plugin..."
    git clone https://github.com/Aloxaf/fzf-tab "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
    log_success "fzf-tab installed"
else
    log_success "fzf-tab already installed"
fi

# zsh-vi-mode plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode" ]; then
    log_info "Installing zsh-vi-mode plugin..."
    git clone https://github.com/jeffreytse/zsh-vi-mode "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
    log_success "zsh-vi-mode installed"
else
    log_success "zsh-vi-mode already installed"
fi

# fzf-yarn plugin
if [ ! -d "$HOME/.oh-my-zsh/plugins/fzf-yarn" ]; then
    log_info "Installing fzf-yarn plugin..."
    git clone https://github.com/pierpo/fzf-yarn "$HOME/.oh-my-zsh/plugins/fzf-yarn"
    log_success "fzf-yarn installed"
else
    log_success "fzf-yarn already installed"
fi

# zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    log_info "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    log_success "zsh-autosuggestions installed"
else
    log_success "zsh-autosuggestions already installed"
fi
echo

# =============================================================================
# Install Starship Prompt
# =============================================================================
if ! command -v starship &>/dev/null; then
    log_info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    log_success "Starship installed"
else
    log_success "Starship already installed"
fi
echo

# =============================================================================
# Install Mise (Version Manager)
# =============================================================================
if ! command -v mise &>/dev/null; then
    log_info "Installing mise (version manager)..."
    curl https://mise.run | sh
    log_success "mise installed"
    log_warning "You may need to restart your shell for mise to be available"
else
    log_success "mise already installed"
fi
echo

# =============================================================================
# Install TPM for Tmux
# =============================================================================
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    log_info "Installing TPM for tmux..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    log_success "TPM installed"
else
    log_success "TPM already installed"
fi
echo

# =============================================================================
# Update bat cache
# =============================================================================
if command -v bat &>/dev/null; then
    log_info "Rebuilding bat cache..."
    bat cache --build >/dev/null 2>&1
    log_success "bat cache rebuilt"
else
    log_warning "bat is not installed - install it via your package manager"
fi
echo

# =============================================================================
# Installation Complete
# =============================================================================
log_success "Common dotfiles installation complete!"
echo
log_info "Next steps:"
echo "  1. Stow your dotfiles: cd ~/Developer/personal/dots && stow -t ~ common"
echo "  2. Restart your shell or run: source ~/.zshrc"
echo "  3. Install language versions via mise: mise install"
echo
