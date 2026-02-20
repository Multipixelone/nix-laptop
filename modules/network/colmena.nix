{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
      ];
    };
}
