{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      tinymistThemeExtension = pkgs.linkFarm "tinymist-catppuccin-extension" {
        "manifest.json" = pkgs.writeText "manifest.json" (
          builtins.toJSON {
            manifest_version = 3;
            name = "Tinymist Catppuccin Mocha";
            version = "1.0.0";
            description = "Catppuccin Mocha theme for tinymist typst preview";
            content_scripts = [
              {
                matches = [ "http://127.0.0.1/*" ];
                css = [ "catppuccin-mocha.css" ];
                run_at = "document_start";
              }
            ];
          }
        );

        "catppuccin-mocha.css" = pkgs.writeText "catppuccin-mocha.css" ''
          /* Catppuccin Mocha theme for tinymist typst preview */

          body {
            background-color: #1e1e2e !important;
          }

          #typst-app {
            background-color: #1e1e2e !important;
          }

          /* Invert the white-on-black SVG render into Mocha colours */
          #typst-app .typst-doc {
            filter:
              invert(1)
              hue-rotate(180deg)
              sepia(0.2)
              brightness(0.85)
              contrast(0.95) !important;
          }

          /* Re-invert images so they aren't double-inverted */
          #typst-app .typst-image {
            filter: invert(1) hue-rotate(180deg) !important;
          }

          /* Selection: Catppuccin Mocha Mauve (#cba6f7) */
          .tsel span::selection,
          .tsel::selection {
            background: #cba6f760 !important;
          }

          /* Hover highlight: Mocha Peach */
          .typst-text:hover {
            --glyph_fill: #fab387;
            --glyph_stroke: #fab387;
          }
        '';
      };
    in
    {
      programs.chromium = {
        commandLineArgs = [
          "--load-extension=${tinymistThemeExtension}"
        ];
      };
    };
}
