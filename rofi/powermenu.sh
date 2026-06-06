#!/usr/bin/env bash

lock="󰌾 lock"
suspend="󰒲 suspend"
hibernate="󰋊 hibernate"
reboot="󰑓 reboot"
shutdown="󰐥 shutdown"

options="$lock\n$suspend\n$hibernate\n$reboot\n$shutdown"

chosen=$(printf "$options" | rofi -dmenu \
    -p "power:" \
    -theme ~/.config/rofi/theme.rasi)

case "$chosen" in
    "$lock")      swaylock ;;
    "$suspend")   systemctl suspend ;;
    "$hibernate") systemctl hibernate ;;
    "$reboot")    systemctl reboot ;;
    "$shutdown")  systemctl poweroff ;;
esac
