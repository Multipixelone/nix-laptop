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
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  imports = [
    #./desktop/gaming.nix
    ./fish.nix
    ./lf.nix
    inputs.nix-index-database.hmModules.nix-index
    #inputs.nixvim.homeManagerModules.nixvim
    ./hyprland/default.nix
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

    # LaTeX
    zotero
    texliveFull

    # Terminal & Shell Stuff
    fish
    eza
    fzf
    fd
    grc
    kitty
    bat
    zellij
    ripgrep
    (inputs.nixvim.legacyPackages."${system}".makeNixvimWithModule {
      inherit pkgs;
      module = ./vim;
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
    ];
  services.udiskie.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = pkgs.lib.mkForce "0.6";
      confirm_os_window_close = 0;
    };
  };
  # basic configuration of git, please change to your own
  #wayland.windowManager.hyprland.enable = true;
  programs.git = {
    enable = true;
    userName = "Multipixelone";
    userEmail = "finn@cnwr.net";
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
