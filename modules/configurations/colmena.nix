{ lib, config, ... }:
let
  deployableHosts = lib.filterAttrs (_: cfg: cfg.deployment != null) config.configurations.nixos;
  nixosConfigs = config.flake.nixosConfigurations;
  defaultTargetHost =
    name:
    let
      nixos = nixosConfigs.${name} or null;
    in
    if nixos != null then nixos.config.networking.fqdn else name;
in
{
  config.flake.colmena = lib.mapAttrs (
    name: cfg:
    {
      deployment = {
        targetHost =
          if cfg.deployment.targetHost != null then cfg.deployment.targetHost else (defaultTargetHost name);
        inherit (cfg.deployment) targetUser tags allowLocalDeployment;
      };
      imports = [ cfg.module ];
    }
  ) deployableHosts;
}
