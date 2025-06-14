#!/usr/bin/env bash

source "$(dirname "$(dirname "$0")")/core/config.sh"

install_doom_emacs() {
    if [[ ! -d "$HOME/.emacs.d" ]]; then
        dialog --title "Installing Doom Emacs" --infobox "Installing Doom Emacs..." "$HEIGHT" "$WIDTH"
        
        # Install emacs if not already installed
        if ! command -v emacs &>/dev/null; then
            run_with_sudo pacman -S --needed --noconfirm emacs
        fi
        
        # Clone Doom Emacs
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
        
        # Install Doom
        ~/.emacs.d/bin/doom install --force
        
        # Create a basic init.el
        cat > "$HOME/.doom.d/init.el" <<'EOF'
;; -*- lexical-binding: t; -*-
(doom! :input
       :completion
       company
       (ivy +fuzzy +prescient +icons)
       :ui
       doom
       doom-dashboard
       doom-quit
       hl-todo
       modeline
       ophints
       (popup +defaults)
       treemacs
       vc-gutter
       vi-tilde-fringe
       workspaces
       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       lispy
       multiple-cursors
       rotate-text
       snippets
       word-wrap
       :emacs
       dired
       electric
       (undo +tree)
       vc
       :term
       eshell
       vterm
       :checkers
       syntax
       (spell +flyspell)
       grammar
       :tools
       (eval +overlay)
       lookup
       (lsp +peek)
       (magit +forge)
       :lang
       (cc +lsp)
       data
       emacs-lisp
       (go +lsp)
       (json +lsp)
       (javascript +lsp)
       (latex +lsp +cdlatex)
       markdown
       (org +dragndrop +pretty +roam2)
       (python +lsp +pyright)
       (rust +lsp)
       (sh +lsp)
       (web +lsp)
       (yaml +lsp)
       :config
       (default +bindings +smartparens))
EOF
        
        # Create a basic config.el
        cat > "$HOME/.doom.d/config.el" <<'EOF'
;; -*- lexical-binding: t; -*-
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")
(setq doom-font (font-spec :family "JetBrains Mono" :size 14))
EOF
        
        # Install Doom
        ~/.emacs.d/bin/doom sync
        
        dialog --title "Doom Emacs Installed" --msgbox "Doom Emacs has been installed successfully!\n\nPlease restart Emacs to see the changes." "$HEIGHT" "$WIDTH"
    else
        dialog --title "Doom Emacs" --msgbox "Doom Emacs is already installed." "$HEIGHT" "$WIDTH"
    fi
}

setup_editors() {
    install_doom_emacs
}

# Export functions
export -f install_doom_emacs setup_editors 