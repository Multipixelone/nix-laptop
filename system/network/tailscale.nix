{config, ...}: {
  programs.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
  networking.firewall.trustedInterfaces = [
    "tailscale0"
  ];
}
