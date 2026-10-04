# the graphical session: tty greeter -> sway on wayland, plus the helpers the
# sway config calls, audio, waybar and fonts. the apps are in packages.nix
{ pkgs, ... }:
{
  # login

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway --greeting '' --container-padding 0 --prompt-padding 0";
      user = "greeter";
    };
  };

  # sway. the module also sets up the portals (screensharing, file pickers)

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;  # gtk apps pick up the right theme and settings

    # everything sway/, waybar/ and rofi/ call. this replaces the module's
    # defaults (foot, wmenu, ...), which nothing here uses
    extraPackages = with pkgs; [
      swaylock
      swayidle
      rofi                  # launcher and the rofi/ scripts
      dunst                 # notifications
      libnotify             # notify-send
      copyq                 # clipboard history
      grim                  # screenshot
      slurp                 # pick a region for grim
      swappy                # annotate screenshots
      wl-clipboard          # wl-copy, wl-paste
      pavucontrol           # volume mixer
      brightnessctl
      playerctl             # media keys
      xdg-utils             # xdg-open
      lxqt.lxqt-policykit   # password popup when an app asks for root
      networkmanagerapplet  # nm-connection-editor
      adwaita-icon-theme    # the cursor XCURSOR_THEME names, and icons
    ];
  };

  # tell each toolkit to use wayland directly instead of going through xwayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";               # chromium and electron
    MOZ_ENABLE_WAYLAND = "1";           # firefox, tor browser
    QT_QPA_PLATFORM = "wayland;xcb";    # qt apps; xcb is the fallback for qt5 apps built without wayland
    _JAVA_AWT_WM_NONREPARENTING = "1";  # java apps render blank on tiling wms without this
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # waybar, restarted if it crashes. the path line lets its modules call
  # anything installed system-wide
  programs.waybar.enable = true;
  systemd.user.services.waybar = {
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

  # audio. pipewire also pretends to be pulseaudio and alsa, so apps written
  # for either still work

  security.rtkit.enable = true;  # lets pipewire run realtime, stops crackling
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # nixos turns speech-dispatcher on by default, which pulls in about 700m of
  # voices. i dont use a screen reader
  services.speechd.enable = false;

  # "Monaspace Neon NF", the font every config here names
  fonts.packages = [ pkgs.monaspace ];
}
