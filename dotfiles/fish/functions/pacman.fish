function pacman --wraps='pacman' --description 'Package manager with tracking'
    /home/csode/.local/bin/package-tracker pacman $argv
end
