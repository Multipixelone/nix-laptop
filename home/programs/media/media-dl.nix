{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  pins = import ../../../npins;
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
      --yt-dlp-args "extractor-args \"youtube:bypass_native_jsi;deno_no_jitless;player_client=web_music,default\" extractor-args \"youtubepot-bgutilhttp:base_url=http://127.0.0.1:4116\"" \
      --output "{artist} - {album}/{track-number} {title}.{output-ext}" \
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
    # plugin to connect to docker container
    "yt-dlp/plugins/bgutil-ytdlp-pot-provider".source =
      pins.bgutil-ytdlp-pot-provider
      + "/plugin";
    # plugin to allow yt-dlp to get pot token
    # "yt-dlp/plugins/yt-dlp-get-pot".source = pkgs.fetchFromGitHub rec {
    #   version = "0.3.0";
    #   owner = "coletdjnz";
    #   repo = "yt-dlp-get-pot";
    #   tag = "v${version}";
    #   hash = "sha256-MtQFXWJByo/gyftMtywCCfpf8JtldA2vQP8dnpLEl7U=";
    # };
    # plugin to allow yt-dlp to solve with deno
    "yt-dlp/plugins/yt-dlp-deno".source = pkgs.fetchFromGitHub {
      tag = "2024.12.06";
      owner = "bashonly";
      repo = "yt-dlp-YTNSigDeno";
      hash = "sha256-sRO5GGNKkDg0qB/Yl4ZuEaCwpECFA9GtDvURJTqlr0Y=";
    };
  };
  virtualisation.quadlet.containers.bgutil-provider = {
    autoStart = true;
    serviceConfig = {
      RestartSec = "10";
      Restart = "always";
    };
    containerConfig = {
      image = "brainicism/bgutil-ytdlp-pot-provider:${pins.bgutil-ytdlp-pot-provider.version}";
      publishPorts = ["127.0.0.1:4416:4416"];
    };
  };
  home.packages = [
    pkgs.streamrip
    spotdl-wrapped
  ];
  programs = {
    aria2.enable = true;
    yt-dlp = {
      enable = true;
      package = pkgs.yt-dlp.overrideAttrs (prev: {
        propagatedBuildInputs = (prev.propagatedBuildInputs or []) ++ [pkgs.deno];
      });
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
        extractor-args = "youtube:bypass_native_jsi;deno_no_jitless";
      };
    };
  };
}
