#!/bin/bash

# Terminate any running Polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Launch Polybar for each connected monitor
if type "xrandr" >/dev/null; then
    # Get list of all connected monitors
    for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        # Export the monitor variable and launch Polybar
        MONITOR=$monitor polybar --reload mainbar-i3 -c ~/.config/polybar/config.ini &
    done
else
    # Fallback for systems without xrandr
    polybar --reload mainbar-i3 -c ~/.config/polybar/config.ini &
fi

# Alternative method that might work better on some systems:
# if command -v polybar >/dev/null; then
#     for monitor in $(polybar --list-monitors | cut -d":" -f1); do
#         MONITOR=$monitor polybar --reload mainbar-i3 &
#     done
# fi

echo "Polybar launched..."
