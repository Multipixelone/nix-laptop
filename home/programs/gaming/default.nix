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
    steamtinkerlaunch
    prismlauncher
  ];
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };
}
