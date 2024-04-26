{
  lib,
  config,
  pkgs,
  nix-gaming,
  stylix,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    ./programs/gaming/default.nix
  ];
  systemd.user.services.ledfx = {
    Unit.Description = "ledfx light control";
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.ledfx}/bin/ledfx";
      #ExecStartPost = ''${pkgs.curl}/bin/curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "main-purple", "action": "activate"}'
      #'';
    };
  };
}
