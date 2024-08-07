{
  pkgs,
  lib,
  ...
}: let
  moondeck = pkgs.qt6.callPackage ../../../pkgs/moondeck/default.nix {};
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
