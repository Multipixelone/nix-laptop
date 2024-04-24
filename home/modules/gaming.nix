{
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  home.packages = with pkgs; [
    sunshine
    gamescope
    discord
    lutris
    gamemode
    mangohud
  ];
}
