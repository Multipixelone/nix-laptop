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
        userChrome = ''
          #TabsToolbar {
          visibility: collapse;
          }

          #titlebar {
              margin-bottom: !important;
          }

          #titlebar-buttonbox {
              height: 32px !important;
          }

          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            display: none;
          }
        '';
        extraConfig = builtins.concatStringsSep "\n" [
          (builtins.readFile "${better-fox}/Fastfox.js")
          ''
            user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
            user_pref("general.smoothScroll", true); // DEFAULT
            user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
            user_pref("general.smoothScroll.msdPhysics.enabled", true);
            user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
            user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
            user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
            user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
            user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
            user_pref("general.smoothScroll.currentVelocityWeighting", "1");
            user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
            user_pref("mousewheel.default.delta_multiplier_y", 300); // 250-400; adjust this number to your liking''
        ];
      };
    };
  };
}
