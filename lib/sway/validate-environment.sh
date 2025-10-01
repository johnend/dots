#!/bin/bash

# =============================================================================
# Sway Environment Validator
# =============================================================================
# This script validates that a sway installation is working correctly by
# checking services, dependencies, and configurations.
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "$1"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_success() {
    log "${GREEN}[✓]${NC} $1"
}

log_warning() {
    log "${YELLOW}[!]${NC} $1"
}

log_error() {
    log "${RED}[✗]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check service status
check_service() {
    local service=$1
    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        if systemctl is-active "$service" >/dev/null 2>&1; then
            log_success "Service $service is enabled and running"
        else
            log_warning "Service $service is enabled but not running"
        fi
    else
        log_error "Service $service is not enabled"
    fi
}

# Function to check user service status
check_user_service() {
    local service=$1
    local user=${2:-$USER}
    
    if sudo -u "$user" systemctl --user is-enabled "$service" >/dev/null 2>&1; then
        if sudo -u "$user" systemctl --user is-active "$service" >/dev/null 2>&1; then
            log_success "User service $service is enabled and running"
        else
            log_warning "User service $service is enabled but not running"
        fi
    else
        log_info "User service $service is not enabled (may be started manually)"
    fi
}

# Main validation function
main() {
    log "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    log "${PURPLE}║                 Sway Environment Validator                  ║${NC}"
    log "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    # Check core sway components
    log "${CYAN}=== Core Sway Components ===${NC}"
    
    if command_exists sway; then
        log_success "Sway is installed"
        if sway --version >/dev/null 2>&1; then
            version=$(sway --version | head -1)
            log_info "Version: $version"
        fi
    else
        log_error "Sway is not installed"
    fi
    
    if command_exists waybar; then
        log_success "Waybar is installed"
    else
        log_error "Waybar is not installed"
    fi
    
    if command_exists rofi; then
        log_success "Rofi is installed"
    else
        log_error "Rofi is not installed"
    fi
    
    echo
    
    # Check system services
    log "${CYAN}=== System Services ===${NC}"
    check_service "greetd.service"
    check_service "NetworkManager.service"
    check_service "bluetooth.service"
    check_service "pipewire.service" || log_info "PipeWire may be user service"
    
    echo
    
    # Check user services (if not in sway session)
    if [ -n "${USER:-}" ] && [ "$USER" != "root" ]; then
        log "${CYAN}=== User Services ===${NC}"
        check_user_service "pipewire.service"
        check_user_service "wireplumber.service"
        check_user_service "swayidle.service"
    fi
    
    echo
    
    # Check essential tools
    log "${CYAN}=== Essential Tools ===${NC}"
    
    local tools=("grim" "slurp" "wl-copy" "kanshi" "brightnessctl" "playerctl" "autotiling" "swaync")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool is available"
        else
            log_error "$tool is missing"
        fi
    done
    
    echo
    
    # Check wayland environment
    log "${CYAN}=== Wayland Environment ===${NC}"
    
    if [ -n "${WAYLAND_DISPLAY:-}" ]; then
        log_success "Running in Wayland session (WAYLAND_DISPLAY=$WAYLAND_DISPLAY)"
    else
        log_info "Not currently in Wayland session"
    fi
    
    if [ -n "${SWAYSOCK:-}" ]; then
        log_success "Sway socket available (SWAYSOCK=$SWAYSOCK)"
    else
        log_info "Sway socket not available (not in sway session)"
    fi
    
    echo
    
    # Check configuration files
    log "${CYAN}=== Configuration Files ===${NC}"
    
    local configs=(
        "$HOME/.config/sway/config"
        "$HOME/.config/waybar/config.jsonc"
        "$HOME/.config/rofi/config.rasi"
        "$HOME/.zshrc"
    )
    
    for config in "${configs[@]}"; do
        if [ -f "$config" ]; then
            log_success "Config exists: $config"
        else
            log_warning "Config missing: $config"
        fi
    done
    
    echo
    
    # Check fonts
    log "${CYAN}=== Fonts ===${NC}"
    
    if fc-list | grep -i "nerd\|recursive\|noto" >/dev/null; then
        log_success "Nerd/Noto fonts detected"
    else
        log_warning "Recommended fonts may be missing"
    fi
    
    echo
    
    # Final recommendations
    log "${CYAN}=== Recommendations ===${NC}"
    
    if ! command_exists sway; then
        log_error "Install sway package"
    fi
    
    if [ ! -f "$HOME/.config/sway/config" ]; then
        log_warning "Stow your dotfiles: stow -t ~ common && stow -t ~ linux"
    fi
    
    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        log_info "Log out and select Sway session to test wayland environment"
    fi
    
    log_success "Validation complete!"
}

main "$@"