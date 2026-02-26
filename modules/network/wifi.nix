{ lib, ... }:
{
  flake.modules.nixos.wifi = {
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Faster and more reliable than wpa_supplicant
      dns = lib.mkDefault "systemd-resolved";
    };

    networking.wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        General = {
          EnableNetworkConfiguration = true; # Built-in DHCP client
          # AddressRandomization = "network"; # MAC randomization for privacy
        };
        Network.EnableIPv6 = true;
      };
    };
  };
}
