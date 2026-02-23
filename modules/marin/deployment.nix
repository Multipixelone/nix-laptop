{ config, ... }:
{
  configurations.nixos.marin.deployment = {
    targetUser = config.flake.meta.owner.username;
    tags = [ "server" ];
  };
}
