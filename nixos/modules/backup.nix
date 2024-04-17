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
    "restic/rclone".file = "${inputs.secrets}/restic/rclone.age";
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
        "Downloads"
        ".var/app"
        ".mozilla"
        ".cargo"
        ".winebroke"
      ];
    };
  };
}
