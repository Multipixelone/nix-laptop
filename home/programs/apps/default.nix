{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./foot.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "obsidian"
      "spotify"
      "plexamp"
      "zoom-us"
    ];

  home.packages = with pkgs; [
    vscode
    obsidian
    gitkraken
    anki
    _1password-gui
  ];
}
