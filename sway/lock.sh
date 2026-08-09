#!/usr/bin/env bash
# the one lock screen definition — used by sway ($mod+escape, lid close),
# swayidle, and rofi/powermenu.sh
# -f daemonizes once the lock is up, which is what swayidle's before-sleep needs

exec swaylock -f \
    -i "$HOME/.config/.dotfiles/wallpapers/wxp.png" -s fill \
    --indicator-radius 90 --indicator-thickness 8 \
    --ring-color ed5ab3 --ring-ver-color b0578d --ring-wrong-color eb4d4b \
    --key-hl-color fed9ed --bs-hl-color eb4d4b \
    --line-color 00000000 --separator-color 00000000 \
    --inside-color 000000aa --text-color fed9ed
