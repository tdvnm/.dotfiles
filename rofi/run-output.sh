#!/usr/bin/env bash

cmd=$(rofi -dmenu \
    -p "cmd:" \
    -theme ~/.config/rofi/theme.rasi)

[ -z "$cmd" ] && exit 0

output=$(bash -c "$cmd" 2>&1)

if [ -z "$output" ]; then
    notify-send "ran: $cmd" "(no output)"
else
    notify-send "ran: $cmd" "$output"
fi
