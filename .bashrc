# ------------------------------
# Minimal Custom .bashrc
# ------------------------------
# Core settings
set -o vi
export EDITOR=nvim

# PATH setup
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$HOME/.config/emacs/bin:$HOME/.nimble/bin:$HOME/packages/nim-2.2.4/bin:$HOME/.npm-global/bin:$HOME/packages/zig:$PATH"

# Aliases
alias cpp="~/scripts/cpp.sh"
alias ccg="~/scripts/cpp.sh"
alias gitter="~/scripts/gitter.sh"
alias packages="~/scripts/package.sh"
alias dev="bash ~/devenv/script"
alias DEV="cd ~/devenv"
alias luamake="/home/csode/packages/lua-language-server/3rd/luamake/luamake"
alias fedora="distrobox enter neovim-isolated"
alias emacs='emacsclient -c -a "emacs"'

# Auto start X server on VT1
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    exec startx
fi
# ~/.bashrc

eval "$(starship init bash)"
. "$HOME/.cargo/env"
