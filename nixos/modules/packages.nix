# everyday programs.
#
# rule of thumb: a program goes here if i use it most weeks. per-project
# toolchains go in that project's shell.nix (stega brings its own ghc), and
# one-off tools can run without installing: `nix shell nixpkgs#foo`
#
# the programs.* block at the bottom is for things that need more than a
# binary on PATH (groups, wrappers, services), so they get a module instead
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # terminal and editors
    kitty
    emacs
    emacsPackages.pdf-tools  # doom's pdf viewer; its epdfinfo is found on the load path

    # browsers
    qutebrowser
    tor-browser
    nyx  # watch the tor daemon: circuits, bandwidth

    # media
    vlc
    imv          # images
    zathura      # pdfs
    gimp
    snapshot     # webcam
    qbittorrent

    # c and c++
    gcc
    clang
    clang-tools  # clang-format and clangd. c_socket has a .clang-format
    gnumake
    cmake
    libtool
    pkg-config
    openssl.dev

    # other languages
    python3
    pipx
    nodejs
    pnpm
    stylua               # lua formatter neovim runs on save
    lua-language-server  # neovim's lua lsp (clangd is in clang-tools, texlab below)

    # latex. scheme-full was 4.4g on its own; medium covers normal documents.
    texliveMedium
    texlab  # latex language server

    # database clients. the servers themselves run in docker
    postgresql  # psql
    redis       # redis-cli

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
    pass

    # files and system info
    yazi         # terminal file manager
    wget
    curl
    file
    tree
    zip
    unzip
    poppler      # pdftotext and friends
    btop
    pciutils     # lspci
    usbutils     # lsusb
    nerdfetch

    # phone over usb (mtp)
    libmtp       # mtp-detect, to check the phone is seen
    jmtpfs       # mount the phone as a folder

    # fonts gui
    gnome-font-viewer
  ];

  # programs that need system integration, not just a binary

  programs.fish.enable = true;        # login shell, set in configuration.nix
  programs.dconf.enable = true;       # gtk apps store their settings here
  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.firefox.enable = true;
  programs.browserpass.enable = true; # lets the browser extension read pass
  programs.kdeconnect.enable = true;  # also opens its firewall ports

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;  # gui build. the module installs the cli one by default
  };
}
