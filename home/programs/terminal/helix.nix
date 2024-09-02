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
        auto-format = true;
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        indent-guides.render = true;
        indent-heuristic = "tree-sitter";
        soft-wrap = {
          enable = true;
          wrap-indicator = "↩ ";
        };
        lsp.display-inlay-hints = true;
        gutters = [
          "diagnostics"
          "line-numbers"
          "spacer"
          "diff"
        ];
        statusline = {
          left = [
            "mode"
            "spacer"
            "diagnostics"
            "version-control"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
            "spinner"
          ];
          right = [
            "register"
            "file-encoding"
            "file-type"
            "selections"
            "position"
          ];
        };
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
      keys = {
        normal = {
          # ctrl + s to save
          C-s = ":write";
          # clipboard commands
          C-v = ["paste_clipboard_after" "collapse_selection"];
          # new helix commands
          C-h = "select_prev_sibling";
          C-j = "shrink_selection";
          C-k = "expand_selection";
          C-l = "select_next_sibling";
          # selection command
          V = ["select_mode" "extend_to_line_bounds"];
          space = {
            l.g = [":new" ":insert-output ${lib.getExe pkgs.lazygit}" ":redraw" "jump_backward"];
          };
        };
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
