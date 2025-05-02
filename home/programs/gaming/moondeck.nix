{
  pkgs,
  inputs,
  lib,
  ...
}: let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
  moondeck = pkgs.qt6.callPackage ../../../pkgs/moondeck/default.nix {
    inherit (pkgs-stable) qt6;
    inherit (pkgs-stable) procps;
  };
in {
  systemd.user.services.moondeck = {
    Unit = {
      Description = "MoonDeck streaming server";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = lib.getExe' moondeck "MoonDeckBuddy";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
