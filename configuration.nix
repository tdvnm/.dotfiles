{ config, pkgs, lib, ... }:
{
    imports = [ ./hardware-configuration.nix ];

    # boot
    boot.loader.systemd-boot.enable      = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # networking
    networking.hostName            = "nixos";
    networking.networkmanager.enable = true;

    # locale and time
    time.timeZone      = "Asia/Kolkata";
    i18n.defaultLocale = "en_IN";
    i18n.extraLocaleSettings = {
        LC_ADDRESS        = "en_IN";
        LC_IDENTIFICATION = "en_IN";
        LC_MEASUREMENT    = "en_IN";
        LC_MONETARY       = "en_IN";
        LC_NAME           = "en_IN";
        LC_NUMERIC        = "en_IN";
        LC_PAPER          = "en_IN";
        LC_TELEPHONE      = "en_IN";
        LC_TIME           = "en_IN";
    };

    # desktop — sway on wayland via gdm
    services.xserver.enable             = true;
    services.displayManager.gdm.enable  = true;
    services.displayManager.gdm.wayland = true;

    programs.sway = {
        enable             = true;
        wrapperFeatures.gtk = true;
    };

  xdg.portal = {  
      enable     = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.sway = {                                                                         
          default = lib.mkForce [ "wlr" "gtk" ];
      };                                                                                      
  };       

    services.xserver.xkb = { layout = "us"; variant = ""; };

    # wayland env vars for electron, firefox, qt, java
    environment.sessionVariables = {
        NIXOS_OZONE_WL              = "1";
        MOZ_ENABLE_WAYLAND          = "1";
        QT_QPA_PLATFORM             = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XCURSOR_THEME               = "Adwaita";
        XCURSOR_SIZE                = "24";
    };

    # audio via pipewire
    services.pulseaudio.enable = false;
    security.rtkit.enable      = true;
    services.pipewire = {
        enable           = true;
        alsa.enable      = true;
        alsa.support32Bit = true;
        pulse.enable     = true;
    };

    # services
    services.printing.enable             = true;
    services.flatpak.enable              = true;
    services.fprintd.enable              = true;
    services.power-profiles-daemon.enable = true;

    hardware.bluetooth.enable = true;
    services.blueman.enable   = true;

    virtualisation.docker.enable = true;
    programs.adb.enable          = true;

    # tor — client + onion service for blog on port 8080
    services.tor = {
        enable        = true;
        client.enable = true;
        relay.onionServices.blog.map = [{
            port   = 80;
            target = { addr = "127.0.0.1"; port = 8080; };
        }];
    };

    # fingerprint auth for sudo and login
    security.pam.services.sudo.fprintAuth        = true;
    security.pam.services.gdm.fprintAuth         = true;
    security.pam.services.gdm-password.fprintAuth = true;
    security.pam.services.swaylock               = {};

    programs.gnupg.agent = {
        enable           = true;
        enableSSHSupport = true;
    };

    # user
    users.users.toad = {
        isNormalUser = true;
        description  = "toad";
        shell        = pkgs.fish;
        extraGroups  = [ "networkmanager" "wheel" "fprint" "docker" "video" "wireshark" ];
    };

    # programs managed by nixos (these get extra config beyond just the binary)
    programs.firefox.enable   = true;
    programs.fish.enable      = true;
    programs.dconf.enable     = true;
    programs.appimage         = { enable = true; binfmt = true; };
    programs.git.enable       = true;
    programs.neovim.enable    = true;
    programs.waybar.enable    = true;
    systemd.user.services.waybar = {
        serviceConfig = {
            Restart = "on-failure";
            RestartSec = "2s";
        };
    };
    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;

    nixpkgs.config.allowUnfree = true;

    # packages
    environment.systemPackages = with pkgs; [

        # essentials
        kitty
        emacs

        # browsers
        qutebrowser
        tor-browser

        # media
        vlc
        qbittorrent
        snapshot

        # languages and compilers
        gcc
        gnumake
        clang
        ghc
        python3
        nodejs
        dotnet-sdk_9
        texlive.combined.scheme-medium

        # dev tools
        gh
        ripgrep
        plocate
        unzip
        claude-code
        nautilus

        # networking and security
        nmap
        whois
        dnsutils
        traceroute
        tcpdump
        sherlock
        theharvester
        maltego
        exiftool
        nikto
        gobuster
        sqlmap
        hydra
        john
        hashcat
        aircrack-ng
        metasploit
        burpsuite
        openvpn

        # utilities
        wget
        curl
        usbutils
        copyq
        protonvpn-gui
        nerdfetch
        yazi
        rofi
        dunst
        poppler
        gnome-font-viewer
        gnome-software
        xfce.thunar

        # sway and wayland stuff
        swaylock
        swayidle
        newsboat
        grim
        slurp
        wl-clipboard
        swappy
        libnotify
        pavucontrol
        brightnessctl
        playerctl
        xdg-utils
        lxqt.lxqt-policykit
        networkmanagerapplet
        imv
    ];

    # extra drive
    fileSystems."/mnt/data" = {
        device = "/dev/disk/by-uuid/a4e090f2-c5c5-4752-98ed-8b1118494117";
        fsType = "ext4";
    };

    boot.kernelParams = [ "i915.enable_psr=0" ];

    system.stateVersion = "25.11";
}
