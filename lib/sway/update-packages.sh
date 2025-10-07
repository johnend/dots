#!/bin/bash

# =============================================================================
# Package List Updater
# =============================================================================
# This script helps maintain the sway package list by comparing it with
# currently installed packages and suggesting updates.
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/packages-repository.txt"
TEMP_DIR="/tmp/sway-package-update-$$"

log() {
    echo -e "$1"
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

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to extract packages from current list
get_current_packages() {
    grep -v '^#' "$PACKAGES_FILE" | grep -v '^$' | sort > "$TEMP_DIR/current_packages.txt"
}

# Function to get installed packages (excluding system packages)
get_installed_packages() {
    pacman -Qqe | grep -v -E '^(base|linux|systemd|glibc|gcc|binutils|util-linux)' | \
    grep -v -E '^(endeavouros-|eos-|welcome$|reflector|downgrade|rebuild-detector)' | \
    grep -v -E '^(broadcom-wl|b43-fwcutter|intel-ucode|alsa-firmware|sof-firmware)' | \
    grep -v -E '^(cryptsetup|device-mapper|lvm2|mdadm|dmidecode|hwdetect|hwinfo|inxi)' | \
    grep -v -E '^(btrfs-progs|e2fsprogs|f2fs-tools|jfsutils|nilfs-utils|xfsprogs)' | \
    grep -v -E '^(firewalld|iptables-nft|modemmanager|usb_modeswitch|haveged|rtkit)' | \
    sort > "$TEMP_DIR/installed_packages.txt"
}

# Function to get AUR packages
get_aur_packages() {
    yay -Qm | cut -d' ' -f1 | sort > "$TEMP_DIR/aur_packages.txt"
}

# Function to analyze differences
analyze_differences() {
    log_info "Analyzing package differences..."
    
    # Packages in list but not installed
    comm -23 "$TEMP_DIR/current_packages.txt" "$TEMP_DIR/installed_packages.txt" > "$TEMP_DIR/missing_packages.txt"
    
    # Packages installed but not in list
    comm -13 "$TEMP_DIR/current_packages.txt" "$TEMP_DIR/installed_packages.txt" > "$TEMP_DIR/extra_packages.txt"
    
    # Show results
    echo
    log "${CYAN}=== PACKAGE ANALYSIS RESULTS ===${NC}"
    echo
    
    if [ -s "$TEMP_DIR/missing_packages.txt" ]; then
        log_warning "Packages in list but NOT installed ($(wc -l < "$TEMP_DIR/missing_packages.txt")):"
        while read -r pkg; do
            echo "  - $pkg"
        done < "$TEMP_DIR/missing_packages.txt"
        echo
    fi
    
    if [ -s "$TEMP_DIR/extra_packages.txt" ]; then
        log_info "Packages installed but NOT in list ($(wc -l < "$TEMP_DIR/extra_packages.txt")):"
        while read -r pkg; do
            # Check if it's an AUR package
            if grep -q "^$pkg$" "$TEMP_DIR/aur_packages.txt" 2>/dev/null; then
                echo "  - $pkg ${YELLOW}(AUR)${NC}"
            else
                echo "  - $pkg"
            fi
        done < "$TEMP_DIR/extra_packages.txt"
        echo
    fi
    
    # Suggest packages to add
    if [ -s "$TEMP_DIR/extra_packages.txt" ]; then
        log_info "Suggested packages to consider adding:"
        while read -r pkg; do
            # Get package description
            desc=$(pacman -Qi "$pkg" 2>/dev/null | grep "Description" | cut -d':' -f2- | sed 's/^ *//' || echo "No description")
            echo "  - ${GREEN}$pkg${NC}: $desc"
        done < "$TEMP_DIR/extra_packages.txt"
        echo
    fi
}

# Function to check for package updates
check_package_updates() {
    log_info "Checking for package updates..."
    
    local outdated=()
    while read -r pkg; do
        if [[ -n "$pkg" ]]; then
            # Check if package exists in repos
            if ! yay -Si "$pkg" &>/dev/null; then
                outdated+=("$pkg")
            fi
        fi
    done < "$TEMP_DIR/current_packages.txt"
    
    if [ ${#outdated[@]} -gt 0 ]; then
        log_warning "Packages that may no longer exist:"
        printf '  - %s\n' "${outdated[@]}"
        echo
    else
        log_success "All packages in list are available"
    fi
}

# Function to generate updated package list
generate_updated_list() {
    log_info "Generating updated package list suggestion..."
    
    # Combine current list with new packages
    {
        cat "$PACKAGES_FILE" | grep '^#'  # Keep comments
        echo
        cat "$TEMP_DIR/installed_packages.txt"
    } > "$TEMP_DIR/suggested_packages.txt"
    
    log_success "Suggested package list saved to: $TEMP_DIR/suggested_packages.txt"
    log_info "Review the file and manually update $PACKAGES_FILE if desired"
}

# Function to backup current list
backup_current_list() {
    local backup_file="$PACKAGES_FILE.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$PACKAGES_FILE" "$backup_file"
    log_success "Current package list backed up to: $backup_file"
}

# Main function
main() {
    log "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    log "${PURPLE}║                  Package List Updater                       ║${NC}"
    log "${PURPLE}║               Sway Desktop Environment                      ║${NC}"
    log "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    if [ ! -f "$PACKAGES_FILE" ]; then
        log_warning "Package file not found: $PACKAGES_FILE"
        exit 1
    fi
    
    # Get package lists
    log_info "Extracting current package list..."
    get_current_packages
    
    log_info "Getting installed packages..."
    get_installed_packages
    
    log_info "Getting AUR packages..."
    get_aur_packages
    
    # Analyze differences
    analyze_differences
    
    # Check for updates
    check_package_updates
    
    # Ask if user wants to generate updated list
    echo
    read -p "Generate updated package list suggestion? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_current_list
        generate_updated_list
        
        echo
        log_info "To view the suggested changes:"
        log "  ${GREEN}diff $PACKAGES_FILE $TEMP_DIR/suggested_packages.txt${NC}"
        echo
        log_info "To apply the changes:"
        log "  ${GREEN}cp $TEMP_DIR/suggested_packages.txt $PACKAGES_FILE${NC}"
    fi
    
    log_success "Package analysis complete!"
}

# Show help
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Package List Updater"
    echo "Usage: $0"
    echo
    echo "This script analyzes your current sway package list and suggests updates based on"
    echo "currently installed packages. It helps keep the package list current and complete."
    echo
    echo "The script will:"
    echo "  - Compare package list with installed packages"
    echo "  - Identify missing or extra packages"
    echo "  - Check for outdated package names"
    echo "  - Generate updated package list suggestions"
    exit 0
fi

main "$@"