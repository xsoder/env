#!/bin/bash

START_FILE="$HOME/.config/polybar/scripts/.arch_start_date"
TOTAL_DAYS=365

if [ ! -f "$START_FILE" ]; then
    date +%Y-%m-%d > "$START_FILE"
fi

# Read the start date
START_DATE=$(cat "$START_FILE")

# Current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Calculate days passed
DAYS_PASSED=$(( ( $(date -d "$CURRENT_DATE" +%s) - $(date -d "$START_DATE" +%s) ) / 86400 ))

# Days remaining
DAYS_LEFT=$(( TOTAL_DAYS - DAYS_PASSED ))

# Prevent negative numbers
if [ "$DAYS_LEFT" -lt 0 ]; then
    DAYS_LEFT=0
fi


if [ "$DAYS_LEFT" -gt 0 ]; then
    echo " $DAYS_LEFT days left"
elif [ "$DAYS_LEFT" -eq 0 ]; then
    echo " Arch quest completed"
else
    echo " OverUse"
fi

