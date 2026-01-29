#!/bin/bash

# =============================================================================
# Sway Desktop Environment Installation Script
# =============================================================================
# This script installs a complete Sway desktop environment with all necessary
# packages and configurations for EndeavourOS/Arch Linux.
#
# Features:
# - Installs 149+ packages for complete Sway setup
# - Sets up oh-my-zsh with plugins
# - Enables necessary system services
# - Creates required directories
# - Provides post-installation instructions
# =============================================================================

set -euo pipefail # Exit on error, undefined vars, pipe failures

# Parse command line arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
    --dry-run)
        DRY_RUN=true
        shift
        ;;
    -h | --help)
        echo "Usage: $0 [--dry-run] [--help]"
        echo "  --dry-run    Show what would be done without actually doing it"
        echo "  --help       Show this help message"
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTS_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON_INSTALL="$DOTS_ROOT/common/install.sh"
PACKAGES_FILE="$SCRIPT_DIR/packages-repository.txt"
MANUAL_INSTALLS_FILE="$SCRIPT_DIR/manual-installs.md"

# User information
if [ "$EUID" -eq 0 ]; then
    ACTUAL_USER="${SUDO_USER:-$USER}"
    USER_HOME="$(eval echo ~$ACTUAL_USER)"
else
    echo -e "${RED}Error: This script must be run with sudo${NC}"
    echo "Usage: sudo $0"
    exit 1
fi

# Logging
LOG_FILE="/tmp/sway-install-$(date +%Y%m%d-%H%M%S).log"

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

log_dry_run() {
    log "${CYAN}[DRY-RUN]${NC} $1"
}

# Function to check if package exists
package_exists() {
    yay -Si "$1" &>/dev/null
}

# Function to install packages with error handling
install_packages() {
    local packages=("$@")
    local failed_packages=()

    log_info "Installing ${#packages[@]} packages..."

    if [ "$DRY_RUN" = true ]; then
        log_dry_run "Would install the following packages:"
        printf '  - %s\n' "${packages[@]}" | tee -a "$LOG_FILE"
        return 0
    fi

    # Try to install all packages first
    if ! yay -S --noconfirm --needed --disable-download-timeout "${packages[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        log_warning "Bulk installation failed. Trying individual package installation..."

        # Install packages individually to identify failures
        for package in "${packages[@]}"; do
            log_info "Installing: $package"
            if ! yay -S --noconfirm --needed "$package" 2>&1 | tee -a "$LOG_FILE"; then
                log_error "Failed to install: $package"
                failed_packages+=("$package")
            else
                log_success "Installed: $package"
            fi
        done
    else
        log_success "All packages installed successfully"
    fi

    if [ ${#failed_packages[@]} -gt 0 ]; then
        log_warning "The following packages failed to install:"
        printf '%s\n' "${failed_packages[@]}" | tee -a "$LOG_FILE"
    fi
}

# Function to run common installation script
run_common_install() {
    log_info "Running common installation script..."

    if [ "$DRY_RUN" = true ]; then
        log_dry_run "Would run common/install.sh to setup:"
        log_dry_run "  - oh-my-zsh and plugins"
        log_dry_run "  - Starship prompt"
        log_dry_run "  - mise version manager"
        log_dry_run "  - TPM (Tmux Plugin Manager)"
        log_dry_run "  - bat cache rebuild"
        return 0
    fi

    if [ ! -f "$COMMON_INSTALL" ]; then
        log_error "Common install script not found: $COMMON_INSTALL"
        exit 1
    fi

    log_info "Executing: $COMMON_INSTALL"
    if sudo -u "$ACTUAL_USER" bash "$COMMON_INSTALL" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "Common installation completed"
    else
        log_error "Common installation failed"
        exit 1
    fi
}

# Function to create necessary directories
create_directories() {
    log_info "Creating necessary directories..."

    if [ "$DRY_RUN" = true ]; then
        log_dry_run "Would create the following directories:"
        log_dry_run "  - $USER_HOME/Pictures/Screenshots"
        log_dry_run "  - $USER_HOME/.config/systemd/user"
        log_dry_run "  - $USER_HOME/.local/bin"
        log_dry_run "  - $USER_HOME/.local/share/icons"
        log_dry_run "  - $USER_HOME/.local/share/themes"
        return 0
    fi

    local dirs=(
        "$USER_HOME/Pictures/Screenshots"
        "$USER_HOME/.config/systemd/user"
        "$USER_HOME/.local/bin"
        "$USER_HOME/.local/share/icons"
        "$USER_HOME/.local/share/themes"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            sudo -u "$ACTUAL_USER" mkdir -p "$dir"
            log_success "Created directory: $dir"
        else
            log_info "Directory already exists: $dir"
        fi
    done
}

# Function to enable system services
enable_services() {
    log_info "Enabling system services..."

    if [ "$DRY_RUN" = true ]; then
        log_dry_run "Would enable the following services:"
        log_dry_run "  - greetd.service"
        log_dry_run "  - NetworkManager.service"
        log_dry_run "  - bluetooth.service"
        log_dry_run "  - docker.service"
        log_dry_run "Would add $ACTUAL_USER to docker group"
        return 0
    fi

    # Enable greetd
    if systemctl is-enabled greetd.service &>/dev/null; then
        log_info "greetd.service already enabled"
    else
        systemctl enable greetd.service
        log_success "Enabled greetd.service"
    fi

    # Enable NetworkManager
    if systemctl is-enabled NetworkManager.service &>/dev/null; then
        log_info "NetworkManager.service already enabled"
    else
        systemctl enable NetworkManager.service
        log_success "Enabled NetworkManager.service"
    fi

    # Enable bluetooth
    if systemctl is-enabled bluetooth.service &>/dev/null; then
        log_info "bluetooth.service already enabled"
    else
        systemctl enable bluetooth.service
        log_success "Enabled bluetooth.service"
    fi

    # Enable docker (if user wants it)
    if systemctl is-enabled docker.service &>/dev/null; then
        log_info "docker.service already enabled"
    else
        systemctl enable docker.service
        usermod -aG docker "$ACTUAL_USER"
        log_success "Enabled docker.service and added $ACTUAL_USER to docker group"
    fi
}

# Function to show post-installation instructions
show_post_install_instructions() {
    log_info "Installation completed! Here are your next steps:"
    echo
    log "${CYAN}=== POST-INSTALLATION STEPS ===${NC}"
    echo
    log "${YELLOW}1. REBOOT YOUR SYSTEM${NC}"
    log "   A reboot is required for all services to start properly."
    echo
    log "${YELLOW}2. STOW YOUR DOTFILES${NC}"
    log "   Navigate to your dotfiles directory and run:"
    log "   ${GREEN}cd ~/Developer/dots${NC}"
    log "   ${GREEN}stow -t ~ common${NC}"
    log "   ${GREEN}stow -t ~ linux/sway${NC}"
    echo
    log "${YELLOW}3. MANUAL THEME INSTALLATION${NC}"
    log "   Some themes require manual installation. See:"
    log "   ${GREEN}$MANUAL_INSTALLS_FILE${NC}"
    echo
    log "${YELLOW}4. CONFIGURE GREETD${NC}"
    log "   Edit /etc/greetd/config.toml to set up your login manager"
    echo
    log "${YELLOW}5. TMUX PLUGIN MANAGER${NC}"
    log "   TPM was installed by common/install.sh"
    log "   Open tmux and press ${GREEN}Prefix + I${NC} to install plugins"
    echo
    log "${YELLOW}6. NEOVIM SETUP${NC}"
    log "   Run ${GREEN}nvim${NC} and let it install plugins automatically"
    echo
    log "${YELLOW}7. MISE VERSION MANAGER${NC}"
    log "   mise was installed by common/install.sh"
    log "   Install language versions with: ${GREEN}mise install${NC}"
    echo
    log "${CYAN}=== USEFUL COMMANDS ===${NC}"
    log "View installation log: ${GREEN}less $LOG_FILE${NC}"
    log "Check service status: ${GREEN}systemctl status greetd${NC}"
    log "Test sway: ${GREEN}sway --validate${NC}"
    echo
    log "${GREEN}Enjoy your new Sway desktop environment! 🌊${NC}"
}

# Main installation function
main() {
    log "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    log "${PURPLE}║              Sway Desktop Environment Installer              ║${NC}"
    log "${PURPLE}║                     for EndeavourOS/Arch                     ║${NC}"
    log "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo

    log_info "Starting installation for user: $ACTUAL_USER"
    log_info "User home directory: $USER_HOME"
    log_info "Installation log: $LOG_FILE"
    echo

    # Check if packages file exists
    if [ ! -f "$PACKAGES_FILE" ]; then
        log_error "Packages file not found: $PACKAGES_FILE"
        exit 1
    fi

    # Read packages from file (excluding comments and empty lines)
    mapfile -t packages < <(grep -v '^#' "$PACKAGES_FILE" | grep -v '^$')
    log_info "Found ${#packages[@]} packages to install"

    # Update system first
    log_info "Updating system packages..."
    if [ "$DRY_RUN" = true ]; then
        log_dry_run "Would update system with: yay -Syu --noconfirm"
    else
        if ! yay -Syu --noconfirm 2>&1 | tee -a "$LOG_FILE"; then
            log_warning "System update had issues, continuing..."
        else
            log_success "System updated successfully"
        fi
    fi

    # Run common installation first (oh-my-zsh, starship, mise, tpm, bat)
    run_common_install

    # Install packages
    install_packages "${packages[@]}"

    # Create directories
    create_directories

    # Enable services
    enable_services

    # Show post-installation instructions
    echo
    show_post_install_instructions
}

# Run main function
main "$@"
