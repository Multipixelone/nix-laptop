{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    ani-cli
    strawberry
    plexamp
    imv
    vlc
    blanket
    pavucontrol
    nicotine-plus
    helvum
  ];
}
