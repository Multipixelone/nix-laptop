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
    # TODO (https://github.com/NixOS/nixpkgs/pull/348697)
    # anki
    gimp
  ];
}
