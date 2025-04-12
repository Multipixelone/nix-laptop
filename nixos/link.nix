{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  gtfs-subway = pkgs.callPackage ../pkgs/aequilibrae/gtfs-subway.nix {};
in {
  imports = [
    ./desktop.nix
    ./modules/gamemode.nix
    ./modules/rgb.nix
    ./modules/gamestream.nix
    ./modules/minecraft-server.nix
  ];
  hardware = {
    steam-hardware.enable = true;
  };
  # TODO re-enable mesa-git eventually
  chaotic = {
    mesa-git.enable = false;
  };
  environment.systemPackages = [
    pkgs.lact
    (import ./modules/scripts/sleep.nix {inherit pkgs;})
    # (pkgs.blender.override {hipSupport = true;})
  ];
  networking = {
    firewall.allowedTCPPorts = [53 631 5353 6680 8080 22 5900 6600 8384 4656 22000 47984 47989 48010 59999];
    firewall.allowedUDPPorts = [631 5353 22000 21027 47998 47999 48000 48002 48010];
    #nameservers = ["192.168.6.111" "192.168.6.112"];
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };
}
