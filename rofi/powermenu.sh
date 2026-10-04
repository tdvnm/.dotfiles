#!/usr/bin/env bash

lock="󰌾 lock"
suspend="󰒲 suspend"
hibernate="󰋊 hibernate"
reboot="󰑓 reboot"
shutdown="󰐥 shutdown"

chosen=$(printf '%s\n' "$lock" "$suspend" "$hibernate" "$reboot" "$shutdown" | rofi -dmenu \
    -p "power:" \
    -theme ~/.config/rofi/theme.rasi)

case "$chosen" in
    "$lock")      ~/.config/sway/lock.sh ;;
    "$suspend")   systemctl suspend ;;
    "$hibernate") systemctl hibernate ;;
    "$reboot")    systemctl reboot ;;
    "$shutdown")  systemctl poweroff ;;
esac
