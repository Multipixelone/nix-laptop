{
  lib,
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  home.username = "tunnel";
  home.homeDirectory = "/home/tunnel";

  imports = [
    #./desktop/gaming.nix
  ];

  home.packages = with pkgs; [
    sysstat
    # Apps
    firefox
    chromium
    vscode
    # musescore
    reaper
    obsidian
    gitkraken
    vlc
    strawberry
    anki
    qgis

    # Terminal & Shell Stuff
    neovim
    fish
    eza
    fzf
    kitty
    bat
    zellij
    ripgrep

    # RGB
    ledfx

    # Utilities
    waybar
    hyprpaper
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
    playerctl

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
    ];
  services.udiskie.enable = true;
  # basic configuration of git, please change to your own
  #wayland.windowManager.hyprland.enable = true;
  programs.git = {
    enable = true;
    userName = "Multipixelone";
    userEmail = "finn@cnwr.net";
  };
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
