{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        alsa-scarlett-gui
        scarlett2
      ];
    };
}
