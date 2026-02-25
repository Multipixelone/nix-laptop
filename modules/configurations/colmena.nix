{
  lib,
  config,
  inputs,
  ...
}:
let
  deployableHosts = lib.filterAttrs (_: cfg: cfg.deployment != null) config.configurations.nixos;
  nixosConfigs = config.flake.nixosConfigurations;
  hosts = config.hosts;
  defaultTargetHost =
    name:
    let
      nixos = nixosConfigs.${name} or null;
    in
    if nixos != null then nixos.config.networking.fqdn else name;
  resolveTargetHost =
    name: cfg:
    if cfg.deployment.targetHost != null then
      cfg.deployment.targetHost
    else if cfg.deployment.useWireguardAddress then
      let
        addr = (hosts.${name} or (throw "Host '${name}' has useWireguardAddress enabled but is not in the hosts registry")).wireguard.ipv4Address;
      in
      if addr != null then
        addr
      else
        throw "Host '${name}' has useWireguardAddress enabled but no WireGuard address in the hosts registry"
    else
      (defaultTargetHost name);
in
{
  config.flake.colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta.nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
      };
    }
    // lib.mapAttrs (name: cfg: {
      deployment = {
        targetHost = resolveTargetHost name cfg;
        inherit (cfg.deployment) targetUser tags allowLocalDeployment;
      };
      imports = [ cfg.module ];
    }) deployableHosts
  );
}
