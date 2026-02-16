{ withSystem, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.system = pkgs.writeShellScriptBin "system" "nix-instantiate --eval --expr builtins.currentSystem --raw";
    };
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      home.packages =
        (with pkgs; [
          nix-output-monitor
          nix-fast-build
          nix-tree
          nvd
          nix-diff
        ])
        ++ [
          (withSystem pkgs.stdenv.hostPlatform.system (psArgs: psArgs.config.packages.system))
        ];
      environment.variables.NH_FLAKE = lib.mkDefault "/home/tunnel/Documents/Git/nix-laptop";
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 30d --keep 10";
        };
      };
    };
}
