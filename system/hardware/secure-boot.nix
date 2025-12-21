{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.sbctl
  ];

  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # like. i cant figure out how to reset the pk on my blade. freaking weird.
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/var/lib/sbctl";
  };
}
