{
  configurations.nixos.marin.module = {
    boot.loader = {
      limine.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
