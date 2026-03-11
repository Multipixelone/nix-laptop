{
  flake.modules.nixos.laptop = {
    hardware.brillo.enable = true;
    hardware.acpilight.enable = true;
  };
}
