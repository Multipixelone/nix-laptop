{
  pkgs,
  config,
  ...
}: let
  inherit (config.lib.stylix) colors;
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true; # launches on every open of shell
  };
  xdg.configFile = {
    "zellij/config.kdl".text = ''
      theme "catppuccin-mocha"
      simplified_ui true
      pane_frames false
    '';
    "zellij/layouts/default.kdl".text = ''
      layout {
          default_tab_template {
              pane size=2 borderless=true {
                  plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
                      format_left   "{mode}#[bg=#${colors.base00}] {tabs}"
                      format_center ""
                      format_right  "#[bg=#${colors.base00},fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base01},bold] #[bg=#${colors.base02},fg=#${colors.base05},bold] {session} #[bg=#${colors.base03},fg=#${colors.base05},bold]"
                      format_space  ""
                      format_hide_on_overlength "true"
                      format_precedence "crl"
                  }
              }
              children
          }
      }
    '';
  };
}
