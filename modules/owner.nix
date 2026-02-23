{ config, ... }:
{
  flake = {
    meta.owner = {
      email = "me@finnrut.is";
      name = "Finn Rutis";
      username = "tunnel";
    };

    modules = {
      nixos.base =
        { pkgs, ... }:
        {
          users.users.${config.flake.meta.owner.username} = {
            isNormalUser = true;
            initialPassword = "";
            shell = pkgs.fish;
            # required options for quadlet-nix
            linger = true; # start pods before user logs in
            autoSubUidGidRange = true;
            extraGroups = [ "input" ];
          };

          nix.settings.trusted-users = [ config.flake.meta.owner.username ];
        };
    };
  };
}
