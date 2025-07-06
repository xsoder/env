# ------------------------------
# Minimal Custom .bashrc
# ------------------------------
# Core settings
set -o vi
export EDITOR=vim

# PATH setup
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$HOME/.config/emacs/bin:$HOME/.nimble/bin:$HOME/packages/nim-2.2.4/bin:$HOME/.npm-global/bin:$HOME/packages/zig:$PATH"

# Aliases
alias gitter="~/scripts/gitter.sh"
alias raylib="source ./.env/raylib.sh"
alias timer="bash ~/scripts/timer.sh"
alias harpoon="bash ~/scripts/tmux_harpoon.sh"
# Auto start X server on VT1
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    exec startx
fi
# ~/.bashrc

. "$HOME/.cargo/env"
. "/home/csode/.deno/env"
# Color variables
RED='\[\e[31m\]'
WHITE='\[\e[97m\]'
RESET='\[\e[0m\]'

update_prompt() {
    local exit_code=$?
    local cwd="\W"

    if [ $exit_code -ne 0 ]; then
        PS1="${RED}[\u${WHITE}@\h ${cwd}] ${RED}\\$ ${RESET}"
    else
        PS1="${RED}[\u${WHITE}@\h ${cwd}] \\$ ${RESET}"
    fi
}

PROMPT_COMMAND=update_prompt

gpwd() {
  cat ~/Downloads/token.md | xclip -selection clipboard
}
alias gpasd="gpwd"
alias cme="~/devenv/scripts/cme"
sowon() {
  cd /home/csode/packages/bin && ./sowon "$@"
}

