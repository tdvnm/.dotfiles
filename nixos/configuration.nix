{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./kali.nix
  ];

  # nix itself

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nothing was ever cleaning this up and it got to 439 generations and a
  # 33g store. putting it in the config so i dont have to remember to run it
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # my shell.nix files in ~/code import <nixpkgs>, so point that at the exact
  # nixpkgs this system is built from. otherwise they resolve to a channel
  # that drifts and i get different packages than the system has
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs.config.allowUnfree = true;

  # boot

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

  # keep this as one attrset. if i write boot.kernel.sysctl."foo" anywhere
  # else in the file nix says the attribute is already defined
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

  # memory pressure

  # 14g of ram and swapDevices is empty. with no swap the kernel cant page
  # out anonymous memory, so under pressure it drops executable pages
  # instead, every process refaults its own code off the luks nvme, and the
  # laptop stalls for about an hour without ever hitting the oom killer.
  # zram gives it somewhere cheap to put them
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # zram lives in ram, so it cant hold a hibernation image. this is the disk
  # swap that can. its on the luks root so the image is encrypted too, which
  # a swapfile on /mnt/data would not be. 16g so all 14.5g of ram fits.
  # priority is below zram's 5, so normal paging still goes to zram first and
  # this only gets touched when zram is full or when hibernating
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

  # networking

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # locale and time

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # desktop, sway on wayland off a tty greeter

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
programs.nix-ld.enable = true;
  # audio

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # hardware

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.fprintd.enable = true;
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

  # services

  services.flatpak.enable = true;

  # the pixel enumerates as an mtp device but nothing here could speak mtp,
  # so it showed up in lsusb and nowhere else. gvfs is the backend, and
  # kio-extras below is what gives dolphin the mtp:/ protocol
  services.gvfs.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  services.tor = {
    enable = true;
    client.enable = true;
    relay.onionServices.blog.map = [{
      port = 80;
      target = { addr = "127.0.0.1"; port = 8080; };
    }];
  };

  # docker 28 went unmaintained in november 2025 and nixpkgs marks it
  # insecure now, so pin 29. my dr-toke containers run on this
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  # security and auth

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "net.reactivated.fprint.device.enroll" &&
            subject.isInGroup("fprint")) {
            return polkit.Result.YES;
        }
    });
  '';

  # fingerprint stays off for greetd on purpose. at the greeter it races the
  # reader coming up and can lock me out of my own login
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.polkit-1.fprintAuth = true;
  security.pam.services.swaylock.fprintAuth = true;
  security.pam.services.greetd.fprintAuth = false;

  # asterisks when i type my sudo password so i can see how much ive typed
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # user

  users.users.toad = {
    isNormalUser = true;
    description = "toad";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "fprint" "docker" "video" "wireshark" ];
  };

  # programs that need system integration

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;  # gui build, the module gives me the cli one by default
  };

  programs.waybar.enable = true;
  systemd.user.services.waybar = {
    path = [ "/run/current-system/sw" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

  # packages

  environment.systemPackages = with pkgs; [
    # terminal and editors
    kitty
    emacs
    vim
    helix

    # browsers
    qutebrowser
    tor-browser
    nyx

    # media
    vlc
    qbittorrent
    snapshot
    gimp

    # compilers and languages
    gcc
    clang
    clang-tools  # c_socket has a .clang-format and clang on its own has no formatter
    gnumake
    cmake
    libtool
    pkg-config
    openssl.dev
    ghc
    python3
    nodejs
    pnpm
    texlive.combined.scheme-full
    texlab

    # databases. the actual ones run in docker so these are just for psql and redis-cli
    postgresql
    redis

    # dev tools
    gh
    ripgrep
    fd
    bat
    jq
    claude-code
    cloudflared
    ollama
    proverif

    # mail
    mu
    isync

    # general utilities
    wget
    curl
    file
    tree
    zip
    unzip
    btop
    pciutils
    usbutils
    copyq
    yazi
    poppler
    nerdfetch
    zathura
    imv
    kdePackages.dolphin
    kdePackages.kio-extras  # mtp:/ and friends. dolphin only had kdeconnect.so without it
    libmtp                  # mtp-detect, for checking the phone is seen
    jmtpfs                  # mounting the phone from the terminal
    gnome-software
    gnome-font-viewer

    # sway session
    rofi
    dunst
    swaylock
    swayidle
    grim
    slurp
    swappy
    wl-clipboard
    libnotify
    pavucontrol
    brightnessctl
    playerctl
    xdg-utils
    lxqt.lxqt-policykit
    networkmanagerapplet
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
    cozette
  ];

  # extra disk

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/a4e090f2-c5c5-4752-98ed-8b1118494117";
    fsType = "ext4";
  };

  system.stateVersion = "25.11";
}
