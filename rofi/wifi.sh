#!/usr/bin/env bash
# rofi wifi picker — scan, pick a network, get prompted for the password, connect
# nmcli only, no extra packages

set -u
theme="$HOME/.config/rofi/theme.rasi"

notify() { notify-send "wifi" "$1"; }

nmcli device wifi rescan >/dev/null 2>&1
sleep 1

# SSID is the last field, so its colons can stay literal.  Disabling escaping
# also preserves backslashes without a second, error-prone decoding pass.
mapfile -t rows < <(nmcli -t --escape no -f IN-USE,SIGNAL,SECURITY,SSID device wifi list)

# the in-use flag can land on a weaker bssid than the one we keep, so resolve the
# active ssid separately rather than trusting the row we happen to dedup to
active=""
while IFS= read -r l; do
    [ "${l%%:*}" = "*" ] && { active=${l#*:}; break; }
done < <(nmcli -t --escape no -f IN-USE,SSID device wifi list)

ssids=() secs=() display=()
declare -A seen=()

for row in "${rows[@]}"; do
    # Only the first three colons are field separators.
    rest=${row#*:}
    signal=${rest%%:*}; rest=${rest#*:}
    sec=${rest%%:*};    ssid=${rest#*:}

    [ -z "$ssid" ] && continue
    [ "${seen["$ssid"]+yes}" = yes ] && continue   # keep only the strongest bssid
    seen["$ssid"]=1

    mark=" "; [ "$ssid" = "$active" ] && mark="●"
    lock="open"; [ -n "$sec" ] && lock="$sec"

    ssids+=("$ssid")
    secs+=("$sec")
    display+=("$mark $ssid  ($signal, $lock)")
done

if [ ${#ssids[@]} -eq 0 ]; then
    notify "no networks found"
    exit 1
fi

# -format i returns the chosen row's index; -no-custom blocks typed-in text
idx=$(printf '%s\n' "${display[@]}" | rofi -dmenu -i -p "wifi:" -format i -no-custom -theme "$theme")

# only a plain number inside the list is safe to use as an index. bash reads a
# negative subscript like -1 as "from the end", so a stray -1 would otherwise
# pick the last network. reject empty / non-digits / out of range.
case "$idx" in
    '' | *[!0-9]*) exit 0 ;;
esac
[ "$idx" -ge "${#ssids[@]}" ] && exit 0

ssid=${ssids[$idx]}
sec=${secs[$idx]}

# Profile names can differ from their SSIDs.  Match the actual SSID and use
# the UUID so renamed profiles and names containing punctuation work too.
while IFS=: read -r uuid type; do
    case "$type" in wifi|802-11-wireless) ;; *) continue ;; esac
    saved_ssid=$(nmcli --escape no -g 802-11-wireless.ssid connection show uuid "$uuid" 2>/dev/null) || continue
    [ "$saved_ssid" = "$ssid" ] || continue
    if out=$(nmcli connection up uuid "$uuid" 2>&1); then
        notify "connected to $ssid"
        exit 0
    fi
done < <(nmcli -t -f UUID,TYPE connection show)

if [ -n "$sec" ]; then
    pw=$(rofi -dmenu -password -p "password for $ssid:" -theme "$theme" </dev/null)
    [ -z "$pw" ] && exit 0
    out=$(nmcli device wifi connect "$ssid" password "$pw" 2>&1); rc=$?
else
    out=$(nmcli device wifi connect "$ssid" 2>&1); rc=$?
fi

if [ $rc -eq 0 ]; then
    notify "connected to $ssid"
else
    notify "failed: ${out#Error: }"
fi
