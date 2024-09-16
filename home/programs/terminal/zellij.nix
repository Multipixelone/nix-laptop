{inputs, ...}: {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true; # launches on every open of shell
  };
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        default_tab_template {
            pane size=2 borderless=true {
                plugin location="file://${inputs.zjstatus}/bin/zjstatus.wasm" {
                }
            }
            children
        }
    }
  '';
}
