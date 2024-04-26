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
  age.secretsDir = "/home/tunnel/.secrets";
  age.secrets."scrobblehome" = {
    file = "${inputs.secrets}/media/scrobble.age";
  };
  age.secrets."spotify" = {
    file = "${inputs.secrets}/media/spotify.age";
  };
  age.secrets."restic/passwordhome" = {
    file = "${inputs.secrets}/restic/password.age";
  };
  age.secrets."restic/rclone" = {
    file = "${inputs.secrets}/restic/${osConfig.networking.hostName}rclone.age";
  };
}