{ config, lib, ... }:
{
  flake.modules.nixos.base = {
    security.sudo.enable = lib.mkForce false;
    security.sudo-rs.enable = lib.mkForce true;
    users.users.${config.flake.meta.owner.username}.extraGroups = [
      "wheel"
      "systemd-journal"
    ];
  };
}
