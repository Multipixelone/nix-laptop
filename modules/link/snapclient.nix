{
  lib,
  ...
}:
{
  configurations.nixos.link.module = {
    systemd.user.services =
      { pkgs, ... }:
      {
        snapclient = {
          description = "SnapCast client";
          after = [ "pipewire.service" ];
          wants = [ "pipewire.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --host 192.168.5.21 --player pipewire";
          };
        };
      };
  };
}
