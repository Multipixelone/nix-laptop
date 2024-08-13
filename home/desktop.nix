{
  pkgs,
  lib,
  inputs,
  config,
  osConfig,
  ...
}: {
  systemd.user = {
    startServices = "sd-switch";
    # TODO figure out why xwaylandvideobridge opens a blank white window on launch
    # services = {
    #   xwaylandvideobridge = {
    #     Unit.Description = "Tool to allow wayland windows to be shared from X11 applications";
    #     Service = {
    #       Type = "simple";
    #       ExecStart = lib.getExe pkgs.xwaylandvideobridge;
    #       Restart = "on-failure";
    #     };
    #     Install.WantedBy = ["graphical-session.target"];
    #   };
    # };
  };
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
    qalculate-gtk
    piper
    waypipe
  ];
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    settings = {
      program_options = {
        file_manager = lib.getExe pkgs.mimeo;
      };
    };
    tray = "always";
  };
}
