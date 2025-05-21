_: {
  # TODO move this to a rootless quadlet-nix
  virtualisation.oci-containers.containers.bgutil-provider = {
    autoStart = true;
    image = "brainicism/bgutil-ytdlp-pot-provider:0.8.5";
    ports = ["4416:4416"];
  };
}
