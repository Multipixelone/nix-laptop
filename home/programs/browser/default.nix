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
    # fastforward
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
  better-fox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "128.0";
    hash = "sha256-Xbe9gHO8Kf9C+QnWhZr21kl42rXUQzqSDIn99thO1kE=";
  };
  settings = {
    "app.update.channel" = "default";
    "browser.link.open_newwindow" = true;
  };
in {
  home.packages = with pkgs; [
    chromium
    profile-sync-daemon
  ];
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        inherit extensions settings;
        id = 0;
        extraConfig = builtins.concatStringsSep "\n" [
          (builtins.readFile "${better-fox}/Fastfox.js")
        ];
      };
    };
  };
}
