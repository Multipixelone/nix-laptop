{pkgs, ...}: {
  imports = [
    ./desktop.nix
    ./programs/gaming/default.nix
  ];
  systemd.user.services.ledfx = {
    Unit.Description = "ledfx light control";
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.ledfx}/bin/ledfx";
    };
  };
}
