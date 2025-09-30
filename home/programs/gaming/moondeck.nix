{
  pkgs,
  self,
  lib,
  ...
}:
{
  systemd.user.services.moondeck = {
    Unit = {
      Description = "MoonDeck streaming server";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe self.packages.${pkgs.system}.moondeck;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
