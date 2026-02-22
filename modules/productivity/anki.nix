{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.anki = {
        enable = true;
        package = pkgs.anki;
        reduceMotion = true;
        minimalistMode = true;

        sync = {
          syncMedia = true;
          autoSync = true;
        };

        theme = "dark";
        style = "native";

        videoDriver = "opengl";

        addons = with pkgs.ankiAddons; [
          review-heatmap
        ];
      };
    };
}
