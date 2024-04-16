{
  lib,
  config,
  pkgs,
  nix-gaming,
  stylix,
  inputs,
  ...
}: {
  home.username = "tunnel";
  home.homeDirectory = "/home/tunnel";
  stylix.targets.waybar.enable = false;
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_SCREENSHOTS_DIR = "/home/tunnel/Pictures/Screenshots";
  };
  imports = [
    ./modules/gaming.nix
    ./modules/fish.nix
    ./modules/lf.nix
    inputs.nix-index-database.hmModules.nix-index
    ./modules/hyprland/default.nix
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
    spotify
    blanket
    _1password-gui
    _1password
    moonlight-qt
    imv
    zoom-us

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
    yabridge
    yabridgectl
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
  programs.ncmpcpp = {
    enable = true;
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
