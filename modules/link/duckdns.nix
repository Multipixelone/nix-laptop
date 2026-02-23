{
  self,
  inputs,
  lib,
  ...
}:
{
  configurations.nixos.link.module =
    { config, ... }:
    {
      imports = [
        self.nixosModules.duckdns
      ];
      age.secrets = {
        "duckdns".file = "${inputs.secrets}/wireguard/duckdns.age";
      };
      chaotic.duckdns = {
        enable = true;
        domain = "frwgq.duckdns.org";
        environmentFile = config.age.secrets."duckdns".path;
        # every three hrs
        onCalendar = "00/3:00";
      };
      # don't wait for duckdns to reach graphical.target
      systemd.services."duckdns-updater".wantedBy = lib.mkForce [ ];
    };
}
