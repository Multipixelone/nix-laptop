{
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}: {
  systemd.user.startServices = "sd-switch";
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/tunnel/Pictures/Screenshots";
    RESTIC_PASSWORD_FILE = config.age.secrets."restic/passwordhome".path;
    RCLONE_CONFIG = config.age.secrets."restic/rclone".path;
    RESTIC_REPOSITORY = "rclone:onedrive:Backups/${osConfig.networking.hostName}";
    MOPIDY_PLAYLISTS = "/home/tunnel/.local/share/mopidy/m3u";
  };
  imports = [
    ./server.nix
    ./secrets.nix
    ./programs/media/default.nix
    ./programs/hyprland/default.nix
    ./programs/apps/default.nix
    ./programs/apps/auxprod.nix
    ./programs/latex/default.nix
    ./programs/browser/default.nix
    ./programs/theming/default.nix
    inputs.agenix.homeManagerModules.default
    ./modules/theme
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
