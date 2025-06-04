#!/bin/bash
swayidle -w \
timeout 1800 'systemctl suspend' \
resume ' hyprctl dispatch dpms on' \
before-sleep 'hyprlock'
