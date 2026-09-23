{ ... }:
# 14g of ram, no swap partition. with nowhere to page anonymous memory the
# kernel drops executable pages under pressure instead, every process
# refaults its own code off the luks nvme, and the laptop stalls for about
# an hour without ever hitting the oom killer. the three pieces below are
# the fix: zram to page into, a disk swapfile big enough to hibernate into,
# and earlyoom to shoot something before it gets that far
{
  # one attrset for all of them. two `boot.kernel.sysctl` bindings in the
  # same file is a duplicate attribute error, so add new keys in here
  boot.kernel.sysctl = {
    # alt+sysrq+f kicks the oom killer myself. it runs in interrupt context
    # so it still answers while everything else is thrashing
    "kernel.sysrq" = 1;

    # zram is ram speed so swapping to it is way cheaper than letting the
    # kernel throw away executable pages and refault them off the nvme
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.watermark_boost_factor" = 0;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # zram lives in ram, so it cant hold a hibernation image. this is the disk
  # swap that can. its on the luks root so the image is encrypted too, which
  # a swapfile on /mnt/data would not be. 16g so all 14.5g of ram fits.
  # priority is below zram's 5, so normal paging still goes to zram first and
  # this only gets touched when zram is full or when hibernating.
  # boot.nix carries the resume_offset this file's size depends on
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
      priority = -2;
    }
  ];

  # systemd-oomd mostly fires on swap running out, which never happened when
  # i had no swap, so it killed nothing in a month. earlyoom looks at free
  # memory directly and acts before the thrashing starts
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "--prefer" "^(firefox|zapzap|QtWebEngineProc|Isolated Web Co|electron)$"
      "--avoid"  "^(sway|Xwayland|waybar|systemd|dbus-daemon|pipewire)$"
    ];
  };
}
