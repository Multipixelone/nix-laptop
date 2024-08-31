{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      alejandra
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        indent-guides.render = true;
        lsp.display-inlay-hints = true;
        whitespace.characters = {
          newline = "↴";
          tab = "⇥";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys.normal = {
        C-s = ":write";
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          formatter.command = "alejandra";
        }
      ];
      language-server = {
        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
        };
      };
    };
  };
}
