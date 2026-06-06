#!/usr/bin/env bash

EMOJI_FILE="$HOME/.config/rofi/emoji-list.txt"

chosen=$(rofi -dmenu -p "emoji:" -i \
    -theme ~/.config/rofi/theme.rasi < "$EMOJI_FILE")

[ -z "$chosen" ] && exit 0

emoji="${chosen%% *}"
printf '%s' "$emoji" | wl-copy
notify-send "copied" "$chosen"
