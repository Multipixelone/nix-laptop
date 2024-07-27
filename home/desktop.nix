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
    WINEFSYNC = 1;
  };
  imports = [
    ./server.nix
    ./secrets.nix
    ./bluetooth.nix
    ./programs/media/default.nix
    ./programs/hyprland/default.nix
    ./programs/apps/default.nix
    ./programs/apps/auxprod.nix
    ./programs/latex/default.nix
    ./programs/browser/default.nix
    ./programs/theming/default.nix
    ./programs/mimeo
    inputs.agenix.homeManagerModules.default
    ./modules/theme
    ./modules/directories
    ./modules/media
  ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Apps
    _1password
    moonlight-qt
    zoom-us
    piper
  ];
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.mimeo}/bin/mimeo";
      };
    };
    tray = "always";
  };
}
