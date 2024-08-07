{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./desktop.nix
    ./programs/gaming/default.nix
  ];
  tunnel.yabridge.enable = true;
  systemd.user.services.ledfx = {
    Unit.Description = "ledfx light control";
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = lib.getExe pkgs.ledfx;
    };
  };
}
