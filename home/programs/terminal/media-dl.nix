{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  # wrap cookies into spotdl
  spotdl-wrapped = let
    # use version of spotdl that accepts extractor-args for yt-dlp
    spotdl-args = pkgs.spotdl.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "Kyrluckechuck";
        repo = "spotify-downloader";
        rev = "ad48f5ca55b2cc79e3b83bc8e8aa16b16c11d485";
        hash = "sha256-56zVTlzJnI7AFmcZ9ZNZPDx9wc5JxFnSWxmrPkr4bWI=";
      };
    };
  in
    pkgs.writeShellScriptBin "spotdl" ''
      ${lib.getExe spotdl-args} \
      --cookie-file ${config.age.secrets."yt-dlp".path} \
      --yt-dlp-args "extractor-args \"youtube:player_client=web_music,default;getpot_bgutil_baseurl=http://127.0.0.1:4416\"" \
      --format opus \
      --bitrate disable \
      $@
    '';
in {
  age.secrets."yt-dlp" = {
    file = "${inputs.secrets}/media/ytdlp.age";
    # yt-dlp needs write access to cookie file for some reason?
    mode = "600";
  };
  xdg.configFile = {
    "yt-dlp/plugins/bgutil-ytdlp-pot-provider".source =
      pkgs.fetchFromGitHub {
        owner = "Brainicism";
        repo = "bgutil-ytdlp-pot-provider";
        rev = "f16fd8527bb6203943a522d552c9cdc972553448";
        hash = "sha256-dRFGvBKHJxl4hIB5gBZGUyhwYZB/7KQ63DYTHzTAh4s=";
      }
      + "/plugin";
    "yt-dlp/plugins/yt-dlp-get-pot".source = pkgs.fetchFromGitHub rec {
      version = "0.3.0";
      owner = "coletdjnz";
      repo = "yt-dlp-get-pot";
      tag = "v${version}";
      hash = "sha256-MtQFXWJByo/gyftMtywCCfpf8JtldA2vQP8dnpLEl7U=";
    };
  };
  home.packages = [spotdl-wrapped];
  programs = {
    aria2.enable = true;
    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-metadata = true;
        embed-chapters = true;
        embed-subs = true;
        sponsorblock-mark = "all";
        sponsorblock-remove = "sponsor";
        downloader = lib.getExe config.programs.aria2.package;
        downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        cookies = config.age.secrets."yt-dlp".path;
      };
    };
  };
}
