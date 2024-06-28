{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    musescore
    reaper
  ];
}
