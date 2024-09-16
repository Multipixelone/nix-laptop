{...}: {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true; # launches on every open of shell
  };
}
