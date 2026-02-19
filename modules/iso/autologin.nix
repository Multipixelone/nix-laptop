{ config, lib, ... }:
{
  configurations.nixos.iso.module = {
    services.displayManager.autoLogin.user = lib.mkForce config.flake.meta.owner.username;
    services.getty.autologinUser = lib.mkForce config.flake.meta.owner.username;
  };
}
