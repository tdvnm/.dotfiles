{ config, pkgs, lib, ... }:
{
    # ── boot ──────────────────────────────────────────────────────────────
    boot.loader.systemd-boot.enable      = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams                    = [ "i915.enable_psr=0" ];

    # ── networking ────────────────────────────────────────────────────────
    networking.hostName              = "nixos";
    networking.networkmanager.enable = true;

    # ── Locale & Time ─────────────────────────────────────────────────────
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

    # ── Desktop — Sway on Wayland via GDM ─────────────────────────────────
    services.xserver.enable             = true;   # needed for GDM
    services.displayManager.gdm.enable  = true;
    services.displayManager.gdm.wayland = true;

    programs.sway = {
        enable              = true;
        wrapperFeatures.gtk = true;
    };

    xdg.portal = {
        enable       = true;
        wlr.enable   = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.sway  = {
            default = lib.mkForce [ "wlr" "gtk" ];
        };
    };

    services.xserver.xkb.layout = "us";

    environment.sessionVariables = {
        NIXOS_OZONE_WL              = "1";
        MOZ_ENABLE_WAYLAND          = "1";
        QT_QPA_PLATFORM             = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XCURSOR_THEME               = "Adwaita";
        XCURSOR_SIZE                = "24";
    };

    # ── Audio — PipeWire ──────────────────────────────────────────────────
    security.rtkit.enable      = true;
    services.pipewire = {
        enable            = true;
        alsa.enable       = true;
        alsa.support32Bit = true;
        pulse.enable      = true;
    };

    # ── Hardware ──────────────────────────────────────────────────────────
    hardware.bluetooth.enable = true;
    services.blueman.enable   = true;

    # ── Services ──────────────────────────────────────────────────────────
    services.printing.enable              = true;
    services.flatpak.enable               = true;
    services.fprintd.enable               = true;
    services.power-profiles-daemon.enable = true;

    # locate database for plocate — builds index automatically
    services.locate = {
        enable    = true;
        package   = pkgs.plocate;
        localuser = null;   # plocate runs as root to index everything
    };

    # tor — client + onion service for blog on port 8080
    services.tor = {
        enable        = true;
        client.enable = true;
        relay.onionServices.blog.map = [{
            port   = 80;
            target = { addr = "127.0.0.1"; port = 8080; };
        }];
    };

    # ── Virtualisation ────────────────────────────────────────────────────
    virtualisation.docker.enable = true;

    # ── Security & Auth ───────────────────────────────────────────────────

    # fingerprint auth for sudo and login
    security.pam.services.sudo.fprintAuth         = true;
    security.pam.services.gdm.fprintAuth          = true;
    security.pam.services.gdm-password.fprintAuth = true;
    security.pam.services.swaylock                = {};

    # show asterisks when typing passwords (so you can see length)
    security.sudo.extraConfig = ''
        Defaults pwfeedback
    '';

    programs.gnupg.agent = {
        enable           = true;
        enableSSHSupport = true;
    };

    # ── User ──────────────────────────────────────────────────────────────
    users.users.toad = {
        isNormalUser = true;
        description  = "toad";
        shell        = pkgs.fish;
        extraGroups  = [ "networkmanager" "wheel" "fprint" "docker" "video" "wireshark" ];
    };

    # ── Programs (with system integration) ────────────────────────────────
    programs.firefox.enable    = true;
    programs.fish.enable       = true;
    programs.dconf.enable      = true;
    programs.git.enable        = true;
    programs.neovim.enable     = true;
    programs.appimage          = { enable = true; binfmt = true; };
    programs.adb.enable        = true;
    programs.wireshark.enable  = true;
    programs.wireshark.package = pkgs.wireshark;

    programs.waybar.enable = true;
    systemd.user.services.waybar = {
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
            Restart    = "on-failure";
            RestartSec = "2s";
        };
    };

    nixpkgs.config.allowUnfree = true;

    # ── System Packages ───────────────────────────────────────────────────
    environment.systemPackages = with pkgs; [

        # terminals & editors
        kitty
        emacs

        # browsers
        qutebrowser
        tor-browser

        # media
        vlc
        qbittorrent
        snapshot
        newsboat

        # languages & compilers
        gcc
        gnumake
        clang
        ghc
        python3
        nodejs
        pnpm
        dotnet-sdk_8
        texlive.combined.scheme-medium

        # databases
        postgresql
        redis

        # dev tools
        gh
        ripgrep
        unzip
        claude-code

        # networking & security
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
        protonvpn-gui

        # file management & utilities
        wget
        curl
        usbutils
        copyq
        nerdfetch
        yazi
        poppler
        xfce.thunar
        gnome-software
        gnome-font-viewer

        # document viewers
        zathura

        # sway & wayland
        rofi
        dunst
        swaylock
        swayidle
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

    # ── Extra Filesystems ─────────────────────────────────────────────────
    fileSystems."/mnt/data" = {
        device = "/dev/disk/by-uuid/a4e090f2-c5c5-4752-98ed-8b1118494117";
        fsType = "ext4";
    };

    # ── System ────────────────────────────────────────────────────────────
    system.stateVersion = "25.11";
}
