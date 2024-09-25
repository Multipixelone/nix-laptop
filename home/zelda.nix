{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./desktop.nix
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = GDK_SCALE,2
  '';
  age.secrets = {
    "shadowsocks-client" = {
      file = "${inputs.secrets}/wireguard/shadowsocks-client.age";
    };
  };
  systemd.user.services = {
    shadowsocks-proxy = {
      Unit = {
        Description = "local shadowsocks proxy";
        After = "network.target";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${pkgs.shadowsocks-libev}/bin/ss-local -c ${config.age.secrets."shadowsocks-client".path}";
        ExecStop = "${pkgs.toybox}/bin/killall ss-local";
      };
    };
  };
}
