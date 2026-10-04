# authentication: sudo and gpg.
{ pkgs, ... }:
{
  # asterisks while typing the sudo password, so you can see how much you typed.
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  # gpg-agent doubles as the ssh agent; pass uses the same keys.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;  # passphrase popup that works under sway
    settings = {
      default-cache-ttl = 600;  # relock 10 min after last use
      max-cache-ttl = 3600;     # relock after 1 h no matter what
    };
  };
}
