#!/usr/b trap 'cleanup' INT TERM
    
    # Check if we're in Emacs
    if [[ -n "${INSIDE_EMACS:-}" ]]; then
        IN_EMACS=true
        # Clear the buffer at start
        emacsclient -e "(with-current-buffer (get-buffer-create \"$EMACS_BUFFER\")
                        (erase-buffer))" >/dev/null
    fi
    
    # Check if dialog is installed
    if ! command -v dialog &>/dev/null; then
        emacs_output "Installing dialog..."
        if command -v pacman &>/dev/null; then
            sudo pacman -S --needed --noconfirm dialog
        elif command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y dialog
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y dialog
        else
            emacs_output "Error: Cannot install dialog. Please install it manually."
            exit 1
        fi
    fi
    
    # Check if jq is installed
    if ! command -v jq &>/dev/null; then
        emacs_output "Installing jq..."
        if command -v pacman &>/dev/null; then
            sudo pacman -S --needed --noconfirm jq
        elif command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y jq
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y jq
        else
            emacs_output "Error: Cannot install jq. Please install it manually."
            exit 1
        fi
    fi
    
    # Skip fzf check in Emacs as we'll use Emacs for selection
    if [[ "$IN_EMACS" == "false" ]] && ! command -v fzf &>/dev/null; then
        if dialog --title "FZF Not Found" --yesno "FZF is not installed. FZF provides enhanced search functionality.\n\nWould you like to install it now?" "$HEIGHT" "$WIDTH"; then
            emacs_output "Installing fzf..."
            if command -v pacman &>/dev/null; then
                sudo pacman -S --needed --noconfirm fzf
            elif command -v apt &>/dev/null; then
                sudo apt update && sudo apt install -y fzf
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y fzf
            else
                dialog --title "Installation Failed" --msgbox "Could not install fzf automatically. Please install it manually for enhanced search features." "$HEIGHT" "$WIDTH"
            fi
        fi
    fi
    
    if [[ "$IN_EMACS" == "true" ]]; then
        emacs_dialog_box
    else
        dialog_box
    fi
    clear
    exit 0
}

cleanup() {
    clear
    emacs_output "Script interrupted or terminated"
    exit 1
}

# Emacs-based menu system
emacs_dialog_box() {
    while true; do
        choice=$(emacsclient -e "(let ((choice (completing-read \"Dotfiles Manager: \"
                          '(\"Full Setup (Recommended)\"
                            \"Install All Packages\"
                            \"Add Package\"
                            \"Remove Package\"
                            \"View Packages\"
                            \"Edit Packages (Manual)\"
                            \"Backup Packages\"
                            \"Restore Packages\"
                            \"Link Dotfiles\"
                            \"Link Hidden Config\"
                            \"Install AUR Helper\"
                            \"Edit This Script\"
                            \"Exit\") nil t)))
                        (if (string= choice \"Exit\") \"\" choice))" | tr -d '"')

        case "$choice" in
        "Full Setup (Recommended)") full_setup ;;
        "Install All Packages") install_packages ;;
        "Add Package") add_package ;;
        "Remove Package") remove_packages ;;
        "View Packages") view_packages ;;
        "Edit Packages (Manual)") edit_packages ;;
        "Backup Packages") backup_packages ;;
        "Restore Packages") restore_packages ;;
        "Link Dotfiles") link_dotfiles_silent ;;
        "Link Hidden Config") link_hidden_config ;;
        "Install AUR Helper") install_aur_helper ;;
        "Edit This Script") edit_dev ;;
        "") break ;;
        *) emacs_output "Invalid option" ;;
        esac
    done
}

# Modified for Emacs
get_sudo_password() {
    if [[ "$IN_EMACS" == "true" ]]; then
        SUDO_PASS=$(emacsclient -e "(read-passwd \"Enter sudo password: \")" | tr -d '"')
        if [[ -z "${SUDO_PASS// /}" ]]; then
            emacs_output "Password required"
            exit 1
        fi
        if ! echo "$SUDO_PASS" | sudo -S -v &>/dev/null; then
            emacs_output "Incorrect password"
            exit 1
        fi
    else
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
    fi
}

# Modified package selection for Emacs
select_package_with_fzf() {
    local action="$1"
    local pkg_array=()
    mapfile -t pkg_array < <(jq -r '.packages[]' "$PACKAGES_JSON" | sort -u)

    if [[ ${#pkg_array[@]} -eq 0 ]]; then
        emacs_output "No packages found in packages.json."
        return 1
    fi

    if [[ "$IN_EMACS" == "true" ]]; then
        # Use Emacs completion
        local selected_pkg
        selected_pkg=$(emacsclient -e "(completing-read \"$action Package: \" '($(printf "\"%s\" " "${pkg_array[@]}")) nil t)" | tr -d '"')
        
        if [[ -z "$selected_pkg" ]]; then
            return 1
        fi
        echo "$selected_pkg"
        return 0
    else
        # Original fzf/dialog implementation
        local selected_pkg=""
        
        if command -v fzf &>/dev/null; then
            selected_pkg=$(printf '%s\n' "${pkg_array[@]}" | fzf \
                --prompt="$action Package: " \
                --height=40% \
                --layout=reverse \
                --border \
                --info=inline \
                --header="Type to search, Enter to select, Esc to cancel" \
                --preview="pacman -Si {} 2>/dev/null || echo 'Package info not available'" \
                --preview-window="right:50%:wrap" 2>/dev/tty)
            
            if [[ -z "$selected_pkg" ]]; then
                return 1
            fi
        else
            local dialog_args=()
            for pkg in "${pkg_array[@]}"; do
                dialog_args+=("$pkg" "$pkg")
            done

            selected_pkg=$(dialog --title "$action Package" \
                --cancel-label "Cancel" \
                --menu "Select package to $action" "$HEIGHT" "$WIDTH" 0 \
                "${dialog_args[@]}" \
                2>&1 >/dev/tty)
            
            if [[ $? -ne 0 ]]; then
                return 1
            fi
        fi
        
        echo "$selected_pkg"
        return 0
    fi
}

# Modified add package for Emacs
add_package_with_search() {
    local pkg_name=""
    
    if [[ "$IN_EMACS" == "true" ]]; then
        # Emacs-based package search and add
        local search_term
        search_term=$(emacsclient -e "(read-string \"Enter package name to search/add: \")" | tr -d '"')
        [[ -z "$search_term" ]] && return

        emacs_output "Searching for packages containing '$search_term'..."
        
        # Get search results
        local available_packages=()
        mapfile -t available_packages < <(search_available_packages "$search_term")
        
        if [[ ${#available_packages[@]} -eq 0 ]]; then
            emacs_output "No packages found matching '$search_term'."
            return
        fi
        
        # Let user select from results
        pkg_name=$(emacsclient -e "(completing-read \"Select package to add: \" '($(printf "\"%s\" " "${available_packages[@]}"))" | tr -d '"')
        [[ -z "$pkg_name" ]] && return
    else
        # Original implementation
        if command -v fzf &>/dev/null; then
            # Interactive search mode
            dialog --title "Package Search" --msgbox "You'll now enter an interactive search mode.\n\nType to search for packages, use arrow keys to navigate,\nand press Enter to select a package to add." "$HEIGHT" "$WIDTH"
            
            # Get search term first
            local search_term
            search_term=$(dialog --title "Search Packages" --inputbox "Enter search term (or partial package name):" "$HEIGHT" "$WIDTH" 2>&1 >/dev/tty)
            [[ $? -ne 0 || -z "$search_term" ]] && return
            
            # Create a temporary file with search results
            local temp_file
            temp_file=$(mktemp)
            
            # Show searching dialog
            dialog --title "Searching" --infobox "Searching for packages containing '$search_term'..." "$HEIGHT" "$WIDTH"
            
            # Perform search and save to temp file
            search_available_packages "$search_term" > "$temp_file"
            
            if [[ ! -s "$temp_file" ]]; then
                dialog --title "No Results" --msgbox "No packages found matching '$search_term'." "$HEIGHT" "$WIDTH"
                rm -f "$temp_file"
                return
            fi
            
            # Use fzf to select from search results
            pkg_name=$(cat "$temp_file" | fzf \
                --prompt="Add Package: " \
                --height=40% \
                --layout=reverse \
                --border \
                --info=inline \
                --header="Packages matching '$search_term' - Type to filter further, Enter to select" \
                --preview="pacman -Si {} 2>/dev/null || $PACKAGE_MANAGER -Si {} 2>/dev/null || echo 'Package: {}'" \
                --preview-window="right:50%:wrap" 2>/dev/tty)
            
            rm -f "$temp_file"
            
            # Check if user cancelled
            if [[ -z "$pkg_name" ]]; then
                return
            fi
        else
            # Fallback to simple input
            pkg_name=$(dialog --title "Add Package" --inputbox "Enter package name:" "$HEIGHT" "$WIDTH" 2>&1 >/dev/tty)
            [[ $? -ne 0 || -z "$pkg_name" ]] && return
        fi
    fi

    # Validate package exists
    if ! validate_package_exists "$pkg_name"; then
        return
    fi

    # Check if package is already in the list
    if jq -e --arg pkg "$pkg_name" '.packages[] | select(. == $pkg)' "$PACKAGES_JSON" >/dev/null 2>&1; then
        emacs_output "'$pkg_name' is already in your packages list."
        return
    fi

    # Add package to JSON
    local updated
    updated=$(jq --arg pkg "$pkg_name" '.packages += [$pkg] | .packages |= sort | .packages |= unique' "$PACKAGES_JSON")
    echo "$updated" > "$PACKAGES_JSON"

    emacs_output "'$pkg_name' added to packages.json"
}

# Modified edit_dev for Emacs
edit_dev() {
    if [[ "$IN_EMACS" == "true" ]]; then
        emacsclient -e "(find-file \"$SCRIPT_NAME\")" >/dev/null
    else
        ${EDITOR:-nvim} "$SCRIPT_NAME"
    fi
}

# Modified view_packages for Emacs
view_packages() {
    local pkg_array=()
    mapfile -t pkg_array < <(jq -r '.packages[]' "$PACKAGES_JSON" | sort -u)

    if [[ ${#pkg_array[@]} -eq 0 ]]; then
        emacs_output "No packages found in packages.json."
        return
    fi

    local package_list="Installed Packages:\n"
    for pkg in "${pkg_array[@]}"; do
        local status
        if pacman -Qi "$pkg" &>/dev/null; then
            status="✓"
        else
            status="✗"
        fi
        package_list+="$status $pkg\n"
    done

    if [[ "$IN_EMACS" == "true" ]]; then
        emacsclient -e "(with-current-buffer (get-buffer-create \"$EMACS_BUFFER\")
                        (insert \"$package_list\n\")
                        (display-buffer (current-buffer)))" >/dev/null
    else
        echo -e "$package_list"
    fi
}

main "$@"
