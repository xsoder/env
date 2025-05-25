#!/bin/bash

# Terminate any running Polybar instances
killall -q polybar

if command -v polybar >/dev/null; then
    for monitor in $(polybar --list-monitors | cut -d":" -f1); do
        MONITOR=$monitor polybar --reload bar1 &
    done
fi

echo "Polybar launched..."
