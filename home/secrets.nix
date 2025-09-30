{
  inputs,
  osConfig,
  ...
}:
{
  age = {
    secrets = {
      "scrobblehome" = {
        file = "${inputs.secrets}/media/scrobble.age";
      };
      "spotify" = {
        file = "${inputs.secrets}/media/spotify.age";
      };
      "restic/passwordhome" = {
        file = "${inputs.secrets}/restic/password.age";
      };
      "restic/rclone" = {
        file = "${inputs.secrets}/restic/${osConfig.networking.hostName}rclone.age";
      };
    };
  };
}
