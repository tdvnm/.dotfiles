#!/usr/bin/env bash

# region grab that asks where to save — bound to $mod+Print in sway
# the grab happens first so rofi never ends up in the picture

shots=~/images/ss

area=$(slurp) || exit 0
[ -z "$area" ] && exit 0

tmp=$(mktemp /tmp/screenshot-XXXXXX.png)
grim -g "$area" "$tmp" || { rm -f "$tmp"; notify-send "screenshot" "grab failed"; exit 1; }

default="$shots/$(date +%Y%m%d-%H%M%S).png"
dest=$(echo "$default" | rofi -dmenu -p "save as:" -filter "$default" \
    -theme ~/.config/rofi/theme.rasi)

[ -z "$dest" ] && rm -f "$tmp" && exit 0

dest="${dest/#\~/$HOME}"
[ "$dest" = "${dest%/*}" ] && dest="$shots/$dest"
[ "$dest" = "${dest%.png}" ] && dest="$dest.png"

mkdir -p "$(dirname "$dest")"

mv "$tmp" "$dest" && wl-copy < "$dest" && \
    notify-send "screenshot" "saved $dest" || \
    notify-send "screenshot" "could not save $dest"
