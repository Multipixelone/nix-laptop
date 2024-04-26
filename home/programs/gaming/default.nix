{
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  home.packages = with pkgs; [
    gamescope
    discord
    lutris
    gamemode
    mangohud
    steamtinkerlaunch
    prismlauncher
  ];
}
