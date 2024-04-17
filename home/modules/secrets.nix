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
  age.secrets."scrobblehome" = {
    file = "${inputs.secrets}/scrobble.age";
  };
  age.secrets."restic/passwordhome" = {
    file = "${inputs.secrets}/restic/password.age";
  };
}
