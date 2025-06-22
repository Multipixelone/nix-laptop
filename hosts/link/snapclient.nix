{
  lib,
  pkgs,
  ...
}: {
  user.services = {
    snapclient = {
      description = "SnapCast client";
      after = ["pipewire.service"];
      wants = ["pipewire.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --host 192.168.3.127 --player pulse";
      };
    };
  };
}
