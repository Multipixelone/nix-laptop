{
  config,
  pkgs,
  agenix,
  inputs,
  ...
}: {
  age.identityPaths = [
    "/home/tunnel/.ssh/agenix"
  ];
  age.secrets."scrobble" = {
    file = "${inputs.secrets}/scrobble.age";
  };
  age.secrets."restic/password" = {
    file = "${inputs.secrets}/restic/password.age";
  };
}
