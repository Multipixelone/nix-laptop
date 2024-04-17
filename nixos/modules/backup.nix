{
  config,
  inputs,
  agenix,
  ...
}: {
  age.secrets = {
    #"restic/env".file = "${inputs.secrets}/restic/env.age";
    #"restic/repo".file = "${inputs.secrets}/restic/repo.age";
    "restic/password".file = "${inputs.secrets}/restic/password.age";
    "restic/rclone".file = "${inputs.secrets}/restic/${config.networking.hostName}rclone.age";
  };
  services.restic.backups = {
    home = {
      initialize = true;
      repository = "rclone:onedrive:Backups/${config.networking.hostName}";

      rcloneConfigFile = config.age.secrets."restic/rclone".path;
      passwordFile = config.age.secrets."restic/password".path;

      paths = [
        "/home/tunnel"
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
      ];
    };
  };
}
