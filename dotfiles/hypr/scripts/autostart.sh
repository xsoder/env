#!/bin/bash

/home/csode/.config/hypr/scripts/launch.sh &
/usr/bin/emacs --daemon &                
hyprctl setcursor Bibita-Modern-Ice 24 &
ssh-add &
swww-daemon &
/home/csode/.local/bin/pypr &
~/.config/hypr/scripts/suspend.sh &
flatpak run com.nextcloud.desktopclient.nextcloud &
flatpak run com.borgbase.Vorta &
flatpak run com.core447.StreamController &
swaync &
/usr/libexec/polkit-gnome-authentication-agent-1 &
wl-paste --watch cliphist store &

exec /usr/local/bin/audiobind.sh

