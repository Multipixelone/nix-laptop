{ config, ... }:
{
  configurations.nixos.iot.deployment = {
    targetUser = config.flake.meta.owner.username;
    tags = [ "server" ];
  };
}
