{
  flake.modules.homeManager.base =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        ouch
        unzip
        zip
        p7zip
      ];
    };
}
