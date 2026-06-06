#!/usr/bin/env bash

result=""
prompt="calc:"

while true; do
    if [ -n "$result" ]; then
        expr=$(echo "$result" | rofi -dmenu -p "$prompt" -theme ~/.config/rofi/theme.rasi)
    else
        expr=$(rofi -dmenu -p "$prompt" -theme ~/.config/rofi/theme.rasi)
    fi

    [ -z "$expr" ] && exit 0

    result=$(printf '%s' "$expr" | python3 -c "
from math import *
import sys
expr = sys.stdin.read()
try:
    r = eval(expr)
    print(r)
except Exception as e:
    print(f'error: {e}')
" 2>&1)

    printf '%s' "$result" | wl-copy
    notify-send "= $result" "$expr"
    prompt="$result ="
done
