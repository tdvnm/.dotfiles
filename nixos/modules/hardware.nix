{ ... }:
{
  # audio

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # bluetooth

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # fingerprint reader. security.nix is what actually lets it stand in for a
  # password, this just runs the daemon
  services.fprintd.enable = true;

  # battery and power

  services.power-profiles-daemon.enable = true;

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    # hibernate, not hybridsleep. hybridsleep writes the image but then stays
    # in s3 still drawing power, and at 5% there isnt enough left to spend on
    # that. hibernate powers off, so plugging in and booting restores the session
    criticalPowerAction = "Hibernate";
  };

  # the upstream unit is dbus activated only and the nixos module adds no
  # wantedBy, so upowerd was not running unless something asked it for battery
  # state. waybar reads sysfs directly, so nothing did, and the 5% action
  # never had a daemon to fire it
  systemd.services.upower.wantedBy = [ "multi-user.target" ];

  # the second disk. the root fs is in hardware-configuration.nix
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/a4e090f2-c5c5-4752-98ed-8b1118494117";
    fsType = "ext4";
  };
}
