#!/bin/bash

# Script to re-sign all Neovim plugin libraries for macOS 15+
# This fixes "Code Signature Invalid" crashes when loading native libraries
# 
# Usage: ~/.config/nvim/scripts/resign-libs.sh
# Run this after: :TSUpdate, :TSInstall, or plugin updates that compile native code

set -e

NVIM_DIR="$HOME/.local/share/nvim"
LOG_FILE="$HOME/.local/share/nvim/resign-libs.log"
SCRIPT_NAME="resign-libs.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is only needed on macOS"
    exit 1
fi

# Check if nvim directory exists
if [ ! -d "$NVIM_DIR" ]; then
    print_error "Neovim directory not found: $NVIM_DIR"
    exit 1
fi

print_info "Starting library re-signing for macOS 15+ compatibility..."
print_info "Logging to: $LOG_FILE"
echo ""

# Initialize log file
echo "=== Neovim Library Re-signing Log ===" > "$LOG_FILE"
echo "Date: $(date)" >> "$LOG_FILE"
echo "macOS Version: $(sw_vers -productVersion)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

total=0
success=0
failed=0
skipped=0

# Find all .so and .dylib files
print_info "Scanning for native libraries..."
files=$(find "$NVIM_DIR" -type f \( -name "*.so" -o -name "*.dylib" \) 2>/dev/null)
total_files=$(echo "$files" | grep -c . || echo "0")

if [ "$total_files" -eq 0 ]; then
    print_warning "No native libraries found to re-sign"
    exit 0
fi

print_info "Found $total_files native libraries"
echo ""

# Process each file
while IFS= read -r file; do
    total=$((total + 1))
    
    # Get relative path for cleaner output
    rel_path="${file#$NVIM_DIR/}"
    
    # Check if file already has valid signature
    if codesign -v "$file" 2>/dev/null; then
        print_success "[$total/$total_files] Already valid: $rel_path"
        skipped=$((skipped + 1))
        echo "[$total/$total_files] SKIPPED (already valid): $file" >> "$LOG_FILE"
        continue
    fi
    
    echo -n "[$total/$total_files] Re-signing: $rel_path ... "
    
    # Remove existing signature
    if ! codesign --remove-signature "$file" 2>>"$LOG_FILE"; then
        print_error "Failed to remove signature"
        failed=$((failed + 1))
        echo "[$total/$total_files] FAILED (remove signature): $file" >> "$LOG_FILE"
        continue
    fi
    
    # Re-sign with adhoc signature
    if ! codesign --force --sign - "$file" 2>>"$LOG_FILE"; then
        print_error "Failed to sign"
        failed=$((failed + 1))
        echo "[$total/$total_files] FAILED (signing): $file" >> "$LOG_FILE"
        continue
    fi
    
    # Clear extended attributes
    if ! xattr -c "$file" 2>>"$LOG_FILE"; then
        print_warning "Failed to clear xattrs (non-critical)"
        echo "[$total/$total_files] WARNING (xattr): $file" >> "$LOG_FILE"
    fi
    
    # Verify the new signature
    if codesign -v "$file" 2>>"$LOG_FILE"; then
        print_success "Done"
        success=$((success + 1))
        echo "[$total/$total_files] SUCCESS: $file" >> "$LOG_FILE"
    else
        print_error "Signature verification failed"
        failed=$((failed + 1))
        echo "[$total/$total_files] FAILED (verification): $file" >> "$LOG_FILE"
    fi
done <<< "$files"

# Print summary
echo ""
echo "======================================"
print_info "Re-signing Summary"
echo "======================================"
echo "Total libraries found:  $total_files"
echo "Successfully re-signed: ${GREEN}$success${NC}"
echo "Already valid (skipped): ${YELLOW}$skipped${NC}"
echo "Failed:                 ${RED}$failed${NC}"
echo "======================================"
echo ""
print_info "Log file: $LOG_FILE"
echo ""

# Write summary to log
{
    echo ""
    echo "=== Summary ==="
    echo "Total libraries found:  $total_files"
    echo "Successfully re-signed: $success"
    echo "Already valid (skipped): $skipped"
    echo "Failed:                 $failed"
    echo "Completed at: $(date)"
} >> "$LOG_FILE"

if [ $failed -gt 0 ]; then
    print_warning "Some libraries failed to re-sign. Check log: $LOG_FILE"
    exit 1
fi

print_success "All libraries have been re-signed successfully!"
print_info "You should now be able to use Neovim without crashes"
echo ""
print_info "Note: Run this script again after:"
print_info "  - Running :TSUpdate or :TSInstall"
print_info "  - Updating plugins that compile native code"
print_info "  - Installing new plugins with native dependencies"

exit 0
