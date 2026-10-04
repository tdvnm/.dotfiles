# dotfiles

thinkpad e14 gen 7 — nixos (flake) + sway on wayland.

## layout

- `nixos/` — the whole system, a flake with one module per area in `nixos/modules/`
- `sway waybar rofi dunst kitty fish nvim doom copyq` → `~/.config/`
- `gitconfig` → `~/.gitconfig`

## fresh install

1. partition / luks / mount on `/mnt` by hand.
2. `nixos-generate-config --root /mnt`, copy its `hardware-configuration.nix`
   into `nixos/` so the flake sees it (machine-specific — keep it out of a public repo).
3. `sudo nixos-install --flake /mnt/path/to/dotfiles/nixos#nixos`, set a password, reboot.

## after boot

copy the configs into place:

```sh
cd ~/dotfiles
cp -r sway waybar rofi dunst kitty fish nvim doom copyq ~/.config/
cp gitconfig ~/.gitconfig
```

then doom (config is here, doom itself isn't):

```sh
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

## rebuild / upgrade

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos   # apply changes
nix flake update --flake ~/dotfiles/nixos                  # bump nixpkgs, then rebuild
```
