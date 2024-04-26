{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home.packages = with pkgs; [
    musescore
    reaper
  ];
}
