{ pkgs, ... }:
{
  imports = [
    ./core.nix
  ];
  networking.hostName = "minish";
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    image = builtins.fetchurl {
      url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
      sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
    };
  };
  # specialisation = {
  #   nvidia-sync.configuration = {
  #     imports = [
  #       inputs.nix-hardware.nixosModules.dell-xps-15-9560-nvidia
  #     ];
  #     hardware.nvidia = {
  #       open = false;
  #       prime = {
  #         sync.enable = lib.mkForce true;
  #         offload = {
  #           enable = lib.mkForce false;
  #           enableOffloadCmd = lib.mkForce false;
  #         };
  #       };
  #     };
  #   };
  # };
  # power management stuff
  # Syncthing
}
