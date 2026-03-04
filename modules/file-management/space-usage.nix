{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.fish.shellAliases = {
        du = lib.getExe pkgs.ncdu + " --color dark -x";
        df = lib.getExe pkgs.duf;
      };
      home.packages = with pkgs; [
        ncdu
        duf
        dust
      ];
    };
}
