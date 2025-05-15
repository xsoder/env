starship init fish | source

set -x GTK_THEME rose-pine-gtk
set -x PATH $HOME/.emacs.d/bin $PATH
set -x PATH $HOME/.config/emacs/bin $PATH
set -x DOOMDIR $HOME/.config/doom
set -x PATH $HOME/.nimble/bin $PATH
set -x PATH /home/csode/packages/nim-2.2.4/bin $PATH
set -x GCM_CREDENTIAL_STORE cache
set -x GIT_TERMINAL_PROMPT 1
set -x GIT_ASKPASS git-credential-manager-core
set -x PATH $HOME/.npm-global/bin $PATH
set -x PATH $HOME/packages/zig $PATH

fish_vi_key_bindings

# Aliases
alias cpp '~/scripts/cpp.sh'
alias gitter '~/scripts/gitter.sh'
alias ccg '~/scripts/cpp.sh'
alias packages '~/scripts/package.sh'
alias vim 'nvim'
alias rm 'rm -rf'
alias dev 'bash ~/devenv/script'
alias DEV 'cd ~/devenv'
alias luamake '/home/csode/packages/lua-language-server/3rd/luamake/luamake'

