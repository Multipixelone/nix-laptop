{ config, ... }:
{
  configurations.nixos.zelda.deployment = {
    targetUser = config.flake.meta.owner.username;
    tags = [ "laptop" ];
  };
}
