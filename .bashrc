# ------------------------------
# Minimal Custom .bashrc
# ------------------------------
# Core settings
set -o vi
export EDITOR=emacsclient

# PATH setup
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$HOME/.config/emacs/bin:$HOME/.nimble/bin:$HOME/packages/nim-2.2.4/bin:$HOME/.npm-global/bin:$HOME/packages/zig:$PATH"

# Gruvbox colors (escaped for prompt)
C_RESET='\[\e[0m\]'
C_YELLOW='\[\e[38;2;250;189;47m\]'
C_RED='\[\e[38;2;251;73;52m\]'
C_GREEN='\[\e[38;2;184;187;38m\]'
C_AQUA='\[\e[38;2;142;192;124m\]'

# Save last exit code before rendering prompt
PROMPT_COMMAND='LAST_EXIT=$?'

# Git branch function (fixed)
git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        echo "(${branch})"
    fi
}

# Prompt icon
get_prompt_icon() {
    case $LAST_EXIT in
        0) echo "→" ;;
        127) echo "⨯" ;;
        *) echo " " ;;
    esac
}

# Prompt
PS1="\n${C_YELLOW}\w"
PS1+="${C_RED}\$(git_branch)"
PS1+=" ${C_GREEN}\$( [[ \$LAST_EXIT -eq 0 ]] && get_prompt_icon )"
PS1+="${C_RED}\$( [[ \$LAST_EXIT -eq 127 ]] && get_prompt_icon )"
PS1+="${C_AQUA}\$( [[ \$LAST_EXIT -ne 0 && \$LAST_EXIT -ne 127 ]] && get_prompt_icon )"
PS1+="${C_RESET} "

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

# Show system info on terminal start
fastfetch
