{ pkgs, ... }:
{
  # this file is just the index. everything real lives in modules/, one
  # topic per file, so each one fits on a screen:
  #
  #   nix.nix        the package manager itself. gc, store optimise, nixpkgs pin
  #   boot.nix       bootloader, kernel params, where hibernate writes to
  #   memory.nix     zram, swapfile, sysctls, earlyoom. why this laptop is 14g
  #   locale.nix     timezone and en_IN
  #   desktop.nix    greetd, sway, portals, fonts, waybar
  #   hardware.nix   audio, bluetooth, fingerprint, battery, /mnt/data
  #   services.nix   flatpak, gvfs, locate, tor, docker
  #   security.nix   polkit, pam fingerprint rules, sudo, gpg agent
  #   packages.nix   systemPackages and the programs.* that need system setup
  #   kali.nix       security tooling, kept apart because the list is long

  imports = [
    ./hardware-configuration.nix

    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/memory.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/hardware.nix
    ./modules/services.nix
    ./modules/security.nix
    ./modules/packages.nix
    ./modules/kali.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users.toad = {
    isNormalUser = true;
    description = "toad";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "fprint" "docker" "video" "wireshark" ];
  };

  # the nixos release this was first installed against. it pins the defaults
  # for stateful things like database versions. do not bump it to match the
  # channel, it is not a version number
  system.stateVersion = "25.11";
}
