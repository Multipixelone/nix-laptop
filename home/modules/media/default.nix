{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  yabridge-enabled = config.tunnel.yabridge.enable;
  # wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
  pkgs-stable = inputs.yabridge-wine.legacyPackages.${pkgs.system};
  wine = pkgs-stable.wineWowPackages.staging;
in {
  options.tunnel.yabridge = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    izotope-location = mkOption {
      type = types.str;
      default = "/home/tunnel/.izotope";
    };
  };
  config = mkIf yabridge-enabled {
    home.packages = with pkgs; [
      reaper
      yabridgectl
      (yabridge.override {inherit wine;})
      (callPackage ../../../pkgs/izotope {
        inherit wine;
        location = config.tunnel.yabridge.izotope-location;
      })
    ];
  };
}
