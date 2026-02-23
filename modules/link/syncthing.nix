{ config, ... }:
{
  configurations.nixos.link.module = {
    services.syncthing = {
      enable = true;
      user = "tunnel";
      configDir = "/home/${config.flake.meta.owner.username}/.config/syncthing";
    };
  };
}
