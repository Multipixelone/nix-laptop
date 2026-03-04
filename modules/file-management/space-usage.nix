{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.fish.shellAliases = {
        ncdu = lib.getExe pkgs.ncdu + " --color dark -x";
        df = lib.getExe pkgs.duf;
        du = lib.getExe pkgs.dust;
      };
      home.packages = with pkgs; [
        ncdu
        duf
        dust
      ];
    };
}
