#!/usr/bin/env bash

source "$(dirname "$(dirname "$0")")/core/config.sh"

install_aur_helper() {
    local choice
    choice=$(dialog --title "AUR Helper Selection" \
        --cancel-label "Skip" \
        --menu "Choose AUR helper to install" "$HEIGHT" "$WIDTH" 0 \
        1 "paru" \
        2 "yay" \
        2>&1 >/dev/tty)

    local status=$?
    [[ $status -eq 1 ]] && return 0

    local helper
    case "$choice" in
    1) helper="paru" ;;
    2) helper="yay" ;;
    *) return 0 ;;
    esac

    if command -v "$helper" &>/dev/null; then
        export PACKAGE_MANAGER="$helper"
        return 0
    fi

    dialog --title "Installing $helper" --infobox "Installing $helper..." "$HEIGHT" "$WIDTH"

    run_with_sudo pacman -S --needed --noconfirm base-devel git

    local tmp_dir="/tmp/$helper-install"
    rm -rf "$tmp_dir"
    git clone "https://aur.archlinux.org/$helper.git" "$tmp_dir"
    cd "$tmp_dir"
    makepkg -si --noconfirm
    cd - >/dev/null
    rm -rf "$tmp_dir"

    export PACKAGE_MANAGER="$helper"
}

install_package() {
    local pkg="$1"
    local source="$2"  # "pacman" or "aur"

    if [[ "$source" == "aur" ]]; then
        if ! command -v "$PACKAGE_MANAGER" &>/dev/null; then
            dialog --title "Error" --msgbox "AUR helper not installed. Please install one first." "$HEIGHT" "$WIDTH"
            return 1
        fi
        printf '%s\n' "$SUDO_PASS" | "$PACKAGE_MANAGER" -S --needed --noconfirm "$pkg" &>>"$TMP_OUTPUT"
    else
        printf '%s\n' "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm "$pkg" &>>"$TMP_OUTPUT"
    fi

    if [[ $? -eq 0 ]]; then
        add_to_json "$pkg"
        return 0
    fi
    return 1
}

remove_package() {
    local pkg="$1"
    local source="$2"  # "pacman" or "aur"

    if [[ "$source" == "aur" ]]; then
        if ! command -v "$PACKAGE_MANAGER" &>/dev/null; then
            dialog --title "Error" --msgbox "AUR helper not installed. Please install one first." "$HEIGHT" "$WIDTH"
            return 1
        fi
        printf '%s\n' "$SUDO_PASS" | "$PACKAGE_MANAGER" -Rns --noconfirm "$pkg" &>>"$TMP_OUTPUT"
    else
        printf '%s\n' "$SUDO_PASS" | sudo -S pacman -Rns --noconfirm "$pkg" &>>"$TMP_OUTPUT"
    fi

    if [[ $? -eq 0 ]]; then
        remove_from_json "$pkg"
        return 0
    fi
    return 1
}

install_packages() {
    local pkg_array=()
    mapfile -t pkg_array < <(jq -r '.packages[]' "$PACKAGES_JSON" | sort -u)

    [[ ${#pkg_array[@]} -eq 0 ]] && dialog --title "Install Packages" --msgbox "No packages found in packages.json." "$HEIGHT" "$WIDTH" && return

    run_with_sudo true

    local new_installed=()
    for pkg in "${pkg_array[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            new_installed+=("$pkg")
        fi
    done

    if [[ ${#new_installed[@]} -eq 0 ]]; then
        dialog --title "Install Packages" --msgbox "All packages already installed." "$HEIGHT" "$WIDTH"
        return
    fi

    (
        total=${#new_installed[@]}
        current=0

        echo "XXX"
        echo "Preparing package installation..."
        echo "XXX"
        echo "0"

        for pkg in "${new_installed[@]}"; do
            current=$((current + 1))
            progress=$((current * 100 / total))

            echo "XXX"
            echo "Installing $pkg ($current/$total)..."
            echo "XXX"
            echo "$progress"

            # Try pacman first, then AUR
            if ! install_package "$pkg" "pacman"; then
                install_package "$pkg" "aur"
            fi
        done

        echo "100"
    ) | dialog --title "Installing Packages" --gauge "Please wait..." "$HEIGHT" "$WIDTH" 0

    dialog --title "Installation Complete" --msgbox "Package installation process finished.\n\nCheck $TMP_OUTPUT for detailed logs." "$HEIGHT" "$WIDTH"
}

clean_packages() {
    run_with_sudo true

    # Clean orphaned packages
    local orphaned
    orphaned=$(pacman -Qdtq 2>/dev/null || true)
    if [[ -n "$orphaned" ]]; then
        dialog --title "Remove Orphans" --yesno "Found orphaned packages:\n\n$orphaned\n\nRemove them?" "$HEIGHT" "$WIDTH"
        if [[ $? -eq 0 ]]; then
            echo "$orphaned" | while read -r pkg; do
                remove_package "$pkg" "pacman"
            done
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

    dialog --title "Clean Complete" --msgbox "All cleanup steps completed." "$HEIGHT" "$WIDTH"
}

# Export functions
export -f install_aur_helper install_package remove_package install_packages clean_packages 