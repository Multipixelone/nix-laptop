{pkgs, ...}: {
  imports = [];

  home.packages = with pkgs; [
    firefox
    chromium
    profile-sync-daemon
  ];
}
