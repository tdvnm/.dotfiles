{ inputs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nothing was ever cleaning this up and it got to 439 generations and a
  # 33g store. putting it in the config so i dont have to remember to run it
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # my shell.nix files in ~/code import <nixpkgs>, so point that at the exact
  # nixpkgs this system is built from. otherwise they resolve to a channel
  # that drifts and i get different packages than the system has
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs.config.allowUnfree = true;
}
