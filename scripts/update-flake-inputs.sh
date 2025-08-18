#!/usr/bin/env bash
# update-flake-inputs.sh
# Script to safely update flake inputs with security validation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create backup of current flake.lock
backup_flake_lock() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="flake.lock.backup-$timestamp"
    
    if [ -f "flake.lock" ]; then
        cp "flake.lock" "$backup_file"
        log_info "Created backup: $backup_file"
        echo "$backup_file" # Return backup filename
    fi
}

# Function to restore flake.lock from backup
restore_flake_lock() {
    local backup_file="$1"
    
    if [ -f "$backup_file" ]; then
        cp "$backup_file" "flake.lock"
        log_success "Restored flake.lock from $backup_file"
    else
        log_error "Backup file not found: $backup_file"
        return 1
    fi
}

# Function to validate flake after update
validate_flake() {
    log_info "Validating flake configuration..."
    
    # Check flake syntax
    if ! nix flake check --no-build 2>/dev/null; then
        log_error "Flake check failed - syntax or evaluation errors"
        return 1
    fi
    
    # Try to build both systems to ensure they work
    log_info "Testing HP configuration build..."
    if ! nix build ".#nixosConfigurations.hp-dv9500-pavilion-nixos.config.system.build.toplevel" --dry-run 2>/dev/null; then
        log_error "HP configuration build test failed"
        return 1
    fi
    
    log_info "Testing MSI configuration build..."
    if ! nix build ".#nixosConfigurations.msi-ge75-raider-nixos.config.system.build.toplevel" --dry-run 2>/dev/null; then
        log_error "MSI configuration build test failed"
        return 1
    fi
    
    log_success "Flake validation passed"
    return 0
}

# Function to show what will be updated
show_update_preview() {
    log_info "Checking for available updates..."
    
    # Show current versions
    echo -e "\n${BLUE}Current versions:${NC}"
    nix flake metadata --json | jq -r '.locks.nodes | to_entries | map(select(.key != "root")) | .[] | "\(.key): \(.value.locked.rev // .value.locked.lastModified)"'
    
    echo -e "\n${BLUE}Available updates:${NC}"
    nix flake update --dry-run 2>&1 | grep -E "(updating|warning)" || echo "No updates available"
}

# Main update function
perform_update() {
    local update_specific="$1"
    local backup_file
    
    backup_file=$(backup_flake_lock)
    
    log_info "Starting flake update process..."
    
    if [ "$update_specific" = "all" ]; then
        log_info "Updating all inputs..."
        nix flake update
    else
        log_info "Updating specific input: $update_specific"
        nix flake lock --update-input "$update_specific"
    fi
    
    # Validate the update
    if validate_flake; then
        log_success "Update completed successfully!"
        
        # Show what changed
        echo -e "\n${BLUE}Changes made:${NC}"
        if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
            diff "$backup_file" "flake.lock" || true
        fi
        
        # Clean up backup after 24 hours of successful operation
        echo "# Cleanup backup after 24 hours" | at now + 1 day 2>/dev/null || true
        echo "rm -f \"$REPO_ROOT/$backup_file\"" | at now + 1 day 2>/dev/null || true
        
    else
        log_error "Update validation failed, restoring previous version..."
        if [ -n "$backup_file" ]; then
            restore_flake_lock "$backup_file"
        fi
        return 1
    fi
}

# Function to pin specific versions for security
pin_security_versions() {
    log_info "Pinning known-good versions for security..."
    
    # Pin to latest stable NixOS release
    nix flake lock --update-input nixpkgs --override-input nixpkgs "github:NixOS/nixpkgs/nixos-25.05"
    
    # Pin home-manager to matching release
    nix flake lock --update-input home-manager --override-input home-manager "github:nix-community/home-manager/release-25.05"
    
    log_success "Security pinning completed"
}

# Usage information
show_help() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
    preview     Show what updates are available (default)
    update      Update all inputs
    update-input INPUT  Update specific input only
    pin-security Pin to known-good security versions
    validate    Validate current flake configuration
    
Options:
    -h, --help  Show this help message

Examples:
    $0 preview                  # Show available updates
    $0 update                   # Update all inputs
    $0 update-input nixpkgs     # Update only nixpkgs
    $0 pin-security             # Pin to secure versions
    $0 validate                 # Check current config

Security Notes:
- Always run 'preview' before 'update' to see what will change
- Updates are automatically validated and rolled back on failure
- Backups are created automatically and cleaned up after 24 hours
- Use 'pin-security' when you need stable, known-good versions
EOF
}

# Main script logic
main() {
    local command="${1:-preview}"
    
    case "$command" in
        preview)
            show_update_preview
            ;;
        update)
            perform_update "all"
            ;;
        update-input)
            if [ $# -lt 2 ]; then
                log_error "update-input requires an input name"
                show_help
                exit 1
            fi
            perform_update "$2"
            ;;
        pin-security)
            pin_security_versions
            validate_flake
            ;;
        validate)
            validate_flake
            ;;
        -h|--help|help)
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
    log_error "flake.nix not found. Please run this script from the repository root."
    exit 1
fi

# Check required tools
for tool in nix jq; do
    if ! command -v "$tool" &> /dev/null; then
        log_error "Required tool not found: $tool"
        exit 1
    fi
done

main "$@"