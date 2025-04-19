{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  yabridge-enabled = config.tunnel.yabridge.enable;
  # wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
  wine = pkgs.wineWowPackages.yabridge;
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
