{ lib, ... }:
{
  programs.mosh = {
    enable = true;
    openFirewall = true;
  };
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      wifi.powersave = false;
      dns = "none";
    };
  };
  services = {
    fail2ban.enable = false;
    openssh = {
      enable = true;
      openFirewall = true;
      allowSFTP = true;
      settings = {
        AllowUsers = [ "tunnel" ];
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
        PubkeyAuthentication = "yes";
        TrustedUserCAKeys = "/etc/ssh/ca.pub";
        AllowTcpForwarding = "no";
        X11Forwarding = false;
        AllowStreamLocalForwarding = "no";
      };
    };
  };
}
