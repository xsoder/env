#!/usr/bin/env bash

source "$(dirname "$(dirname "$0")")/core/config.sh"

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        dialog --title "Installing Oh My Zsh" --infobox "Installing Oh My Zsh..." "$HEIGHT" "$WIDTH"
        
        # Install zsh if not already installed
        if ! command -v zsh &>/dev/null; then
            run_with_sudo pacman -S --needed --noconfirm zsh
        fi
        
        # Install Oh My Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Install powerlevel10k theme
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        
        # Update .zshrc with powerlevel10k theme
        sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
        
        # Add useful plugins
        local plugins=(
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            "zsh-completions"
        )
        
        for plugin in "${plugins[@]}"; do
            if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]]; then
                git clone "https://github.com/zsh-users/$plugin.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
            fi
        done
        
        # Update plugins in .zshrc
        sed -i 's/plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' "$HOME/.zshrc"
        
        dialog --title "Oh My Zsh Installed" --msgbox "Oh My Zsh has been installed successfully!\n\nPlease restart your terminal to see the changes." "$HEIGHT" "$WIDTH"
    else
        dialog --title "Oh My Zsh" --msgbox "Oh My Zsh is already installed." "$HEIGHT" "$WIDTH"
    fi
}

change_default_shell() {
    local current_shell
    current_shell=$(basename "$SHELL")
    
    if [[ "$current_shell" != "zsh" ]]; then
        dialog --title "Change Default Shell" --yesno "Do you want to change your default shell to Zsh?" "$HEIGHT" "$WIDTH"
        if [[ $? -eq 0 ]]; then
            run_with_sudo chsh -s /bin/zsh "$USER"
            dialog --title "Shell Changed" --msgbox "Your default shell has been changed to Zsh.\n\nPlease log out and log back in for the changes to take effect." "$HEIGHT" "$WIDTH"
        fi
    else
        dialog --title "Default Shell" --msgbox "Zsh is already your default shell." "$HEIGHT" "$WIDTH"
    fi
}

setup_shell() {
    install_oh_my_zsh
    change_default_shell
}

# Export functions
export -f install_oh_my_zsh change_default_shell setup_shell 