{
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
      "--keep-weekly 10"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "00:00";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
  home-folders = {
    paths = [
      "/home/tunnel"
    ];
    exclude = [
      ".cache"
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
  srv-folders = {
    paths = [
      "/srv/grocy"
      "/srv/jdownloader"
      "/srv/slskd"
    ];
  };
in
{
  age.secrets = {
    #"restic/env".file = "${inputs.secrets}/restic/env.age";
    #"restic/repo".file = "${inputs.secrets}/restic/repo.age";
    "restic/password".file = "${inputs.secrets}/restic/password.age";
    "restic/rclone".file = "${inputs.secrets}/restic/${config.networking.hostName}rclone.age";
  };
  services.restic.backups = {
    home = lib.mkMerge [
      default-restic-options
      home-folders
    ];
    srv = lib.mkMerge [
      default-restic-options
      srv-folders
    ];
  };
}
