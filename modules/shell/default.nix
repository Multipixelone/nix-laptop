{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nil
      ];
      programs.navi.enable = true;
    };
}
