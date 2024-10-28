#!/bin/bash

# Check for dependencies
command -v git >/dev/null 2>&1 || { echo >&2 "Git is not installed. Please install Git and rerun the script."; exit 1; }
command -v zsh >/dev/null 2>&1 || { echo >&2 "Zsh is not installed. Please install Zsh and rerun the script."; exit 1; }

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
echo "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Install fzf-tab plugin
echo "Installing fzf-tab plugin..."
git clone https://github.com/Aloxaf/fzf-tab ~/.oh-my-zsh/custom/plugins/fzf-tab

# Install zsh-vi-mode plugin
echo "Installing zsh-vi-mode plugin..."
git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode

# Install fzf-yarn plugin
echo "Installing fzf-yarn plugin..."
git clone https://github.com/pierpo/fzf-yarn ~/.oh-my-zsh/plugins/fzf-yarn

# Install zsh-autosuggestions plugin
echo "Installing zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Set Zsh theme to Powerlevel10k in .zshrc
echo "Configuring Powerlevel10k in .zshrc..."
sed -i '' 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Add plugins to .zshrc
echo "Adding plugins to .zshrc..."
sed -i '' 's/plugins=(.*/plugins=(git fzf-tab zsh-vi-mode fzf-yarn zsh-autosuggestions)/' ~/.zshrc

# Reload Zsh configuration
echo "Reloading .zshrc..."
source ~/.zshrc

# Run Powerlevel10k configuration wizard
echo "Installation complete! Please restart your terminal or run 'source ~/.zshrc' if changes do not take effect."
