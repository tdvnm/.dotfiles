{ pkgs, ... }:
{
  # programs.* rather than a package in the list below, because each of these
  # needs something a plain package cant do: a setuid wrapper, a group, a
  # dconf/gsettings schema, a systemd unit, or shell completions in /etc

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

  # binaries not built for nix expect /lib64/ld-linux and a libc on a normal
  # path, neither of which exist here. nix-ld provides a stub loader so
  # downloaded toolchains and vscode servers run without patchelf
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # terminal and editors
    kitty
    emacs
    emacsPackages.pdf-tools  # epdfinfo, previously installed only in the user profile
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
}
