#!/usr/bin/fish

# Tokyo Night Theme + FiraCode Font Installer (Fish Shell)
echo "Setting up Tokyo Night theme with FiraCode..."

# 1. Install essentials
echo "Installing required packages..."
sudo pacman -S lxappearance qt5ct fira-code-font ttf-fira-code --needed  # Arch
# For Debian/Ubuntu:
# sudo apt install lxappearance qt5ct fonts-firacode --no-install-recommends

# 2. Clone/update Tokyo Night theme
if not test -d ~/.themes/TokyoNight
    echo "Downloading Tokyo Night GTK theme..."
    git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git ~/.themes/TokyoNight
else
    echo "Updating Tokyo Night theme..."
    git -C ~/.themes/TokyoNight pull
end

# 3. Configure LXAppearance (non-interactive)
mkdir -p ~/.config/lxappearance
echo "[GTK]
sGtk/ColorScheme=
sGtk/IconThemeName=Adwaita
sGtk/MonospaceFontName=Fira Code 10
sGtk/FontName=Fira Code 10
sGtk/ThemeName=TokyoNight
sNet/ThemeName=TokyoNight" > ~/.config/lxappearance/lxappearance.conf

# 4. Force GTK3 settings with FiraCode
mkdir -p ~/.config/gtk-3.0
echo "[Settings]
gtk-theme-name=TokyoNight
gtk-application-prefer-dark-theme=1
gtk-icon-theme-name=Adwaita
gtk-font-name=Fira Code 10
gtk-monospace-font-name=Fira Code 10" > ~/.config/gtk-3.0/settings.ini

# 5. Handle GTK4/libadwaita apps
mkdir -p ~/.config/gtk-4.0
ln -sf ~/.themes/TokyoNight/gtk-4.0/gtk.css ~/.config/gtk-4.0/
ln -sf ~/.themes/TokyoNight/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/

# 6. Set permanent environment variables
set -Ux GTK_THEME TokyoNight
set -Ux QT_QPA_PLATFORMTHEME gtk2
set -Ux XDG_DATA_DIRS "$HOME/.themes:$XDG_DATA_DIRS"

# 7. Configure Qt apps to use FiraCode
mkdir -p ~/.config/qt5ct
echo "[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/darker.conf
custom_palette=false
standard_dialogs=gtk2
style=gtk2
font='Fira Code,10,-1,5,50,0,0,0,0,0'" > ~/.config/qt5ct/qt5ct.conf

# 8. Create theme reload utility
echo '#!/usr/bin/fish
# Kill and restart LXAppearance to force theme reload
killall -q lxappearance
lxappearance &
sleep 1
killall -q lxappearance
echo "Tokyo Night theme with FiraCode reloaded!"' > ~/.local/bin/reload-theme
chmod +x ~/.local/bin/reload-theme

# 9. Set Xresources for terminal fonts
echo "XTerm*faceName: Fira Code
XTerm*faceSize: 10
UXTerm*faceName: Fira Code
UXTerm*faceSize: 10" > ~/.Xresources
xrdb -merge ~/.Xresources

echo ""
echo "=== Setup Complete ==="
echo "1. Run 'reload-theme' to apply changes immediately"
echo "2. Restart i3 (Mod+Shift+R) for full effect"
echo "3. Configure your terminal emulator to use Fira Code"
