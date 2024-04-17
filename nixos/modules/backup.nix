{config, inputs, ...}: {
  age.secrets."restic" = {
    file = "${inputs.secrets}/restic.age"
  };
  services.restic.backups = {
    passwordFile = config.age.secrets.restic.path
  }
}