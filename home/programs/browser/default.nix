{pkgs, ...}: {
  imports = [];

  home.packages = with pkgs; [
    chromium
    profile-sync-daemon
  ];
  programs.firefox = {
    enable = true;
  };
}
