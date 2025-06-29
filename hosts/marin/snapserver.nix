{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  rain-pipe = "/run/snapserver/rain";
in {
  age.secrets."snapserver".file = "${inputs.secrets}/media/spotify.age";
  networking.firewall.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      socketActivation = false;
      pulse.enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    snapserver = {
      enable = true;
      openFirewall = true;
      tcp.enable = true;
      http = {
        enable = true;
        listenAddress = "0.0.0.0";
        docRoot = pkgs.snapweb;
      };
      streams = {
        Spotify = {
          type = "librespot";
          location = "${pkgs.librespot}/bin/librespot";
          query = {
            devicename = "Speakers";
            normalize = "true";
            autoplay = "false";
            cache = "/home/tunnel/.cache/librespot";
            killall = "true";
            params = "--cache-size-limit=4G";
          };
        };
        airplay = {
          type = "airplay";
          # location = "${pkgs.shairport-sync-airplay2}/bin/shairport-sync";
          location = "${pkgs.shairport-sync}/bin/shairport-sync";
          query = {
            name = "AirPlay";
            devicename = "Speakers";
          };
        };
        rain = {
          type = "pipe";
          location = rain-pipe;
        };
      };
    };
  };
  networking.firewall = {
    allowedUDPPorts = [
      319
      320
      5353
    ];
    allowedUDPPortRanges = [
      {
        from = 32768;
        to = 60999;
      }
      {
        from = 6000;
        to = 6009;
      }
    ];
    allowedTCPPorts = [
      3689
      5000
      5353
      7000
    ];
    allowedTCPPortRanges = [
      {
        from = 32768;
        to = 60999;
      }
    ];
  };
  systemd = {
    tmpfiles.rules = [
      "p+ ${rain-pipe} 666 root root - -"
    ];
    user.services = {
      wireplumber.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
      snapclient = {
        description = "SnapCast client";
        after = ["snapserver.service" "pipewire.service" "pipewire-pulse.service"];
        wants = ["pipewire.service" "pipewire-pulse.service"];
        wantedBy = ["default.target"];
        serviceConfig = {
          ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --host 127.0.0.1 --player pulse";
        };
      };
    };
    services = {
      snapserver.serviceConfig.EnvironmentFile = [config.age.secrets.snapserver.path];
      nqptp = {
        description = "Network Precision Time Protocol for Shairport Sync";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          ExecStart = "${pkgs.nqptp}/bin/nqptp";
          Restart = "always";
          RestartSec = "5s";
        };
      };
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
    };
  };
}
