# background services.
{ pkgs, ... }:
{
  # `locate foo` finds files by name; plocate is the fast rewrite.
  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  # tor client on 127.0.0.1:9050, for torsocks / proxychains.
  services.tor = {
    enable = true;
    client.enable = true;
  };

  virtualisation.docker.enable = true;

  # let gtk file pickers (e.g. a browser upload dialog) browse the phone over
  # mtp. from a terminal use jmtpfs, in packages.nix.
  services.gvfs.enable = true;
}
