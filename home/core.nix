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
    ./modules/fish.nix
    ./modules/lf.nix
    ./modules/ncmpcpp.nix
    ./modules/mpv.nix
    inputs.nix-index-database.hmModules.nix-index
    ./modules/hyprland/default.nix
    ./modules/secrets.nix
    ./modules/spicetify.nix
    ./modules/btop.nix
    ./modules/bat.nix
    inputs.agenix.homeManagerModules.default
  ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    sysstat
    # Apps
    firefox
    chromium
    vscode
    musescore
    reaper
    obsidian
    gitkraken
    vlc
    strawberry
    anki
    plexamp
    blanket
    _1password-gui
    _1password
    moonlight-qt
    imv
    zoom-us
    prismlauncher

    # LaTeX
    zotero
    texliveFull

    # Terminal & Shell Stuff
    fish
    eza
    fzf
    fd
    grc
    btop
    lazygit
    kitty
    bat
    zellij
    ripgrep
    nil
    nom
    restic
    attic-client
    (inputs.nixvim.legacyPackages."${system}".makeNixvimWithModule {
      inherit pkgs;
      module = ./modules/vim;
    })

    # Fonts
    (nerdfonts.override {fonts = ["FiraCode"];})
    (pkgs.callPackage ../pkgs/pragmata/default.nix {})

    # Utilities
    #waybar
    #hyprpaper
    rofi-wayland
    profile-sync-daemon
    udiskie
    kubectl

    # Audio
    pavucontrol
    nicotine-plus
    helvum
    #playerctl

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
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [mopidy-mpd mopidy-iris mopidy-mpris mopidy-scrobbler mopidy-local (callPackage ../pkgs/mopidy/spotify.nix {})];
    extraConfigFiles = ["${config.age.secrets."scrobblehome".path}" "${config.age.secrets."spotify".path}"];
    settings = {
      local = {
        media_dir = [
          "/media/Data/Music"
        ];
        scan_timeout = 5000;
      };
      mpd = {
        hostname = "0.0.0.0";
      };
      http = {
        hostname = "0.0.0.0";
      };
      iris = {
        enabled = true;
        country = "US";
        locale = "en_US";
      };
      m3u = {
        enabled = true;
        playlists_dir = "/home/tunnel/.local/share/mopidy/m3u";
        base_dir = "";
      };
    };
  };
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
