{
  services = {
    fail2ban.enable = true;
    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        AllowUsers = ["tunnel"];
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
