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
  # latexrun wrapped w/ args & copy synctex into root
  latexrun-wrapped = pkgs.writeShellScriptBin "latexrun" ''
    ${lib.getExe pkgs.latexrun} --bibtex-cmd "${pkgs.texliveFull}/bin/biber" --latex-args=-synctex=1 "$1"
    SYNCTEX_FILE=$(find latex.out/ -name "*.synctex.gz")
    cp $SYNCTEX_FILE .
  '';
  zellij-args = ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% --";
  packages = with pkgs; [
    alejandra
    gpt-wrapped
    latexrun-wrapped
    marksman
    nodePackages.prettier
    wl-clipboard
    texlab
    markdown-oxide
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
        completion-replace = true;
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
            l.g = ["${zellij-args} ${lib.getExe pkgs.lazygit}" ":reload"];
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
        nixd = {
          command = lib.getExe pkgs.nixd;
          args = ["--inlay-hints=true"];
          config = {
            formatting.command = [(lib.getExe pkgs.alejandra)];
            nixpkgs.expr = "import <nixpkgs> {}";
            options = {
              nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.default.options";
              home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.default.options";
            };
          };
        };
        basedpyright = {
          command = lib.getExe pkgs.basedpyright;
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
            executable = lib.getExe latexrun-wrapped;
            args = ["%f"];
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
          scope = "source.nix";
          file-types = ["nix"];
          comment-token = "#";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          injection-regex = "nix";
          language-servers = ["nixd" "gpt"];
          formatter.command = "alejandra";
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = ["marksman" "markdown-oxide"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.md"];
          };
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["basedpyright"];
          formatter = {
            command = lib.getExe pkgs.black;
            args = ["-" "--quiet" "--line-length 100"];
          };
        }
        {
          name = "latex";
          file-types = ["tex"];
          language-servers = ["texlab"];
          text-width = 120;
        }
      ];
    };
  };
}
