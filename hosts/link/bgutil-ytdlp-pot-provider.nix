_: {
  virtualisation.oci-containers.containers.bgutil-provider = {
    autoStart = true;
    image = "brainicism/bgutil-ytdlp-pot-provider:latest";
    ports = ["4416:4416"];
  };
}
