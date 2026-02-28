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
                matches = [
                  "http://127.0.0.1/*"
                  "http://localhost/*"
                ];
                css = [ "catppuccin-mocha.css" ];
                js = [ "content.js" ];
                run_at = "document_idle";
              }
            ];
          }
        );

        "content.js" = pkgs.writeText "content.js" ''
          // Overwrite the variables applied by the built-in script
          const root = document.documentElement;

          root.style.setProperty("--typst-preview-background-color", "#1e1e2e");
          root.style.setProperty("--typst-preview-foreground-color", "#cdd6f4");
          root.style.setProperty("--typst-preview-toolbar-fg-color", "#cdd6f4");
          root.style.setProperty("--typst-preview-toolbar-border-color", "#313244");
          root.style.setProperty("--typst-preview-toolbar-bg-color", "#181825");
        '';

        "catppuccin-mocha.css" = pkgs.writeText "catppuccin-mocha.css" ''
          /* Catppuccin Mocha theme for tinymist typst preview */

          /* Override the CSS variable used by the inline style on #typst-app */
          :root {
            --typst-preview-background-color: #1e1e2e !important; /* Mocha Base */
            --typst-preview-foreground-color: #cdd6f4 !important; /* Mocha Text */
            --typst-preview-toolbar-fg-color: #cdd6f4 !important; /* Mocha Text */
            --typst-preview-toolbar-border-color: #313244 !important; /* Mocha Surface0 */
            --typst-preview-toolbar-bg-color: #181825 !important; /* Mocha Mantle */
          }

          body {
            background-color: #1e1e2e !important;
          }

          /* Invert the white-on-black SVG render into Mocha colours.
             Use high specificity to beat tinymist's built-in .invert-colors rule. */
          #typst-app .typst-doc,
          #typst-app.invert-colors .typst-doc {
            filter:
              invert(1)
              hue-rotate(180deg)
              sepia(0.2)
              brightness(0.85)
              contrast(0.95) !important;
          }

          /* Re-invert images so they aren't double-inverted */
          #typst-app .typst-image,
          #typst-app.invert-colors .typst-image {
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
