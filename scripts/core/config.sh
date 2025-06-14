#!/usr/bin/env bash

# Core configuration
WIDTH=80
HEIGHT=40
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/devenv"
NVIM_DIR="$HOME/nvim"
PACKAGE_MANAGER="paru"
PACKAGES_JSON="$DOTFILES_DIR/packages.json"
SUDO_PASS=""
TMP_OUTPUT="/tmp/package-install-output.log"
NVIM_URL="https://github.com/xsoder/nvim.git"
SCRIPT_NAME="$DOTFILES_DIR/script"

# Common functions
get_sudo_password() {
    local pass
    while true; do
        pass=$(dialog --insecure --passwordbox "Enter sudo password" "$HEIGHT" "$WIDTH" 2>&1 >/dev/tty)
        if [[ -z "${pass// /}" ]]; then
            dialog --title "Authentication Failed" --msgbox "Password required" "$HEIGHT" "$WIDTH"
            clear
            exit 1
        fi
        if echo "$pass" | sudo -S -v &>/dev/null; then
            export SUDO_PASS="$pass"
            break
        else
            dialog --title "Authentication Failed" --msgbox "Incorrect password. Try again." "$HEIGHT" "$WIDTH"
        fi
    done
}

run_with_sudo() {
    if [[ -z "${SUDO_PASS:-}" ]]; then
        get_sudo_password
    fi
    printf '%s\n' "$SUDO_PASS" | sudo -S "$@"
}

force_link() {
    local source="$1"
    local target="$2"
    
    # Remove existing target (file, directory, or symlink)
    if [[ -e "$target" || -L "$target" ]]; then
        rm -rf "$target"
    fi
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create the symlink
    ln -sf "$source" "$target"
}

# Package tracking functions
add_to_json() {
    local pkg="$1"
    
    if [[ ! -f "$PACKAGES_JSON" ]]; then
        mkdir -p "$(dirname "$PACKAGES_JSON")"
        echo '{"packages":[]}' > "$PACKAGES_JSON"
    fi
    
    if jq -e --arg pkg "$pkg" '.packages[] | select(. == $pkg)' "$PACKAGES_JSON" >/dev/null 2>&1; then
        return 0
    fi
    
    local updated
    updated=$(jq --arg pkg "$pkg" '.packages += [$pkg] | .packages |= sort | .packages |= unique' "$PACKAGES_JSON")
    echo "$updated" > "$PACKAGES_JSON"
}

remove_from_json() {
    local pkg="$1"
    
    if [[ ! -f "$PACKAGES_JSON" ]]; then
        return 0
    fi
    
    local updated
    updated=$(jq --arg pkg "$pkg" '.packages |= map(select(. != $pkg))' "$PACKAGES_JSON")
    echo "$updated" > "$PACKAGES_JSON"
}

# Export functions and variables
export -f get_sudo_password run_with_sudo force_link add_to_json remove_from_json
export WIDTH HEIGHT CONFIG_DIR DOTFILES_DIR NVIM_DIR PACKAGE_MANAGER PACKAGES_JSON SUDO_PASS TMP_OUTPUT NVIM_URL SCRIPT_NAME 