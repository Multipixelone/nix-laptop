_:
let
  sysctluser = "systemctl --user";
in
{
  services.gammastep = {
    enable = true;
    tray = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 4300;
    };
    # https://gitlab.com/chinstrap/gammastep/-/blob/master/gammastep.conf.sample?ref_type=heads
    settings = {
      general = {
        fade = "1";
        brightness-day = "1.0";
        brightness-night = "0.9";
        gamma-day = "1.0";
        gamma-night = "1.0";
      };
    };
  };
  wayland.windowManager.hyprland.settings.bind = [
    "Control_L, XF86MonBrightnessUp, exec, ${sysctluser} stop gammastep"
    "Control_L, XF86MonBrightnessDown, exec, ${sysctluser} start gammastep"
  ];
}
