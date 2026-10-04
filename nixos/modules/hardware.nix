# laptop hardware: bluetooth and battery.
#
# the second data disk is deliberately NOT mounted here — set that up by hand
# after the install (lsblk -f for its uuid, then a fileSystems entry).
{ ... }:
{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  # tray applet and pairing gui

  services.power-profiles-daemon.enable = true;

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    # no disk swap means no hibernate, so power off cleanly at 5% instead.
    criticalPowerAction = "PowerOff";
  };

  # upowerd only starts when something asks it over dbus, and waybar reads
  # sysfs directly, so nothing ever started it and the 5% action never fired.
  # start it at boot.
  systemd.services.upower.wantedBy = [ "multi-user.target" ];
}
