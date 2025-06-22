{
  # inputs,
  pkgs,
  lib,
  # config,
  ...
}: let
  rain-pipe = "/run/snapserver/rain";
in {
  # age.secrets = {
  #   "snapserver".file = "${inputs.secrets}/media/snapserver.age";
  # };
  # systemd.services.snapserver.serviceConfig = {
  #   LoadCredential = [
  #     "configfile:${config.age.secrets.snapserver.path}"
  #   ];
  # };
  services.pipewire = {
    enable = true;
    systemWide = true;
    pulse.enable = true;
  };
  services.snapserver = {
    enable = true;
    openFirewall = true;
    tcp.enable = true;
    http = {
      enable = true;
      listenAddress = "0.0.0.0";
      docRoot = "${pkgs.snapcast}/share/snapserver/snapweb/";
    };
    streams = {
      airplay = {
        type = "airplay";
        location = "${pkgs.shairport-sync}/bin/shairport-sync";
        query = {
          name = "AirPlay";
          devicename = "Living Room Speakers";
        };
      };
      rain = {
        type = "pipe";
        location = rain-pipe;
      };
    };
  };
  systemd = {
    tmpfiles.rules = [
      "p+ ${rain-pipe} 666 root root - -"
    ];
    services = {
      ambience-rain = let
        rain-sound = pkgs.fetchurl {
          url = "https://media.rainymood.com/0.mp3";
          hash = "sha256-++BUqQf/qiiD062q/fXCd/sZNzbYA+/zTOsIE4LkKFc=";
        };
      in {
        enable = true;
        description = "Play ambient rain on loop";
        wants = ["sound.target"];
        after = ["sound.target"];
        wantedBy = ["multi-user.target"];
        partOf = ["snapserver.service"];
        serviceConfig = {
          DynamicUser = true;
          Group = "audio";

          ExecStart = "${pkgs.mpv}/bin/mpv --audio-display=no --audio-channels=stereo --audio-samplerate=48000 --audio-format=s16 --ao=pcm --ao-pcm-file=${rain-pipe} --loop=inf ${rain-sound}";
          NoNewPrivileges = true;
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          RestrictAddressFamilies = "";
          RestrictNamespaces = true;
        };
      };
      snapclient = {
        description = "SnapCast client";
        after = ["snapserver.service" "pulseaudio.service"];
        wants = ["pulseaudio.service"];
        wantedBy = ["multi-user.target"];
        path = [pkgs.snapcast];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --host 127.0.0.1 --player pulse";
          DynamicUser = true;
          SupplementaryGroups = ["pipewire"];
          RuntimeDirectory = "snapclient";
          PIDFile = "/var/run/snapclient/pid";
        };
      };
    };
  };
}
