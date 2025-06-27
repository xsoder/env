# ------------------------------
# Minimal Custom .bashrc
# ------------------------------
# Core settings
set -o vi
export EDITOR=vim

# PATH setup
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$HOME/.config/emacs/bin:$HOME/.nimble/bin:$HOME/packages/nim-2.2.4/bin:$HOME/.npm-global/bin:$HOME/packages/zig:$PATH"

# Aliases
alias cpp="~/scripts/cpp.sh"
alias ccg="~/scripts/cpp.sh"
alias gitter="~/scripts/gitter.sh"
alias packages="~/scripts/package.sh"
alias dev="bash ~/devenv/script"
alias timer="bash ~/scripts/timer.sh"
alias DEV="cd ~/devenv"
alias luamake="/home/csode/packages/lua-language-server/3rd/luamake/luamake"

# Auto start X server on VT1
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    exec startx
fi
# ~/.bashrc

# eval "$(starship init bash)"
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
