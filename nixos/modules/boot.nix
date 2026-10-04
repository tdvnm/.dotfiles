# bootloader and kernel params.
{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;  # keep the last 10 generations in the menu
  boot.loader.efi.canTouchEfiVariables = true;

  # systemd inside the initrd (the modern default): cleaner luks unlock prompt.
  # if a boot ever hangs in the initrd, set this to false and boot an older
  # generation from the menu.
  boot.initrd.systemd.enable = true;

  # stop the gpu blanking / power-saving on this panel (fixes flicker). the
  # card binds to i915 even with xe loaded, so these still apply.
  boot.kernelParams = [
    "i915.enable_psr=0"
    "i915.enable_fbc=0"
    "i915.enable_dc=0"
  ];
}
