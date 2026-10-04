{
  description = "thinkpad e14 gen 7 — sway on wayland";

  # the exact nixpkgs commit is pinned in flake.lock (committed). bump it with
  #   nix flake update --flake ~/dotfiles/nixos
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }@inputs:
    {
      # build/switch with:  sudo nixos-rebuild switch --flake ~/dotfiles/nixos#nixos
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        # inputs is passed through so nix.nix can pin the registry to this flake
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
    };
}
