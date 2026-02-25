{
  configurations.nixos.iot.module =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_xanmod;
    };
}
