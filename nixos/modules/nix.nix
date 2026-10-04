# nix itself, the package manager. the system is built from the flake in this
# directory and pinned by flake.lock.
{ inputs, ... }:
{
  # the newer `nix` cli (`nix shell`, `nix search`) plus flake support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # make `nix shell nixpkgs#foo` and <nixpkgs> resolve to the exact nixpkgs
  # the system was built from, so per-project shell.nix files match it.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # drop generations older than 30 days weekly, and hardlink identical files.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;  # claude-code

  # run prebuilt (non-nix) linux binaries that want a normal /lib64 loader,
  # e.g. what pipx or npm drop into ~/.local/bin.
  programs.nix-ld.enable = true;
}
