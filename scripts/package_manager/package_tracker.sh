#!/usr/bin/env bash

source "$(dirname "$(dirname "$0")")/core/config.sh"

setup_package_tracking() {
    local wrapper_script="$HOME/.local/bin/package-tracker"
    mkdir -p "$(dirname "$wrapper_script")"

    cat >"$wrapper_script" <<'EOF'
#!/usr/bin/env bash

PACKAGES_JSON="$HOME/devenv/packages.json"
ORIGINAL_CMD="$1"
shift

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

if [[ "$ORIGINAL_CMD" == "pacman" || "$ORIGINAL_CMD" == "paru" || "$ORIGINAL_CMD" == "yay" ]]; then
    if [[ "$1" == "-S" || "$1" == "-Sy" || "$1" == "-Su" || "$1" == "-Syu" ]]; then
        if "$ORIGINAL_CMD" "$@"; then
            for arg in "$@"; do
                if [[ ! "$arg" =~ ^- ]] && [[ "$arg" != "-S" ]] && [[ "$arg" != "-Sy" ]] && [[ "$arg" != "-Su" ]] && [[ "$arg" != "-Syu" ]] && [[ "$arg" != "--needed" ]] && [[ "$arg" != "--noconfirm" ]]; then
                    add_to_json "$arg"
                fi
            done
            exit 0
        else
            exit $?
        fi
    elif [[ "$1" == "-R"* ]]; then
        if "$ORIGINAL_CMD" "$@"; then
            for arg in "$@"; do
                if [[ ! "$arg" =~ ^- ]] && [[ "$arg" != "-R"* ]]; then
                    remove_from_json "$arg"
                fi
            done
            exit 0
        else
            exit $?
        fi
    fi
fi

"$ORIGINAL_CMD" "$@"
EOF

    chmod +x "$wrapper_script"

    local sudo_wrapper="$HOME/.local/bin/sudo-tracker"
    cat >"$sudo_wrapper" <<'EOF'
#!/usr/bin/env bash

PACKAGES_JSON="$HOME/devenv/packages.json"

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

if [[ "$1" == "pacman" || "$1" == "paru" || "$1" == "yay" ]]; then
    if [[ "$2" == "-S" || "$2" == "-Sy" || "$2" == "-Su" || "$2" == "-Syu" ]]; then
        if /usr/bin/sudo "$@"; then
            for arg in "${@:3}"; do
                if [[ ! "$arg" =~ ^- ]] && [[ "$arg" != "-S" ]] && [[ "$arg" != "-Sy" ]] && [[ "$arg" != "-Su" ]] && [[ "$arg" != "-Syu" ]] && [[ "$arg" != "--needed" ]] && [[ "$arg" != "--noconfirm" ]]; then
                    add_to_json "$arg"
                fi
            done
            exit 0
        else
            exit $?
        fi
    elif [[ "$2" == "-R"* ]]; then
        if /usr/bin/sudo "$@"; then
            for arg in "${@:3}"; do
                if [[ ! "$arg" =~ ^- ]] && [[ "$arg" != "-R"* ]]; then
                    remove_from_json "$arg"
                fi
            done
            exit 0
        else
            exit $?
        fi
    fi
fi

/usr/bin/sudo "$@"
EOF

    chmod +x "$sudo_wrapper"

    # Setup shell aliases with better handling
    for config in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [[ -f "$config" ]]; then
            # Remove existing aliases
            sed -i '/# Package tracking aliases/,/# End package tracking aliases/d' "$config"
            # Add new aliases
            cat >>"$config" <<EOF

# Package tracking aliases
alias pacman='$wrapper_script pacman'
alias paru='$wrapper_script paru'
alias yay='$wrapper_script yay'
alias sudo='$sudo_wrapper'
# End package tracking aliases
EOF
        fi
    done

    # Setup fish shell if present
    local fish_config="$HOME/.config/fish/config.fish"
    if [[ -f "$fish_config" ]] || command -v fish &>/dev/null; then
        mkdir -p "$HOME/.config/fish"
        if [[ ! -f "$fish_config" ]]; then
            touch "$fish_config"
        fi
        sed -i '/# Package tracking aliases/,/# End package tracking aliases/d' "$fish_config" 2>/dev/null || true
        cat >>"$fish_config" <<EOF

# Package tracking aliases
alias pacman='$wrapper_script pacman'
alias paru='$wrapper_script paru'
alias yay='$wrapper_script yay'
alias sudo='$sudo_wrapper'
# End package tracking aliases
EOF
        
        mkdir -p "$HOME/.config/fish/functions"
        for cmd in pacman paru yay sudo; do
            if [[ "$cmd" == "sudo" ]]; then
                cat >"$HOME/.config/fish/functions/${cmd}.fish" <<EOF
function $cmd --wraps='$cmd' --description 'sudo with package tracking'
    $sudo_wrapper \$argv
end
EOF
            else
                cat >"$HOME/.config/fish/functions/${cmd}.fish" <<EOF
function $cmd --wraps='$cmd' --description 'Package manager with tracking'
    $wrapper_script $cmd \$argv
end
EOF
            fi
        done
    fi

    # Add ~/.local/bin to PATH if not already present
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        for config in "$HOME/.bashrc" "$HOME/.zshrc"; do
            if [[ -f "$config" ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$config"
            fi
        done
    fi

    if [[ -f "$fish_config" ]] || command -v fish &>/dev/null; then
        if ! grep -q "fish_add_path.*\.local/bin" "$fish_config" 2>/dev/null; then
            echo 'fish_add_path ~/.local/bin' >>"$fish_config"
        fi
    fi

    dialog --title "Package Tracking Setup" --msgbox "Package tracking has been set up successfully!\n\nNow when you install or remove packages using pacman, paru, or yay, they will be automatically tracked in your packages.json file.\n\nPlease restart your shell or source your shell config to apply the changes." "$HEIGHT" "$WIDTH"
}

clean_packages() {
    run_with_sudo true

    # Handle packages not in packages.json
    if [[ ! -f "$PACKAGES_JSON" ]]; then
        dialog --title "Error" --msgbox "packages.json not found at $PACKAGES_JSON" "$HEIGHT" "$WIDTH"
        return 1
    fi

    # Get list of packages from packages.json
    local tracked_packages=()
    mapfile -t tracked_packages < <(jq -r '.packages[]' "$PACKAGES_JSON")

    # Get list of explicitly installed packages
    local installed_packages=()
    mapfile -t installed_packages < <(pacman -Qqe)

    # Find packages that are installed but not in packages.json
    local packages_to_remove=()
    for pkg in "${installed_packages[@]}"; do
        # Skip Intel drivers
        if [[ "$pkg" =~ ^(intel|lib32-intel|xf86-video-intel|mesa|lib32-mesa|vulkan-intel|lib32-vulkan-intel) ]]; then
            continue
        fi
        if [[ ! " ${tracked_packages[*]} " =~ " ${pkg} " ]]; then
            packages_to_remove+=("$pkg")
        fi
    done

    if [[ ${#packages_to_remove[@]} -gt 0 ]]; then
        # Show packages to be removed and ask for confirmation
        local pkg_list
        pkg_list=$(printf '%s\n' "${packages_to_remove[@]}")
        dialog --title "Packages Not in packages.json" --yesno "The following packages are installed but not in packages.json:\n\n$pkg_list\n\nDo you want to remove them?\n\nNote: Intel drivers have been excluded from this list." "$HEIGHT" "$WIDTH"
        
        if [[ $? -eq 0 ]]; then
            # Remove packages
            (
                total=${#packages_to_remove[@]}
                current=0

                echo "XXX"
                echo "Preparing to remove packages..."
                echo "XXX"
                echo "0"

                for pkg in "${packages_to_remove[@]}"; do
                    current=$((current + 1))
                    progress=$((current * 100 / total))

                    echo "XXX"
                    echo "Removing $pkg ($current/$total)..."
                    echo "XXX"
                    echo "$progress"

                    if command -v "$PACKAGE_MANAGER" &>/dev/null; then
                        printf '%s\n' "$SUDO_PASS" | "$PACKAGE_MANAGER" -Rns --noconfirm "$pkg" &>>"$TMP_OUTPUT" || true
                    else
                        printf '%s\n' "$SUDO_PASS" | sudo -S pacman -Rns --noconfirm "$pkg" &>>"$TMP_OUTPUT" || true
                    fi
                done

                echo "100"
            ) | dialog --title "Removing Packages" --gauge "Please wait..." "$HEIGHT" "$WIDTH" 0

            dialog --title "Packages Removed" --msgbox "Packages not in packages.json have been removed.\n\nCheck $TMP_OUTPUT for detailed logs." "$HEIGHT" "$WIDTH"
        fi
    else
        dialog --title "No Extra Packages" --msgbox "No packages found that are not in packages.json." "$HEIGHT" "$WIDTH"
    fi
}

clean_orphaned_packages() {
    run_with_sudo true

    # Handle orphaned packages
    local orphaned
    orphaned=$(pacman -Qdtq 2>/dev/null || true)
    if [[ -n "$orphaned" ]]; then
        dialog --title "Remove Orphans" --yesno "Found orphaned packages:\n\n$orphaned\n\nRemove them?" "$HEIGHT" "$WIDTH"
        if [[ $? -eq 0 ]]; then
            echo "$orphaned" | xargs -r printf '%s\n' "$SUDO_PASS" | sudo -S pacman -Rns --noconfirm
            dialog --title "Orphans Removed" --msgbox "Orphaned packages removed." "$HEIGHT" "$WIDTH"
        fi
    else
        dialog --title "No Orphans" --msgbox "No orphaned packages found." "$HEIGHT" "$WIDTH"
    fi

    # Clean package cache
    dialog --title "Clean Package Cache" --yesno "Do you want to clear the package cache?\n(This runs 'pacman -Scc')" "$HEIGHT" "$WIDTH"
    if [[ $? -eq 0 ]]; then
        printf '%s\n' "$SUDO_PASS" | sudo -S pacman -Scc --noconfirm
        dialog --title "Cache Cleaned" --msgbox "Package cache cleaned." "$HEIGHT" "$WIDTH"
    fi
}

# Export functions
export -f setup_package_tracking clean_packages clean_orphaned_packages 