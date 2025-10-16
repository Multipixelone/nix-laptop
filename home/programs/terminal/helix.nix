{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  # wrap secret into helix-gpt
  gpt-wrapped = pkgs.writeShellScriptBin "helix-gpt" ''
    export COPILOT_API_KEY=$(cat ${config.age.secrets."copilot".path})
    ${lib.getExe pkgs.helix-gpt} $@
  '';
  zellij-args = ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% --";
  packages = with pkgs; [
    nixfmt
    gpt-wrapped
    marksman
    nodePackages.prettier
    wl-clipboard
    markdown-oxide
  ];
in
{
  # also install packages to main environment
  home.packages = packages;
  age.secrets = {
    "copilot" = {
      file = "${inputs.secrets}/github/copilot.age";
    };
  };
  home.file.".dprint.json".source = builtins.toFile "dprint.json" (
    builtins.toJSON {
      lineWidth = 80;

      # This applies to both JavaScript & TypeScript
      typescript = {
        quoteStyle = "preferSingle";
        binaryExpression.operatorPosition = "sameLine";
      };

      json.indentWidth = 2;

      excludes = [
        "**/*-lock.json"
      ];

      plugins = [
        "https://plugins.dprint.dev/typescript-0.93.0.wasm"
        "https://plugins.dprint.dev/json-0.19.3.wasm"
        "https://plugins.dprint.dev/markdown-0.17.8.wasm"
      ];
    }
  );
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
        rainbow-brackets = true;
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
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "error";
        };
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
            "diagnostics"
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
          C-v = [
            "paste_clipboard_after"
            "collapse_selection"
          ];
          # new helix commands
          C-h = "select_prev_sibling";
          C-j = "shrink_selection";
          C-k = "expand_selection";
          C-l = "select_next_sibling";
          # selection command
          V = [
            "select_mode"
            "extend_to_line_bounds"
          ];
          space = {
            l.g = [
              "${zellij-args} ${lib.getExe pkgs.lazygit}"
              ":reload"
            ];
            n.r = [
              "${zellij-args} nix run"
              ":reload"
            ];
            n.s = [
              "${zellij-args} fish"
              ":reload"
            ];
          };
        };
      };
    };
    languages = {
      language-server = {
        gpt = {
          command = "helix-gpt";
          args = [
            "--handler"
            "copilot"
          ];
        };
        nixd = {
          command = lib.getExe pkgs.nixd;
          args = [ "--inlay-hints=true" ];
          config = {
            formatting.command = [ (lib.getExe pkgs.nixfmt) ];
            nixpkgs.expr = "import <nixpkgs> {}";
            options = {
              nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.default.options";
              home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.default.options";
            };
          };
        };
        basedpyright.command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
        ruff = {
          command = lib.getExe pkgs.ruff;
          args = [ "server" ];
        };
        fish-lsp = {
          command = lib.getExe pkgs.fish-lsp;
          args = [ "start" ];
        };
        dprint = {
          command = lib.getExe pkgs.dprint;
          args = [ "lsp" ];
        };
        astro-ls = {
          command = "${pkgs.astro-language-server}/bin/astro-ls";
          args = [ "--stdio" ];
        };
        typescript-language-server = {
          command = lib.getExe pkgs.nodePackages.typescript-language-server;
          args = [ "--stdio" ];
          config = {
            typescript-language-server.source = {
              addMissingImports.ts = true;
              fixAll.ts = true;
              organizeImports.ts = true;
              removeUnusedImports.ts = true;
              sortImports.ts = true;
            };
            plugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
                languages = [ "vue" ];
              }
            ];
          };
        };
        uwu-colors = {
          command = "${inputs.uwu-colors.packages.${pkgs.system}.default}/bin/uwu_colors";
        };

        vscode-css-language-server = {
          command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
          args = [ "--stdio" ];
          config = {
            provideFormatter = true;
            css.validate.enable = true;
            scss.validate.enable = true;
          };
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
            executable = "latexrun";
            args = [ "%f" ];
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
      language =
        let
          prettier = lang: {
            command = lib.getExe pkgs.nodePackages.prettier;
            args = [
              "--parser"
              lang
            ];
          };
        in
        [
          {
            name = "nix";
            scope = "source.nix";
            file-types = [ "nix" ];
            comment-token = "#";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            injection-regex = "nix";
            language-servers = [
              "nixd"
              "gpt"
            ];
            formatter.command = "nixfmt";
            auto-format = true;
          }
          {
            name = "fish";
            language-servers = [
              "fish-lsp"
              "gpt"
            ];
          }
          {
            name = "markdown";
            language-servers = [
              "marksman"
              "markdown-oxide"
            ];
            formatter = {
              command = "prettier";
              args = [
                "--stdin-filepath"
                "file.md"
              ];
            };
            auto-format = true;
          }
          {
            name = "python";
            auto-format = true;
            language-servers = [
              "basedpyright"
              "ruff"
            ];
          }
          {
            name = "latex";
            file-types = [ "tex" ];
            language-servers = [ "texlab" ];
            text-width = 120;
          }
          {
            name = "css";
            formatter = prettier "css";
            auto-format = true;
            language-servers = [
              "vscode-css-language-server"
              "uwu-colors"
            ];
          }
          {
            name = "html";
            formatter = prettier "html";
            language-servers = [
              "vscode-html-language-server"
            ];
          }
          {
            name = "javascript";
            auto-format = true;
            file-types = [
              "js"
              "jsx"
              "mjs"
            ];
            language-servers = [
              "dprint"
              "typescript-language-server"
            ];
            formatter = {
              command = "${pkgs.dprint}/bin/dprint";
              args = [
                "fmt"
                "--config"
                "${config.xdg.configHome}/dprint/dprint.json"
                "--stdin"
                "javascript"
              ];
            };
          }
          {
            name = "astro";
            auto-format = true;
            formatter = prettier "astro";
            language-servers = [ "astro-ls" ];
          }
        ];
    };
  };
}
