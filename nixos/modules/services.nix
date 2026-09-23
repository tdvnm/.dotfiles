{ pkgs, ... }:
{
  services.flatpak.enable = true;

  # the pixel enumerates as an mtp device but nothing here could speak mtp,
  # so it showed up in lsusb and nowhere else. gvfs is the backend, and
  # kio-extras in packages.nix is what gives dolphin the mtp:/ protocol
  services.gvfs.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  services.tor = {
    enable = true;
    client.enable = true;
    relay.onionServices.blog.map = [{
      port = 80;
      target = { addr = "127.0.0.1"; port = 8080; };
    }];
  };

  # docker 28 went unmaintained in november 2025 and nixpkgs marks it
  # insecure now, so pin 29. my dr-toke containers run on this
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;
}
