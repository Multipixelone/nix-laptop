{
  configurations.nixos.iso.module = {
    isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  };
}
