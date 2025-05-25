starship init fish | source
set -x PATH $HOME/.emacs.d/bin $PATH
set -x PATH $HOME/.config/emacs/bin $PATH
set -x PATH $HOME/.nimble/bin $PATH
set -x PATH /home/csode/packages/nim-2.2.4/bin $PATH
set -x GCM_CREDENTIAL_STORE cache
set -x GIT_TERMINAL_PROMPT 1
set -x GIT_ASKPASS git-credential-manager-core
set -x PATH $HOME/.npm-global/bin $PATH
set -x PATH $HOME/packages/zig $PATH
fish_vi_key_bindings
function fish_greeting; end

# Aliases
alias cpp '~/scripts/cpp.sh'
alias gitter '~/scripts/gitter.sh'
alias ccg '~/scripts/cpp.sh'
alias packages '~/scripts/package.sh'
alias rm 'rm -rf'
alias vim 'nvim'
alias ls 'ls -l --color=auto'
alias dev 'bash ~/devenv/script'
alias hypr_reload 'hyprctl reload'
alias shell_reload 'source ~/.config/fish/config.fish'
alias tmux_reload 'tmux source-file ~/.tmux.conf'
alias DEV 'cd ~/devenv'
alias luamake '/home/csode/packages/lua-language-server/3rd/luamake/luamake'
if status is-interactive
    and test -z "$DISPLAY"
    and test (tty) = "/dev/tty1"
    exec startx
end

fish_add_path ~/.local/bin

# Package tracking aliases
alias pacman='/home/csode/.local/bin/package-tracker pacman'
alias paru='/home/csode/.local/bin/package-tracker paru'
alias yay='/home/csode/.local/bin/package-tracker yay'
alias sudo='/home/csode/.local/bin/sudo-tracker'
# End package tracking aliases
