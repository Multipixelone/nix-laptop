{ inputs, config, ... }:
{
  configurations.nixos.iso.module = {
    imports = with config.flake.modules.nixos; [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      pc
    ];
  };
}
