{
  inputs,
  osConfig,
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-emoji
    ];
    extraConfig = {
      show-icons = true;
      steal-focus = true;
      matching = "fuzzy";
      drun-match-fields = "name,generic,categories,keywords";
      drun-display-format = "{name}";
      sorting-method = "fzf";
      combi-hide-mode-prefix = true;
      click-to-exit = true;
      modes = [ "combi" ];
      combi-modes = [
        "drun"
        "emoji"
        "ssh"
      ];
    };

  };
  programs.anyrun = {
    # TEMP: fix this. it's so busted but I'm too lazy to figure out why its busted
    enable = false;
    config = {
      width = {
        fraction = 0.3;
      };
      y = {
        fraction = 0.15;
      };
      hideIcons = false;
      hidePluginInfo = true;
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        shell
        # symbols
        # dictionary
        # websearch
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
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
        Config(
        desktop_actions: true,
          max_entries: 5,
          terminal: Some(Terminal(
            command: "foot",
            args: "{}",
          )),
        )
      '';
      "dictionary.ron".text = ''
        Config(
          prefix: ":d",
        )
      '';
      "shell.ron".text = ''
        Config(
          prefix: ">",
        )
      '';
      "nixos-options.ron".text =
        let
          nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
          hm-options =
            inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
          options = builtins.toJSON {
            ":nix" = [ nixos-options ];
            ":hm" = [ hm-options ];
            ":nall" = [
              nixos-options
              hm-options
            ];
          };
        in
        ''
          Config(
            options: ${options},
            min_score: 2,
            max_entries: Some(5),
          )
        '';
    };
  };
}
