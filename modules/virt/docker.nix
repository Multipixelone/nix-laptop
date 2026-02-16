{ config, ... }:
{
  flake.modules.nixos.base = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    users.extraGroups.docker.members = [ config.flake.meta.owner.username ];
  };
}
