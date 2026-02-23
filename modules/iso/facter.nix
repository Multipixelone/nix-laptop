{
  configurations.nixos.iso.module =
    { pkgs, ... }:
    {
      facter.reportPath = ./facter.json;
      environment.systemPackages = [
        pkgs.nixos-facter
      ];
    };
}
