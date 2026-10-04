# what happens when ram runs out.
#
# 14g ram. with no swap at all the kernel drops executable pages under
# pressure and the laptop refaults them off the nvme for ages before the oom
# killer ever runs. the fix:
#   1. zram      compressed swap in ram, fast, used first
#   2. earlyoom  kills the worst hog before real thrashing starts
#
# there is no disk swap, so hibernation is off. if you want it back, add a
# swapfile on the luks root and set boot.resumeDevice to that disk.
{ ... }:
{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # one attrset: writing boot.kernel.sysctl."x" twice is a "defined twice" error.
  boot.kernel.sysctl = {
    # alt+sysrq+f runs the oom killer by hand; works even mid-thrash.
    "kernel.sysrq" = 1;

    # zram is ram-speed, so prefer swapping to it over dropping code pages.
    # standard zram tuning.
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.watermark_boost_factor" = 0;
  };

  # systemd-oomd mostly reacts to swap filling, which barely happens here, so
  # it killed nothing. earlyoom looks at free ram directly and acts in time.
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;   # act when <5% ram free ...
    freeSwapThreshold = 5;  # ... and zram is nearly full too
    extraArgs = [
      # prefer killing browsers / electron; never the desktop itself.
      "--prefer" "^(firefox|zapzap|QtWebEngineProc|Isolated Web Co|electron)$"
      "--avoid"  "^(sway|Xwayland|waybar|systemd|dbus-daemon|pipewire)$"
    ];
  };
}
