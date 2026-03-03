{
  configurations.nixos.marin.module =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
    };
}
