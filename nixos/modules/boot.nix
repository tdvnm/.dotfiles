{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    # display power saving off. the card binds to i915 even though xe is
    # loaded too, so these still do something
    "i915.enable_psr=0"
    "i915.enable_fbc=0"
    "i915.enable_dc=0"

    # byte offset of /swapfile inside the root fs, in 4k blocks. stage-1
    # unlocks luks and points /sys/power/resume at the mapper, but nothing
    # works out where in the filesystem the swapfile actually starts, so the
    # kernel needs it here. recompute with
    #   filefrag -v /swapfile   (first extent, physical_offset)
    # if the swapfile is ever deleted or resized
    "resume_offset=88797184"
  ];

  # the luks mapper, not the raw partition. stage-1 opens luks before it tries
  # to resume, so the device is there by then
  boot.resumeDevice = "/dev/mapper/luks-0588dfe5-e2e4-4904-b217-2c079c2b5be6";
}
