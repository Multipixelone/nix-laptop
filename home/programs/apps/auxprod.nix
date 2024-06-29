{pkgs, ...}: {
  home.packages = with pkgs; [
    musescore
  ];
  tunnel.yabridge = true;
}
