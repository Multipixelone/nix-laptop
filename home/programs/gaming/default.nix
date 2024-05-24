{pkgs, ...}: {
  imports = [
    ./mangohud.nix
  ];
  home.packages = with pkgs; [
    gamescope
    discord
    lutris
    gamemode
    steamtinkerlaunch
    prismlauncher
  ];
}
