{ ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Alternative: Use wpa_supplicant instead of NetworkManager
  # networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable mDNS/Avahi for local network device discovery
  # Required for: Synology NAS, printers, Chromecast, etc.
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Enable mDNS NSS support for IPv4
    openFirewall = true;
  };
}
