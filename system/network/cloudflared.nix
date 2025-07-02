{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
# FIXME https://github.com/NixOS/nixpkgs/issues/370185
let
  _ = lib.getExe;
  nix-cf = inputs.nixpkgs-cloudflared.legacyPackages.${pkgs.system};
in {
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = {};
  systemd.services.cf-tunnel = {
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target" "dnscrypt-proxy2.service"];
    serviceConfig = {
      # this is gross
      ExecStart = ''
        ${_ pkgs.bash} -c "${_ nix-cf.cloudflared} tunnel --no-autoupdate run --token $(${lib.getExe' pkgs.coreutils "cat"} ${config.age.secrets."cf".path})"'';
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
  age.secrets = {
    "cf" = {
      file = "${inputs.secrets}/cloudflare/${config.networking.hostName}.age";
      mode = "440";
      owner = "cloudflared";
      group = "cloudflared";
    };
  };
}
