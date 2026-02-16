{ config, ... }:
{
  flake = {
    meta.owner = {
      email = "me@finnrut.is";
      name = "Finn Rutis";
      username = "tunnel";
    };

    modules = {
      nixos.base = {
        users.users.${config.flake.meta.owner.username} = {
          isNormalUser = true;
          initialPassword = "";
          extraGroups = [ "input" ];
        };

        nix.settings.trusted-users = [ config.flake.meta.owner.username ];
      };
    };
  };
}
