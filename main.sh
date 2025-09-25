#!/bin/bash

set -u

command -v btmon >/dev/null 2>&1 || { echo "install btmon."; exit 1; }
command -v xdotool >/dev/null 2>&1 || { echo "install xdotool."; exit 1; }

sudo btmon | grep --line-buffered "AT+CHUP" | while read -r line; do
    WINDOW_ID=$(xdotool search --class "discord" 2>/dev/null | head -n 1)
    
    if [ -z "$WINDOW_ID" ]; then
        WINDOW_ID=$(xdotool search --class "vesktop" 2>/dev/null | head -n 1)
    fi

    [ -z "$WINDOW_ID" ] && continue

    ACTIVE_WINDOW=$(xdotool getwindowfocus 2>/dev/null || echo "")

    xdotool windowfocus "$WINDOW_ID"
    sleep 0.1
    xdotool key --window "$WINDOW_ID" ctrl+shift+m

    if [ -n "$ACTIVE_WINDOW" ]; then
        xdotool windowfocus "$ACTIVE_WINDOW"
    fi
done
