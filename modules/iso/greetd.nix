{ lib, ... }:
{
  configurations.nixos.iso.module.services.greetd.enable = lib.mkForce false;
}
