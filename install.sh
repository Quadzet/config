#!/bin/bash

# Config directory installation script
# Usage: ./install.sh <directory-name|ALL>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

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

get_user_choice() {
    local config_name="$1"
    local destination="$2"

    echo ""
    print_warning "Configuration '$config_name' already exists at: $destination"
    echo "What would you like to do?"
    echo "  [s] Skip (leave existing config)"
    echo "  [o] Overwrite (replace with new config)"
    echo "  [b] Backup (rename existing to ${config_name}.backup.<timestamp>)"
    echo -n "Choice [s/o/b]: "

    read -r choice
    case "$choice" in
    s | S)
        return 0 # Skip
        ;;
    o | O)
        return 1 # Overwrite
        ;;
    b | B)
        return 2 # Backup
        ;;
    *)
        print_error "Invalid choice. Skipping by default."
        return 0
        ;;
    esac
}

install_config() {
    local config_name="$1"
    local source_dir="$REPO_DIR/$config_name"
    local dest_dir="$CONFIG_DIR/$config_name"

    if [[ ! -d "$source_dir" ]]; then
        print_error "Source directory '$source_dir' does not exist. Skipping."
        return 1
    fi

    # Create ~/.config if it doesn't exist
    if [[ ! -d "$CONFIG_DIR" ]]; then
        print_info "Creating $CONFIG_DIR directory..."
        mkdir -p "$CONFIG_DIR"
    fi

    # Check if destination already exists
    if [[ -e "$dest_dir" ]]; then
	set +e
        get_user_choice "$config_name" "$dest_dir"
        local choice=$?
	set -e

        case $choice in
        0) # Skip
            print_info "Skipping $config_name"
            return 0
            ;;
        1) # Overwrite
            print_info "Removing existing $config_name..."
            rm -rf "$dest_dir"
            ;;
        2) # Backup
            local timestamp=$(date +%Y%m%d_%H%M%S)
            local backup_name="${dest_dir}.backup.${timestamp}"
            print_info "Backing up existing config to: ${backup_name}"
            mv "$dest_dir" "$backup_name"
            print_success "Backup created"
            ;;
        esac
    fi

    # Copy the config directory
    print_info "Installing $config_name to $dest_dir..."
    cp -r "$source_dir" "$dest_dir"
    print_success "$config_name installed successfully"

    return 0
}

get_all_configs() {
    local configs=()

    # Find all directories in repo root, excluding hidden dirs
    for dir in "$REPO_DIR"/*/; do
        if [[ -d "$dir" ]]; then
            local basename=$(basename "$dir")
            if [[ ! "$basename" =~ ^\. ]]; then
                configs+=("$basename")
            fi
        fi
    done

    echo "${configs[@]}"
}

main() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: $0 <directory-name|ALL>"
        print_info "Examples:"
        print_info "  $0 nvim          # Install only nvim config"
        print_info "  $0 ALL           # Install all configs"
        exit 1
    fi

    local target="$1"

    print_info "Repository directory: $REPO_DIR"
    print_info "Config directory: $CONFIG_DIR"
    echo ""

    if [[ "$target" == "ALL" ]]; then
        print_info "Installing ALL configurations..."
        local configs=($(get_all_configs))

        if [[ ${#configs[@]} -eq 0 ]]; then
            print_warning "No configuration directories found in $REPO_DIR"
            exit 0
        fi

        print_info "Found ${#configs[@]} configuration(s): ${configs[*]}"
        echo ""

        local success_count=0
        local error_count=0

        for config in "${configs[@]}"; do
            if install_config "$config"; then
                success_count=$((success_count + 1))
            else
                error_count=$((error_count + 1))
            fi
            echo ""
        done

        echo "================================================"
        print_success "Installation complete!"
        print_info "Successfully installed: $success_count"
        if [[ $error_count -gt 0 ]]; then
            print_warning "Errors/Skipped: $error_count"
        fi
        echo "================================================"
    else
        install_config "$target"
    fi
}

main "$@"
