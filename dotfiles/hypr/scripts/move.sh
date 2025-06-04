# ~/.config/hypr/scripts/next_open_workspace.sh
#!/bin/bash

current=$(hyprctl activeworkspace -j | jq '.id')
workspaces=($(hyprctl workspaces -j | jq '[.[] | select(.windows > 0) | .id] | sort | .[]'))

for id in "${workspaces[@]}"; do
    if (( id > current )); then
        hyprctl dispatch workspace "$id"
        exit 0
    fi
done

hyprctl dispatch workspace "${workspaces[0]}"

