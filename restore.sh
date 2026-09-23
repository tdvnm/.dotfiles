#!/usr/bin/env bash
# Copy only configuration, never clipboard history or personal Org data.
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
target=$HOME
apply=false
while (($#)); do
    case $1 in
        --apply) apply=true; shift ;;
        --home) target=${2:?--home needs a directory}; shift 2 ;;
        *) echo "usage: $0 [--apply] [--home DIR]" >&2; exit 2 ;;
    esac
done
target=$(realpath -m -- "$target")
backup="$target/.local/state/dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"

copy() {
    local source=$1 relative=$2 destination="$target/$2"
    [[ -f $source ]] || { echo "Missing source: $source" >&2; exit 1; }
    if [[ -f $destination ]] && cmp -s -- "$source" "$destination" \
        && [[ $(stat -c %a -- "$source") == $(stat -c %a -- "$destination") ]]; then return; fi
    printf '%s %s\n' "$($apply && echo restore || echo preview)" "$relative"
    $apply || return 0
    if [[ -e $destination || -L $destination ]]; then
        [[ ! -d $destination ]] || { echo "Expected a file: $destination" >&2; exit 1; }
        mkdir -p -- "$backup/$(dirname -- "$relative")"
        cp -a -- "$destination" "$backup/$relative"
    fi
    mkdir -p -- "$(dirname -- "$destination")"
    # Replace a symlink itself instead of writing through it.
    local temporary
    temporary=$(mktemp "$(dirname -- "$destination")/.dotfiles-XXXXXX")
    cp -p -- "$source" "$temporary"
    mv -f -- "$temporary" "$destination"
}

for app in doom sway waybar rofi dunst kitty fish nvim; do
    while IFS= read -r -d '' source; do
        relative=${source#"$repo/"}
        copy "$source" ".config/$relative"
    done < <(find "$repo/$app" -type f \
        ! -path '*/.git/*' ! -path '*/__pycache__/*' \
        ! -path '*/.claude/*' ! -path '*/.agents/*' ! -path '*/.codex/*' \
        ! -name '*.pyc' ! -name '*.elc' ! -name '*.bak' ! -name '*~' \
        ! -name custom.el ! -name fish_variables -print0)
done
copy "$repo/copyq/copyq.conf" .config/copyq/copyq.conf
copy "$repo/copyq/copyq-commands.ini" .config/copyq/copyq-commands.ini
copy "$repo/copyq/themes/sakura.ini" .config/copyq/themes/sakura.ini
for source in "$repo"/monaspace_neon/*.otf; do
    copy "$source" ".local/share/fonts/monaspace_neon/${source##*/}"
done
# Sway and its lock script use this exact location, even from another checkout.
copy "$repo/wallpapers/wxp.png" .config/.dotfiles/wallpapers/wxp.png
for relative in agenda.org logbook/daily/template.org logbook/weekly/template.org; do
    if [[ ! -e "$target/org/$relative" && ! -L "$target/org/$relative" ]]; then
        copy "$repo/org/$relative" "org/$relative"
    fi
done
if $apply; then
    mkdir -p -- "$target/org/tracker" "$target/code" "$target/krea" "$target/images/ss"
    [[ ! -d $backup ]] || printf 'Replaced files backed up in %s\n' "$backup"
    echo 'Configs restored. Restart apps after restoring; run fc-cache -f for fonts.'
else
    echo 'Preview only. Close the affected apps, then rerun with --apply to copy files.'
fi
