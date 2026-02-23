{ config, ... }:
{
  flake.modules.nixos.base = {
    security.sudo.enable = true;
    security.sudo-rs.enable = false;
    users.users.${config.flake.meta.owner.username}.extraGroups = [
      "wheel"
      "systemd-journal"
    ];
  };
}
