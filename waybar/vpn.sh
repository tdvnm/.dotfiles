#!/usr/bin/env bash
# waybar vpn module — reports tunnel state, right click tears it down
# nmcli only, no extra packages (jq is not on waybar's PATH)
#
# run with no args it prints one json line per state change and blocks on
# nmcli monitor, so the bar flips the moment the tunnel comes up. `disconnect`
# is the on-click-right action.

set -u

# nmcli -t escapes colons inside names as \: — every other field we ask for
# (type, device, uuid) can't contain one, so name always goes last
unesc() { printf '%s' "${1//\\:/:}"; }

# json string escaping, hand rolled
esc() {
    local s=$1
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    printf '%s' "$s"
}

vpn_type="" vpn_dev="" vpn_uuid="" vpn_name="" uplink=""

# fills the vpn_* vars, plus uplink with whatever carries the real traffic.
# only vpn/wireguard/tun count: proton's kill switch adds pvpn-killswitch and
# pvpn-ipv6-leak-protection connections of type dummy that outlive the tunnel,
# and treating those as "connected" would report on with nothing running
detect() {
    vpn_type="" vpn_dev="" vpn_uuid="" vpn_name="" uplink=""

    local row t d u n rest
    while IFS= read -r row; do
        t=${row%%:*};    rest=${row#*:}
        d=${rest%%:*};   rest=${rest#*:}
        u=${rest%%:*};   n=${rest#*:}

        case $t in
            vpn|wireguard|tun)
                [ -n "$vpn_type" ] && continue
                vpn_type=$t vpn_dev=$d vpn_uuid=$u
                vpn_name=$(unesc "$n")
                ;;
            802-11-wireless|802-3-ethernet)
                [ -z "$uplink" ] && uplink=$d
                ;;
        esac
    done < <(nmcli -t -f TYPE,DEVICE,UUID,NAME connection show --active 2>/dev/null)

    [ -n "$vpn_type" ] && return 0

    # nothing in NetworkManager — catch a tunnel raised outside it, e.g. bare
    # openvpn. pvpnks*/ipv6leak* are the kill switch dummies, skip those too
    local line iface
    while IFS= read -r line; do
        iface=${line#*: }; iface=${iface%%:*}; iface=${iface%%@*}
        case $iface in
            pvpnks*|ipv6leak*) continue ;;
            tun*|proton*|pvpn*|wg*)
                vpn_type=iface vpn_dev=$iface vpn_name=$iface
                return 0
                ;;
        esac
    done < <(ip -o link show up 2>/dev/null)

    return 0
}

ipv4() {
    local line rest
    [ -n "$vpn_dev" ] || return 0
    while IFS= read -r line; do
        rest=${line#*inet }
        printf '%s' "${rest%% *}"
        return 0
    done < <(ip -o -4 addr show dev "$vpn_dev" 2>/dev/null)
}

# one json line. alt picks which format- key config.jsonc renders, so the whole
# label — brackets and teal span — stays there and the retheme search-and-replace
# on that hex still finds it. text must stay non-empty or waybar hides the module
state_json() {
    detect

    if [ -z "$vpn_type" ]; then
        printf '%s' '{"text":"off","alt":"off","class":"disconnected","tooltip":"vpn disconnected"}'
        return
    fi

    local title addr tip
    case "${vpn_name}${vpn_dev}" in
        *[Pp]roton*|*pvpn*) title="ProtonVPN — $vpn_name" ;;
        *)                  title=$vpn_name ;;
    esac
    # the interface fallback has no connection name to show, only the device,
    # which the next line already carries
    [ "$title" = "$vpn_dev" ] && title="vpn active"

    addr=$(ipv4)
    tip=$(esc "$title")
    [ -n "$vpn_dev" ] && tip="$tip\\n$(esc "$vpn_dev")  ${addr:-no ip}"
    [ -n "$uplink" ]  && tip="$tip\\nvia $(esc "$uplink")"

    printf '{"text":"on","alt":"on","class":"connected","tooltip":"%s"}' "$tip"
}

disconnect() {
    detect

    if [ -z "$vpn_type" ]; then
        notify-send "vpn" "nothing to disconnect"
        return
    fi

    if [ -z "$vpn_uuid" ]; then
        notify-send "vpn" "$vpn_dev is not managed by NetworkManager"
        return
    fi

    nmcli connection down uuid "$vpn_uuid" >/dev/null 2>&1

    # the tunnel going down does not take the kill switch with it, and a
    # surviving killswitch profile blackholes everything — clear those too
    local row u n
    while IFS= read -r row; do
        u=${row%%:*}; n=$(unesc "${row#*:}")
        case $n in
            pvpn-*) nmcli connection down uuid "$u" >/dev/null 2>&1 ;;
        esac
    done < <(nmcli -t -f UUID,NAME connection show --active 2>/dev/null)

    notify-send "vpn" "disconnected ${vpn_name:-$vpn_dev}"
}

case "${1-}" in
    disconnect)
        disconnect
        ;;
    "")
        last=$(state_json)
        printf '%s\n' "$last"

        # NetworkManager fires several lines per transition and the address
        # lands a beat after the link does; settle briefly, then drop repeats
        while IFS= read -r _; do
            sleep 0.3
            now=$(state_json)
            [ "$now" = "$last" ] && continue
            last=$now
            printf '%s\n' "$last"
        done < <(nmcli monitor 2>/dev/null)
        ;;
    *)
        printf 'usage: %s [disconnect]\n' "${0##*/}" >&2
        exit 2
        ;;
esac
