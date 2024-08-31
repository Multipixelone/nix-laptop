{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = true;
    config = {
      width = {fraction = 0.3;};
      y = {fraction = 0.15;};
      hideIcons = false;
      hidePluginInfo = true;
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        symbols
        dictionary
        websearch
      ];
    };
    extraCss = ''
      * {
        all: unset;
        transition: 200ms ease-out;
        font-family: PragmataPro Liga;
        color: #${config.lib.stylix.colors.base05};
      }
      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }
      #main {
        margin-top: 0.5rem;
      }
      #match {
        padding: 3px;
        border-radius: 12px;
      }
      #match:hover,
      #match:selected {
        background: #${config.lib.stylix.colors.base0E};
        padding: 0.6rem;
      }
      entry#entry {
        border-color: transparent;
        margin-top: 0.5rem;
      }
      box#main {
        background: #${config.lib.stylix.colors.base02};
        border: 3px solid #${config.lib.stylix.colors.base0E}
        border-radius: 10px;
        padding: 0.3rem;
      }
    '';
    extraConfigFiles = {
      "dictionary.ron".text = ''
        Config(
          prefix: "d",
        )
      '';
    };
  };
}
