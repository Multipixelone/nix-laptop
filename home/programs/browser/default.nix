{pkgs, ...}: let
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
  ];
in {
  imports = [];

  home.packages = with pkgs; [
    chromium
    profile-sync-daemon
  ];
  programs.firefox = {
    enable = true;
    profiles."default" = {
      inherit extensions;
    };
  };
}
