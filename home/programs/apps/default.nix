{pkgs, ...}: {
  imports = [
    ./foot.nix
    ./discord.nix
  ];
  #nixpkgs.config = {
  #  allowUnfree = true;
  #  allowUnfreePredicate = pkg:
  #    builtins.elem (lib.getName pkg) [
  #      "vscode"
  #      "obsidian"
  #      "spotify"
  #      "spicetify-Dribbblish"
  #      "plexamp"
  #      "zoom-us"
  #    ];
  #};

  home.packages = with pkgs; [
    obsidian
    bluebubbles
    anki
    gimp
  ];
}
