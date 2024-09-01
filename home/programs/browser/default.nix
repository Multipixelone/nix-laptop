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
    darkreader
    zotero-connector
    violentmonkey # TODO add last.fm script
    istilldontcareaboutcookies
    # website specific extensions
    augmented-steam
    refined-github
    reddit-enhancement-suite
    betterttv
    return-youtube-dislikes
    # custom extensions
    (buildFirefoxXpiAddon rec {
      pname = "last.fm unscrobbler";
      version = "1.6.3";
      addonId = "lastfm@unscrobbler.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4231311/last_fm_unscrobbler-${version}.xpi";
      sha256 = "sha256-K9TrTEnuAEwHTtMRr/VBzsk+s1rnaD0ZMr9akdi6jUs=";
      meta = { };
    })
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
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "media.av1.enabled" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "widget.dmabuf.force-enabled" = true;
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.startup.page" = 3;
    "privacy.clearOnShutdown.history" = false;
    # privacy
    "privacy.donottrackheader.enabled" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    "app.normandy.enabled" = false;
    "app.shield.optoutstudies.enabled" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "";
    "toolkit.telemetry.unified" = false;
    "extensions.webcompat-reporter.enabled" = false;
    "extensions.autoDisableScopes" = 0; # enable extensions by default
    # don't update extensions
    "extensions.update.autoUpdateDefault" = false;
    "extensions.update.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.urlbar.eventTelemetry.enabled" = false; # (default)
    "browser.contentblocking.report.lockwise.enabled" = false;
    "browser.uitour.enabled" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  };
in {
  home = {
    sessionVariables.BROWSER = "firefox";
    packages = with pkgs; [
      chromium
      profile-sync-daemon
    ];
  };
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        inherit extensions settings;
        id = 0;
        search.default = "DuckDuckGo";
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
