{
  configurations.nixos.iot.module = {
    services.openssh.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8qkIXQ0F+FCGzcuZaFoIj95/9G6CN1/kJiEMngWCiJ iot";
  };
}
