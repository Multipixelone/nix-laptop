{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./nh.nix
    ./substituters.nix
    ./overlays.nix
  ];
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecurePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "mbedtls"
        "broadcom-sta"
      ];
  };
  age.secrets = {
    "attic".file = "${inputs.secrets}/attic.age";
    "nix" = {
      file = "${inputs.secrets}/github/nix.age";
      mode = "440";
      owner = "tunnel";
      group = "users";
    };
  };
  nix =
    let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
    {
      package = pkgs.lix;
      registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
      extraOptions = ''
        !include ${config.age.secrets.nix.path}
      '';
      settings = {
        trusted-users = [
          "@wheel"
          "root"
          "nix-ssh"
        ];
        # this is disabled because I have my store on a massive drive now, so I shouldn't waste CPU cycles trying to save space
        # auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "/etc/nix/registry.json";
        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;
        netrc-file = config.age.secrets."attic".path;
      };
    };
}
