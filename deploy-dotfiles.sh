#!/bin/bash
# /etc/nixos/deploy-dotfiles.sh
# Script to deploy updated dotfiles configuration to NixOS systems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Function to check if we're on the correct system
check_system() {
    if [[ ! -f /etc/nixos/flake.nix ]]; then
        print_error "This doesn't appear to be a NixOS system with flakes configuration"
        exit 1
    fi
    
    if [[ ! -d /etc/nixos/modules/shared ]]; then
        print_error "Shared modules directory not found. Make sure you've copied the configuration files."
        exit 1
    fi
}

# Function to backup current configuration
backup_config() {
    local backup_dir="/etc/nixos/backups/$(date +%Y%m%d_%H%M%S)"
    print_status "Creating backup at $backup_dir"
    
    sudo mkdir -p "$backup_dir"
    sudo cp -r /etc/nixos/modules "$backup_dir/" 2>/dev/null || true
    sudo cp -r /etc/nixos/home "$backup_dir/" 2>/dev/null || true
    sudo cp /etc/nixos/flake.nix "$backup_dir/" 2>/dev/null || true
    
    print_success "Backup created at $backup_dir"
}

# Function to update flake inputs
update_flake() {
    print_status "Updating flake inputs..."
    sudo nix flake update /etc/nixos
    print_success "Flake inputs updated"
}

# Function to check configuration syntax
check_config() {
    local hostname=$(hostname)
    print_status "Checking NixOS configuration syntax for $hostname..."
    
    if sudo nixos-rebuild dry-build --flake "/etc/nixos#$hostname"; then
        print_success "Configuration syntax is valid"
        return 0
    else
        print_error "Configuration syntax check failed"
        return 1
    fi
}

# Function to apply configuration
apply_config() {
    local mode=$1
    local hostname=$(hostname)
    
    case $mode in
        "test")
            print_status "Testing configuration (temporary, will revert on reboot)..."
            sudo nixos-rebuild test --flake "/etc/nixos#$hostname"
            ;;
        "switch")
            print_status "Applying configuration (permanent)..."
            sudo nixos-rebuild switch --flake "/etc/nixos#$hostname"
            ;;
        "boot")
            print_status "Setting configuration for next boot..."
            sudo nixos-rebuild boot --flake "/etc/nixos#$hostname"
            ;;
        *)
            print_error "Invalid mode: $mode"
            return 1
            ;;
    esac
}

# Function to show system info
show_system_info() {
    local hostname=$(hostname)
    print_status "System Information:"
    echo "  Hostname: $hostname"
    echo "  NixOS Version: $(nixos-version)"
    echo "  Kernel: $(uname -r)"
    echo "  Architecture: $(uname -m)"
    
    # Check if this is HP or MSI
    if [[ "$hostname" == *"hp-dv9500"* ]]; then
        echo "  System: HP dv9500 Pavilion (2007)"
        echo "  CPU: AMD Turion 64 X2"
        echo "  GPU: NVIDIA GeForce 7150M"
    elif [[ "$hostname" == *"msi-ge75"* ]]; then
        echo "  System: MSI GE75 Raider 9SF (2018)"
        echo "  CPU: Intel Core i7-9750H"
        echo "  GPU: NVIDIA RTX 2070"
    fi
}

# Function to check dotfiles integration
check_dotfiles() {
    print_status "Checking dotfiles integration..."
    
    # Check if shared dotfiles module exists
    if [[ -f /etc/nixos/modules/shared/dotfiles.nix ]]; then
        print_success "Shared dotfiles module found"
    else
        print_error "Shared dotfiles module not found"
        return 1
    fi
    
    # Check if Oh My Posh theme exists
    if [[ -f /etc/nixos/modules/shared/jandedobbeleer.omp.json ]]; then
        print_success "Oh My Posh theme found"
    else
        print_warning "Oh My Posh theme not found"
    fi
    
    # Check user configurations
    local hostname=$(hostname)
    local user_config=""
    
    if [[ "$hostname" == *"hp-dv9500"* ]]; then
        user_config="/etc/nixos/home/hp-dv9500-pavilion-nixos/joseph.nix"
    elif [[ "$hostname" == *"msi-ge75"* ]]; then
        user_config="/etc/nixos/home/msi-ge75-raider-nixos/joseph.nix"
    fi
    
    if [[ -f "$user_config" ]]; then
        print_success "User configuration found: $user_config"
    else
        print_error "User configuration not found: $user_config"
        return 1
    fi
}

# Main function
main() {
    echo "=================================================="
    echo "     NixOS Dotfiles Deployment Script"
    echo "=================================================="
    echo ""
    
    show_system_info
    echo ""
    
    # Check system requirements
    check_system
    check_dotfiles
    
    echo ""
    print_status "Available actions:"
    echo "  1) Check configuration syntax only"
    echo "  2) Test configuration (temporary)"
    echo "  3) Apply configuration (permanent)"
    echo "  4) Set configuration for next boot"
    echo "  5) Update flake inputs first"
    echo "  6) Full deployment (backup + update + apply)"
    echo "  7) Exit"
    echo ""
    
    read -p "Choose an action (1-7): " choice
    
    case $choice in
        1)
            check_config
            ;;
        2)
            if check_config; then
                apply_config "test"
                print_success "Configuration tested successfully!"
                print_warning "Changes are temporary and will revert on reboot"
            fi
            ;;
        3)
            if check_config; then
                apply_config "switch"
                print_success "Configuration applied successfully!"
            fi
            ;;
        4)
            if check_config; then
                apply_config "boot"
                print_success "Configuration will be applied on next boot"
            fi
            ;;
        5)
            update_flake
            if check_config; then
                print_success "Flake updated and configuration is valid"
            fi
            ;;
        6)
            backup_config
            update_flake
            if check_config; then
                apply_config "switch"
                print_success "Full deployment completed successfully!"
                print_status "Your dotfiles are now active. You may want to:"
                echo "  - Log out and log back in to see all changes"
                echo "  - Run 'source ~/.bashrc' to reload bash configuration"
                echo "  - Check that Oh My Posh prompt is working"
            fi
            ;;
        7)
            print_status "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
