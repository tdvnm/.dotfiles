{ pkgs, ... }:
{
  # all my security stuff lives here so configuration.nix doesnt get huge.
  # grouped by what id actually reach for at each stage, not alphabetically

  environment.systemPackages = with pkgs; [
    # recon and scanning
    nmap
    masscan
    arp-scan
    netdiscover
    net-tools  # arp, ifconfig, netstat
    whois
    dnsutils
    traceroute
    amass
    subfinder
    sherlock
    theharvester
    maltego

    # traffic and pivoting
    tcpdump
    netcat-openbsd
    socat
    proxychains-ng
    openvpn
    protonvpn-gui

    # web
    burpsuite
    nikto
    gobuster
    ffuf
    whatweb
    wpscan
    sqlmap
    commix
    sslscan

    # passwords and wordlists
    hydra
    john
    hashcat
    crunch
    seclists

    # wireless, mitm, windows networks
    aircrack-ng
    kismet
    macchanger
    ettercap
    responder
    enum4linux-ng
    smbmap

    # exploitation
    metasploit
    exploitdb

    # forensics and reversing
    radare2
    binwalk
    steghide
    exiftool
    volatility3
  ];
}
