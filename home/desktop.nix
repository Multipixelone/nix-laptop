{
  pkgs,
  inputs,
  ...
}: {
  systemd.user.startServices = "sd-switch";
  imports = [
    ./server.nix
    ./programs/media/default.nix
    ./programs/hyprland/default.nix
    ./programs/apps/default.nix
    ./programs/apps/auxprod.nix
    ./programs/latex/default.nix
    ./programs/browser/default.nix
    ./programs/theming/default.nix
    inputs.nix-index-database.hmModules.nix-index
    inputs.agenix.homeManagerModules.default
  ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Apps
    _1password
    moonlight-qt
    zoom-us
  ];
  services.udiskie.enable = true;
}
