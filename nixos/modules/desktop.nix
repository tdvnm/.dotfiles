{ pkgs, lib, ... }:
# sway on wayland, launched from a tty greeter. no display manager, no
# desktop environment, so anything a DE would normally set up (portals,
# the applications menu, cursor theme) has to be spelled out here
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway --greeting '' --container-padding 0 --prompt-padding 0";
      user = "greeter";
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # portals are how sandboxed apps ask for a screenshot, a file picker or a
  # screen share. mkForce because the sway defaults would otherwise pull in
  # a second backend and the two race to answer
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.sway.default = lib.mkForce [ "wlr" "gtk" ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # dolphin builds its open with menu from an xdg applications.menu. plasma
  # ships one but sway doesnt, so kbuildsycoca6 indexed nothing and every
  # file gave me an empty menu. this one just includes everything
  environment.etc."xdg/menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
     "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <Directory>Applications.directory</Directory>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
      <Include>
        <All/>
      </Include>
    </Menu>
  '';

  programs.waybar.enable = true;
  systemd.user.services.waybar = {
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
    cozette
    unifont  # Doom symbol font
  ];
}
