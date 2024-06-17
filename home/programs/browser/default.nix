{pkgs, ...}: let
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    # blockers
    sponsorblock
    ublock-origin
    # privacy extensions
    privacy-badger
    privacy-possum
    decentraleyes
    link-cleaner
    clearurls
    fastforward
    # ui
    tree-style-tab
    # utility
    augmented-steam
    darkreader
    zotero-connector
    violentmonkey # TODO add last.fm script
    istilldontcareaboutcookies
    # TODO last.fm unscrobbler
    # TODO readwise
  ];
  settings = {
    "app.update.channel" = "default";
    "browser.link.open_newwindow" = true;
  };
in {
  imports = [];

  home.packages = with pkgs; [
    chromium
    profile-sync-daemon
  ];
  programs.firefox = {
    enable = true;
    # profiles."default" = {
    #   inherit extensions;
    # };
    package = pkgs.firefox-beta-bin;
  };
}
