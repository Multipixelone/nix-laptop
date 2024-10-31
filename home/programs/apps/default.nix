{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./foot.nix
    ./discord.nix
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
  ];
}
