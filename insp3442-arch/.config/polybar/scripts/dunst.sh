#!/usr/bin/env sh
# vi: ft=sh

# Check if dunst is running
if [ -n "$(pgrep -x dunst)" ]; then
    # Get dunst status
    dunst_s="$(dunstctl is-paused)"
    if [ "$dunst_s" == "true" ]; then
        echo "OFF"
    else
        echo "ON"
    fi
else
    echo "--"
fi
