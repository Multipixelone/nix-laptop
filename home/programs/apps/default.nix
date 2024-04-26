{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home.packages = with pkgs; [
    vscode
    obsidian
    gitkraken
    anki
    _1password-gui
  ];
}
