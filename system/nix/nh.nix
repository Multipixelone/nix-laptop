{ lib, ... }:
{
  # nh default flake
  environment.variables.NH_FLAKE = lib.mkDefault "/home/tunnel/Documents/Git/nix-laptop";

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 10";
    };
  };
}
