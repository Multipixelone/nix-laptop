{ lib, ... }:
{
  configurations.nixos.iso.module = {
    # The ISO's nixos user relies on passwordless wheel sudo, but security/sudo.nix
    # forces sudo-rs (replacing regular sudo) without inheriting this setting.
    security.sudo-rs.wheelNeedsPassword = lib.mkForce false;
  };
}
