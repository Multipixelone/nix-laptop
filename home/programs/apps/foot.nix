{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  stylix.targets.foot.enable = false;
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        box-drawings-uses-font-glyphs = "yes";
        pad = "4x4 center";
        selection-target = "clipboard";
        font = "PragmataPro Mono Liga:size=11";
      };
      desktop-notifications.command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
      scrollback = {
        lines = 10000;
        multiplier = 3;
        indicator-position = "relative";
        indicator-format = "line";
      };
      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
      };
      cursor = {
        style = "beam";
        beam-thickness = 1;
      };
      colors = {
        alpha = lib.mkIf (osConfig.networking.hostName == "link") "0.85";
      };
    };
  };
}
