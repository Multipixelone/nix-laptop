{
  config,
  pkgs,
  agenix,
  inputs,
  osConfig,
  ...
}: {
  age.identityPaths = [
    "/home/tunnel/.ssh/agenix"
  ];
  age.secrets."scrobblehome" = {
    file = "${inputs.secrets}/scrobble.age";
  };
  age.secrets."restic/passwordhome" = {
    file = "${inputs.secrets}/restic/password.age";
  };
  age.secrets."restic/rclone" = {
    file = "${inputs.secrets}/restic/${osConfig.networking.hostName}rclone.age";
  };
}
