#!/usr/bin/env bash

proc=$(ps -eo pid,comm --no-headers --sort=-%mem | \
    rofi -dmenu -p "kill:" -i \
    -theme ~/.config/rofi/theme.rasi)

[ -z "$proc" ] && exit 0

pid=$(echo "$proc" | awk '{print $1}')
name=$(echo "$proc" | awk '{print $2}')

kill "$pid" 2>/dev/null && \
    notify-send "killed" "$name (pid $pid)" || \
    notify-send "failed" "could not kill $name (pid $pid)"
