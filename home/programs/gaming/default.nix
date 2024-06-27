{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./mangohud.nix
    ./moondeck.nix
  ];
  home.packages = with pkgs; [
    gamescope
    discord
    lutris
    gamemode
    steamtinkerlaunch
    prismlauncher
    cemu
  ];
}
