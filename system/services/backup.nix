{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  default-restic-options = {
    initialize = true;
    repository = "rclone:onedrive:Backups/${config.networking.hostName}";

    rcloneConfigFile = config.age.secrets."restic/rclone".path;
    passwordFile = config.age.secrets."restic/password".path;

    extraBackupArgs = [
      "--one-file-system"
      "--exclude-caches"
      "--retry-lock 2h"
    ];

    pruneOpts = [
      "--keep-daily 14"
      "--keep-weekly 8"
      "--keep-monthly 12"
      "--keep-yearly 5"
    ];
    timerConfig = {
      OnCalendar = "00:00";
      Persistent = true;
      RandomizedDelaySec = "20m";
    };
  };
in
{
  age.secrets = {
    #"restic/env".file = "${inputs.secrets}/restic/env.age";
    #"restic/repo".file = "${inputs.secrets}/restic/repo.age";
    "restic/password".file = "${inputs.secrets}/restic/password.age";
    "restic/rclone".file = "${inputs.secrets}/restic/${config.networking.hostName}rclone.age";
  };
  systemd.services.restic-check-repo = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe config.services.restic.backups.home.package} -r ${default-restic-options.repository} -p ${default-restic-options.passwordFile} check --read-data-subset=25%";
      Path = [ pkgs.rclone ];
      Environment = "RCLONE_CONFIG=${default-restic-options.rcloneConfigFile}";
    };
  };
  systemd.timers.restic-check-repo = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };
  services.restic.backups = {
    home = default-restic-options // {
      paths = [
        "/home/tunnel"
      ];
      exclude = [
        ".local/share/Steam"
        ".local/share/baloo"
        ".local/share/flatpak"
        ".local/share/Trash"
        ".local/share/bottles"
        ".local/share/lutris/runners"
        ".config/steamtinkerlaunch"
        ".config/libvirt"
        ".config/Ryujinx"
        ".config/discord"
        "Documents/Git"
        "Music/Library"
        "Downloads"
        ".var/app"
        ".mozilla"
        ".cargo"
        ".winebroke"
        "Games"
      ];
    };
    # TODO pull this from systemd tmp file declaration
    srv = default-restic-options // {
      paths = [
        "/srv/grocy"
        "/srv/jdownloader"
        "/srv/slskd"
      ];
    };
  };
}
