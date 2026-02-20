{ config, ... }:
{
  configurations.nixos.link.deployment = {
    targetUser = config.flake.meta.owner.username;
    tags = [ "desktop" ];
  };
}
