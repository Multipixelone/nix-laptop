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
  stylix.targets.waybar.enable = false;
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
    (nerdfonts.override {fonts = ["FiraCode"];})
    (pkgs.callPackage ../pkgs/pragmata/default.nix {})

    udiskie

    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "obsidian"
      "spotify"
      "plexamp"
      "zoom-us"
    ];
  services.udiskie.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        box-drawings-uses-font-glyphs = "yes";
        pad = "0x0 center";
        notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
        selection-target = "clipboard";
      };
      scrollback = {
        lines = 10000;
        multiplier = 3;
      };
      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
      };
      cursor = {
        style = "beam";
        beam-thickness = 1;
      };
      colors = {
        alpha = pkgs.lib.mkForce "0.6";
      };
    };
  };
  stylix.targets.foot.enable = true;
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
  gtk = {
    enable = true;
    theme = pkgs.lib.mkForce {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = pkgs.lib.mkForce {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    #font = (pkgs.callPackage ../pkgs/pragmata/default.nix {});
  };
  stylix.targets.kde.enable = false;
  # Let home Manager install and manage itself.
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.home-manager.enable = true;
}
