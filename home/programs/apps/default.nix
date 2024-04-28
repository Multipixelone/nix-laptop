{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./foot.nix
  ];

  home.packages = with pkgs; [
    vscode
    obsidian
    gitkraken
    anki
    _1password-gui
  ];
}
