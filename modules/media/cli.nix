{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ani-cli
        imv
        ffmpeg
        gifski
      ];
    };
}
