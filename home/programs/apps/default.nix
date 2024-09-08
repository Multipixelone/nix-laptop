{
  pkgs,
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
    obsidian
    anki
    gimp
    _1password-gui
  ];
}
