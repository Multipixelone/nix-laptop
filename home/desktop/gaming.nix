{
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  home.packages = with pkgs; [
    sunshine
    prismlauncher
    gamescope
    discord
    lutris
    gamemode
    mangohud
  ];
}
