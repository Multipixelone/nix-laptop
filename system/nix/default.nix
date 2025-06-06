{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nh.nix
    ./substituters.nix
  ];
  nixpkgs.config = {
    allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
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
  nix = let
    flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
  in {
    package = pkgs.lix;
    registry = lib.mapAttrs (_: v: {flake = v;}) flakeInputs;
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    extraOptions = ''
      !include ${config.age.secrets.nix.path}
    '';
    settings = {
      trusted-users = ["@wheel" "root" "nix-ssh"];
      auto-optimise-store = true;
      # lix < 2.93 requires repl-flake for nh
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      flake-registry = "/etc/nix/registry.json";
      netrc-file = config.age.secrets."attic".path;
    };
  };
}
