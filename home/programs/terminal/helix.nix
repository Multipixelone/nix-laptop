{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  # wrap secret into helix-gpt
  gpt-wrapped = pkgs.writeShellScriptBin "helix-gpt" ''
    export COPILOT_API_KEY=$(cat ${config.age.secrets."copilot".path})
    ${lib.getExe pkgs.helix-gpt} $@
  '';
  packages = with pkgs; [
    nil
    alejandra
    gpt-wrapped
    marksman
    nodePackages.prettier
    wl-clipboard
    texlab
  ];
in {
  # also install packages to main environment
  home.packages = packages;
  age.secrets = {
    "copilot" = {
      file = "${inputs.secrets}/github/copilot.age";
    };
  };
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = packages;
    settings = {
      editor = {
        line-number = "relative";
        auto-format = true;
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        true-color = true; # fix colors over ssh
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
          separator = "";
          left = [
            "mode"
            "separator"
            "file-name"
            "diagnostics"
            "file-modification-indicator"
            "read-only-indicator"
            "spinner"
          ];
          right = [
            "version-control"
            "register"
            "file-encoding"
            "file-type"
            "selections"
            "position"
          ];
          mode = {
            normal = "";
            insert = "I";
            select = "S";
          };
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
      language-server = {
        gpt = {
          command = "helix-gpt";
          args = ["--handler" "copilot"];
        };
        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
        };
        texlab.config.texlab = {
          command = "texlab";
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          build = {
            onSave = true;
            forwardSearchAfter = true;
            executable = lib.getExe pkgs.latexrun;
            args = [
              "--bibtex-cmd"
              "${pkgs.texliveFull}/bin/biber"
              "--latex-args=-synctex=1"
              "%f"
            ];
          };
          forwardSearch = {
            executable = "zathura";
            args = [
              "%p"
              "--synctex-forward"
              "%l:1:%f"
            ];
          };
        };
      };
      language = [
        {
          name = "nix";
          language-servers = ["nil" "gpt"];
          formatter.command = "alejandra";
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = ["marksman" "gpt"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.md"];
          };
          auto-format = true;
        }
        {
          name = "latex";
          file-types = ["tex"];
          language-servers = ["texlab"];
        }
      ];
    };
  };
}
