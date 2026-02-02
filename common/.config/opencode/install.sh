#!/usr/bin/env bash
#
# OpenCode Setup Script
# Installs and builds CLI tools (GloomStalker, Todo Enforcer, Risk Assessor)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_DIR="$SCRIPT_DIR"

echo "🔨 OpenCode Setup"
echo "================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

success "npm found: $(npm --version)"
echo

# Install and build each CLI
install_cli() {
    local name=$1
    local path=$2
    
    info "Installing $name..."
    
    if [ ! -d "$path" ]; then
        error "Directory not found: $path"
        return 1
    fi
    
    cd "$path"
    
    # Install dependencies
    if [ -f "package.json" ]; then
        npm install --silent 2>&1 | grep -v "npm warn" || true
        success "Dependencies installed for $name"
    else
        error "No package.json found in $path"
        return 1
    fi
    
    # Build TypeScript if tsconfig exists
    if [ -f "tsconfig.json" ]; then
        if [ -d "node_modules/typescript" ]; then
            npx -y typescript@latest tsc 2>/dev/null || npx tsc 2>/dev/null || ./node_modules/typescript/bin/tsc
            success "TypeScript compiled for $name"
        else
            error "TypeScript not installed for $name"
            return 1
        fi
    fi
    
    # Make CLI executable
    if [ -f "cli.js" ]; then
        chmod +x cli.js
        success "Made cli.js executable for $name"
    fi
    
    echo
}

# Install GloomStalker
install_cli "GloomStalker" "$OPENCODE_DIR/hooks/gloomstalker"

# Install Todo Enforcer
install_cli "Todo Enforcer" "$OPENCODE_DIR/hooks/todo-enforcer"

# Install Risk Assessor
install_cli "Risk Assessor" "$OPENCODE_DIR/hooks/risk-assessor"

# Summary
echo "================="
success "OpenCode setup complete!"
echo
echo "CLI Tools installed:"
echo "  • GloomStalker (Smart context loading)"
echo "  • Todo Enforcer (Multi-step task detection)"
echo "  • Risk Assessor (Destructive operation safety)"
echo
echo "All CLIs are ready to use."
