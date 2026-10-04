# top-level system config. each area is its own file in modules/; this wires
# them up and holds the few odds and ends that fit nowhere else.
{ pkgs, ... }:
{
  imports = [
    # per-machine, kept out of the repo on purpose: nixos-generate-config
    # writes this on a fresh install (disk uuids, luks, cpu). generate it,
    # drop it in next to this file, and `git add -f` it so the flake sees it.
    ./hardware-configuration.nix

    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/memory.nix
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/packages.nix
    ./modules/pentest.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  users.users.toad = {
    isNormalUser = true;
    description = "toad";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"           # sudo
      "networkmanager"  # change wifi without sudo
      "docker"          # docker without sudo
      "video"           # brightnessctl
      "wireshark"       # capture without running wireshark as root
    ];
  };

  # the release this machine was installed with. it is NOT a version switch;
  # changing it upgrades nothing. leave it alone.
  system.stateVersion = "26.05";
}
