{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) better-fox;
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
    fastforwardteam
    facebook-container
    # ui
    tree-style-tab
    # utility
    darkreader
    zotero-connector
    violentmonkey # TODO add last.fm script
    istilldontcareaboutcookies
    onepassword-password-manager
    # website specific extensions
    augmented-steam
    steam-database
    refined-github
    reddit-enhancement-suite
    betterttv
    return-youtube-dislikes
    # custom extensions
    (buildFirefoxXpiAddon rec {
      pname = "lastfm-unscrobbler";
      version = "1.6.3";
      addonId = "lastfm@unscrobbler.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4231311/last_fm_unscrobbler-${version}.xpi";
      sha256 = "sha256-K9TrTEnuAEwHTtMRr/VBzsk+s1rnaD0ZMr9akdi6jUs=";
      meta = {};
    })
    (buildFirefoxXpiAddon rec {
      pname = "readwise-kindle-sync";
      version = "2.8.0";
      addonId = "{f7619bc3-ed22-44a3-83ad-e79a78416737}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3732256/readwise-${version}.xpi";
      sha256 = "sha256-obuJTjrx7Q2AyAr2va/Kkw7ND7yV5AnSD3SUO3B20QY=";
      meta = {};
    })
    (buildFirefoxXpiAddon rec {
      pname = "youtube-popout-player";
      version = "4.4.1";
      addonId = "{85b42b8f-49cd-4935-aeca-a6b32dd6ac9f}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4128380/youtube_popout_player-${version}.xpi";
      sha256 = "sha256-H9r4BgOweFlVsJltm/iZiQ0Sz2o+5x2zSQN3fdORSoA=";
      meta = {};
    })
  ];
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
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    # firefox sync stuff
    "services.sync.username" = "finn@cnwr.net";
    "services.sync.engine.addons" = false;
  };
in {
  home = {
    sessionVariables.BROWSER = "firefox";
    packages = with pkgs; [
      profile-sync-daemon
    ];
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };
  };
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        inherit settings;
        extensions.packages = extensions;
        id = 0;
        search = {
          engines = {
            unduck = {
              name = "unduck";
              urls = [
                {
                  template = "https://unduck.link?q={searchTerms}";
                }
              ];
            };
            bing.metaData.hidden = true;
            amazon.metaData.hidden = true;
            ebay.metaData.hidden = true;
            wikipedia.metaData.hidden = true;
          };
          default = "unduck";
          force = true;
        };
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
          (builtins.readFile "${better-fox}/Peskyfox.js")
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
