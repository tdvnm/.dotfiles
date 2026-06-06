#!/usr/bin/env bash

word=$(rofi -dmenu -p "define:" -theme ~/.config/rofi/theme.rasi)
[ -z "$word" ] && exit 0

definition=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$word" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if isinstance(data, list) and len(data) > 0:
        lines = []
        for meaning in data[0].get('meanings', [])[:3]:
            pos = meaning.get('partOfSpeech', '')
            for d in meaning.get('definitions', [])[:2]:
                lines.append(f'({pos}) {d[\"definition\"]}')
        print('\n'.join(lines) if lines else 'no definition found')
    else:
        print('word not found')
except Exception as e:
    print(f'error: {e}')
" 2>&1)

notify-send "$word" "$definition"
