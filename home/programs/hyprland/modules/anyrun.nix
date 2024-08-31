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
        shell
        symbols
        dictionary
        websearch
      ];
    };
    # thank u fufexan (https://github.com/fufexan/dotfiles/blob/41612095fbebb01a0f2fe0980ec507cf02196392/home/programs/anyrun/style-dark.css)
    extraCss = ''
      * {
        all: unset;
        font-family: "Apple Color Emoji", "PragmataPro Liga";
        font-size: 1.2rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match.activatable {
        border-radius: 8px;
        margin: 4px 0;
        padding: 4px;
        /* transition: 100ms ease-out; */
      }
      #match.activatable:first-child {
        margin-top: 12px;
      }
      #match.activatable:last-child {
        margin-bottom: 0;
      }

      #match:hover {
        background: rgba(255, 255, 255, 0.05);
      }
      #match:selected {
        background: rgba(255, 255, 255, 0.1);
      }

      #entry {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 4px 8px;
      }

      box#main {
        background: rgba(0, 0, 0, 0.5);
        box-shadow:
          inset 0 0 0 1px rgba(255, 255, 255, 0.1),
          0 30px 30px 15px rgba(0, 0, 0, 0.5);
        border-radius: 20px;
        padding: 12px;
      }
    '';
    extraConfigFiles = {
      "applications.ron".text = ''
        Config()
          max_entries: 5,
          terminal: Some("foot"),
        )
      '';
      "dictionary.ron".text = ''
        Config(
          prefix: "d"
        )
      '';
      "shell.ron".text = ''
        Config()
          prefix: ">"
        )
      '';
    };
  };
}
