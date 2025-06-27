#!/usr/bin/env bash

source "$(dirname "$(dirname "$0")")/core/config.sh"

link_dotfiles() {
    if [[ ! -d "$DOTFILES_DIR/dotfiles" ]]; then
        dialog --title "Error" --msgbox "Dotfiles directory not found at $DOTFILES_DIR/dotfiles" "$HEIGHT" "$WIDTH"
        return
    fi

    mkdir -p "$CONFIG_DIR"
    local output
    output=$(mktemp)
    for item in "$DOTFILES_DIR/dotfiles"/.* "$DOTFILES_DIR/dotfiles"/*; do
        [[ -e "$item" && ! "$(basename "$item")" =~ ^\.{1,2}$ ]] || continue
        local filename
        filename=$(basename "$item")
        local target="$CONFIG_DIR/$filename"
        force_link "$item" "$target"
        printf "├── %s -> %s\n" "$target" "$item" >>"$output"
    done
    dialog --title "Linked Dotfiles" --textbox "$output" "$HEIGHT" "$WIDTH"
    rm -f "$output"
}

link_hidden_config() {
    local configs=(
        "$DOTFILES_DIR/starship.toml:$CONFIG_DIR/starship.toml"
        "$DOTFILES_DIR/.tmux.conf:$HOME/.tmux.conf"
        "$DOTFILES_DIR/.bashrc:$HOME/.bashrc"
        "$DOTFILES_DIR/.zshrc:$HOME/.zshrc"
        "$DOTFILES_DIR/.gitconfig:$HOME/.gitconfig"
    )

    local linked_files=()
    local missing_files=()

    for config in "${configs[@]}"; do
        local source="${config%:*}"
        local target="${config#*:}"

        if [[ -f "$source" ]]; then
            force_link "$source" "$target"
            linked_files+=("✓ $(basename "$source") -> $target")
        else
            missing_files+=("✗ $(basename "$source") (not found at $source)")
        fi
    done

    # Show results
    local result_msg="Hidden Config Files Linking Results:\n\n"

    if [[ ${#linked_files[@]} -gt 0 ]]; then
        result_msg+="Successfully linked:\n"
        for file in "${linked_files[@]}"; do
            result_msg+="$file\n"
        done
    fi

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        result_msg+="\nMissing files (skipped):\n"
        for file in "${missing_files[@]}"; do
            result_msg+="$file\n"
        done
    fi

    dialog --title "Hidden Config Linking" --msgbox "$result_msg" "$HEIGHT" "$WIDTH"
}

create_dotfiles_directory() {
    mkdir -p "$DOTFILES_DIR/dotfiles"

    # Create sample hidden config files if they don't exist
    local sample_tmux="$DOTFILES_DIR/.tmux.conf"
    local sample_bashrc="$DOTFILES_DIR/.bashrc"

    if [[ ! -f "$sample_tmux" ]]; then
        cat > "$sample_tmux" <<'EOF'
# Sample tmux configuration
# Prefix key
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Split panes
bind | split-window -h
bind - split-window -v

# Reload config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Enable mouse mode
set -g mouse on

# Status bar
set -g status-bg black
set -g status-fg white
EOF
    fi

    if [[ ! -f "$sample_bashrc" ]]; then
        cat > "$sample_bashrc" <<'EOF'
# Sample bashrc configuration
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command
shopt -s checkwinsize

# Colored prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF
    fi

    dialog --title "Directory Created" --msgbox "Created dotfiles directory at $DOTFILES_DIR/dotfiles\n\nAlso created sample files:\n• .tmux.conf\n• .bashrc\n\nYou can now customize these files and use option 7 to symlink them." "$HEIGHT" "$WIDTH"
}

show_file_locations() {
    local info_msg="Current Configuration:\n\n"
    info_msg+="Dotfiles Directory: $DOTFILES_DIR\n"
    info_msg+="Config Directory: $CONFIG_DIR\n"
    info_msg+="Nvim Directory: $NVIM_DIR\n"
    info_msg+="Packages JSON: $PACKAGES_JSON\n\n"

    info_msg+="Expected Hidden Config Files:\n"
    info_msg+="• $DOTFILES_DIR/.tmux.conf -> $HOME/.tmux.conf\n"
    info_msg+="• $DOTFILES_DIR/.bashrc -> $HOME/.bashrc\n"
    info_msg+="• $DOTFILES_DIR/.zshrc -> $HOME/.zshrc\n"
    info_msg+="• $DOTFILES_DIR/.gitconfig -> $HOME/.gitconfig\n\n"

    info_msg+="File Status:\n"
    local files=(
        "$DOTFILES_DIR/.tmux.conf"
        "$DOTFILES_DIR/.bashrc"
        "$DOTFILES_DIR/.zshrc"
        "$DOTFILES_DIR/.gitconfig"
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            info_msg+="✓ $(basename "$file") exists\n"
        else
            info_msg+="✗ $(basename "$file") missing\n"
        fi
    done

    dialog --title "File Locations & Status" --msgbox "$info_msg" "$HEIGHT" "$WIDTH"
}

# Export functions
export -f link_dotfiles link_hidden_config create_dotfiles_directory show_file_locations
