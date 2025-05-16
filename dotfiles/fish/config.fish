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
set -x FZF_DEFAULT_OPTS "--height=15 \
  --layout=reverse \
  --border \
  --margin=1,2 \
  --prompt='❯ ' \
  --pointer='➤' \
  --marker='✓' \
  --color=fg:#e0def4,bg:-1,hl:#9ccfd8,border:#908caa \
  --color=fg+:#c4a7e7,bg+:-1,hl+:#c4a7e7 \
  --color=info:#c4a7e7,prompt:#ebbcba,pointer:#f6c177 \
  --color=marker:#31748f,spinner:#f6c177,header:#9ccfd8"
fish_vi_key_bindings
function fish_greeting; end

# Aliases
alias cpp '~/scripts/cpp.sh'
alias gitter '~/scripts/gitter.sh'
alias ccg '~/scripts/cpp.sh'
alias packages '~/scripts/package.sh'
alias rm 'rm -rf'
alias dev 'bash ~/devenv/script'
alias hypr_reload 'hyprctl reload'
alias shell_reload 'source ~/.config/fish/config.fish'
alias tmux_reload 'tmux source-file ~/.tmux.conf'
alias DEV 'cd ~/devenv'
alias luamake '/home/csode/packages/lua-language-server/3rd/luamake/luamake'
if test -z "$DISPLAY"; and test "$XDG_VTNR" = "1"
    exec startx
end
