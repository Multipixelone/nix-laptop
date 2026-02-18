{
  flake.modules.homeManager.base =
    hmArgs@{
      pkgs,
      lib,
      ...
    }:
    {
      programs = {
        zoxide.enable = true;
        dircolors = {
          enable = true;
        };
        home.packages = with pkgs; [
          grc
        ];
        eza = {
          inherit (hmArgs.config.home.shell) enableFishIntegration;
          enable = true;
          git = true;
          icons = "auto";
          extraOptions = [
            "--color=auto"
          ];
        };
      };
    };
}
