{
  lib,
  config,
  pkgs,
  nix-gaming,
  stylix,
  inputs,
  osConfig,
  ...
}: {
  home.username = "tunnel";
  home.homeDirectory = "/home/tunnel";
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_SCREENSHOTS_DIR = "/home/tunnel/Pictures/Screenshots";
    RESTIC_PASSWORD_FILE = config.age.secrets."restic/passwordhome".path;
    RCLONE_CONFIG = config.age.secrets."restic/rclone".path;
    RESTIC_REPOSITORY = "rclone:onedrive:Backups/${osConfig.networking.hostName}";
    MOPIDY_PLAYLISTS = "/home/tunnel/.local/share/mopidy/m3u";
  };
  systemd.user.startServices = "sd-switch";
  imports = [
    ./programs/terminal/default.nix
    ./programs/media/default.nix
    ./programs/hyprland/default.nix
    ./programs/apps/default.nix
    ./programs/apps/auxprod.nix
    ./programs/latex/default.nix
    ./programs/browser/default.nix
    ./programs/theming/default.nix
    ./secrets.nix
    inputs.nix-index-database.hmModules.nix-index
    inputs.agenix.homeManagerModules.default
  ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    sysstat
    # Apps
    _1password
    moonlight-qt
    zoom-us

    # Fonts

    udiskie

    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];
  services.udiskie.enable = true;
  # basic configuration of git, please change to your own
  #wayland.windowManager.hyprland.enable = true;
  programs.git = {
    enable = true;
    userName = "Multipixelone";
    userEmail = "finn@cnwr.net";
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    forwardAgent = true;
  };
  home.stateVersion = "23.11";
  # Let home Manager install and manage itself.
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.home-manager.enable = true;
}
