{
  flake.modules.nixos.pc =
    { config, ... }:
    {
      services.zerotierone = {
        enable = true;
        joinNetworks = [ "52b337794f640fc8" ];
      };
      services.tailscale.enable = true;
      networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
      networking.firewall.trustedInterfaces = [
        "tailscale0"
        "ztfp6fg5uh"
      ];
    };
}
