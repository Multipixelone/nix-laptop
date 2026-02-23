{
  lib,
  withSystem,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck { };
    };
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    let
      moondeck = withSystem pkgs.stdenv.hostPlatform.system (psArgs: psArgs.config.packages.moondeck);
    in
    {
      systemd.user.services.moondeck = {
        Unit = {
          Description = "MoonDeck streaming server";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = lib.getExe moondeck;
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
