{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    ani-cli
  ];
}
