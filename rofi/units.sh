#!/usr/bin/env bash

# Format: "value from_unit to to_unit" e.g. "100 kg to lb" or "72 F to C"
expr=$(rofi -dmenu -p "convert:" -theme ~/.config/rofi/theme.rasi)
[ -z "$expr" ] && exit 0

result=$(printf '%s' "$expr" | python3 -c "
import sys, re

units = {
    # length
    'mm': 0.001, 'cm': 0.01, 'm': 1, 'km': 1000,
    'in': 0.0254, 'inch': 0.0254, 'inches': 0.0254,
    'ft': 0.3048, 'feet': 0.3048, 'foot': 0.3048,
    'yd': 0.9144, 'yard': 0.9144, 'yards': 0.9144,
    'mi': 1609.344, 'mile': 1609.344, 'miles': 1609.344,
    # weight
    'mg': 0.000001, 'g': 0.001, 'kg': 1,
    'oz': 0.0283495, 'lb': 0.453592, 'lbs': 0.453592,
    'ton': 907.185, 'tonne': 1000,
    # volume
    'ml': 0.001, 'l': 1, 'liter': 1, 'litre': 1,
    'gal': 3.78541, 'gallon': 3.78541,
    'qt': 0.946353, 'quart': 0.946353,
    'pt': 0.473176, 'pint': 0.473176,
    'cup': 0.236588, 'cups': 0.236588,
    'floz': 0.0295735, 'tbsp': 0.0147868, 'tsp': 0.00492892,
    # speed
    'mph': 0.44704, 'kph': 0.277778, 'kmh': 0.277778,
    'mps': 1, 'fps': 0.3048, 'knot': 0.514444, 'knots': 0.514444,
    # time
    'ms': 0.001, 's': 1, 'sec': 1, 'min': 60, 'hr': 3600, 'hour': 3600,
    'day': 86400, 'days': 86400, 'week': 604800, 'weeks': 604800,
    'month': 2592000, 'months': 2592000, 'year': 31536000, 'years': 31536000,
    # data
    'b': 1, 'byte': 1, 'bytes': 1,
    'kb': 1024, 'mb': 1048576, 'gb': 1073741824, 'tb': 1099511627776,
    'kib': 1024, 'mib': 1048576, 'gib': 1073741824, 'tib': 1099511627776,
}

temp_units = {'c', 'f', 'k', 'celsius', 'fahrenheit', 'kelvin'}

def convert_temp(val, src, dst):
    src = src[0] if len(src) > 1 else src
    dst = dst[0] if len(dst) > 1 else dst
    if src == dst: return val
    if src == 'c':
        if dst == 'f': return val * 9/5 + 32
        if dst == 'k': return val + 273.15
    elif src == 'f':
        if dst == 'c': return (val - 32) * 5/9
        if dst == 'k': return (val - 32) * 5/9 + 273.15
    elif src == 'k':
        if dst == 'c': return val - 273.15
        if dst == 'f': return (val - 273.15) * 9/5 + 32
    return None

line = sys.stdin.read().strip().lower()
m = re.match(r'([-+]?[\d.]+)\s*(\S+)\s+(?:to|in|as|->|=)\s+(\S+)', line)
if not m:
    print('format: 100 kg to lb')
    sys.exit()

val, src, dst = float(m.group(1)), m.group(2), m.group(3)

if src in temp_units or dst in temp_units:
    r = convert_temp(val, src, dst)
    if r is not None:
        print(f'{val} {m.group(2)} = {r:.4g} {m.group(3)}')
    else:
        print(f'cannot convert {src} to {dst}')
elif src in units and dst in units:
    r = val * units[src] / units[dst]
    print(f'{val} {m.group(2)} = {r:.6g} {m.group(3)}')
else:
    unknown = src if src not in units else dst
    print(f'unknown unit: {unknown}')
" 2>&1)

printf '%s' "$result" | wl-copy
notify-send "convert" "$result"
