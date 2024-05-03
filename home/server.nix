{
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  home = {
    username = "tunnel";
    homeDirectory = "/home/tunnel";
    sessionVariables = {
      EDITOR = "nvim";
      XDG_SCREENSHOTS_DIR = "/home/tunnel/Pictures/Screenshots";
      RESTIC_PASSWORD_FILE = config.age.secrets."restic/passwordhome".path;
      RCLONE_CONFIG = config.age.secrets."restic/rclone".path;
      RESTIC_REPOSITORY = "rclone:onedrive:Backups/${osConfig.networking.hostName}";
      MOPIDY_PLAYLISTS = "/home/tunnel/.local/share/mopidy/m3u";
    };
  };
  imports = [
    ./programs/terminal/default.nix
    ./secrets.nix
    inputs.nix-index-database.hmModules.nix-index
    inputs.agenix.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    sysstat
    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];
  programs = {
    git = {
      enable = true;
      userName = "Multipixelone";
      userEmail = "finn@cnwr.net";
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
    command-not-found.enable = false;
    nix-index.enable = true;
    home-manager.enable = true;
  };
  home.stateVersion = "23.11";
}
