{...}: let
  sysctluser = "systemctl --user";
in {
  services.gammastep = {
    enable = true;
    tray = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
    # manhatten ny
    latitude = "40.6";
    longitude = "-73.9";
    # https://gitlab.com/chinstrap/gammastep/-/blob/master/gammastep.conf.sample?ref_type=heads
    settings = {
      general = {
        fade = "1";
        brightness-day = "1.0";
        brightness-night = "0.8";
        location-provider = "manual";
        gamma-day = "1.0";
        gamma-night = "0.8";
      };
    };
  };
  wayland.windowManager.hyprland.settings.bind = [
    "Control_L, XF86MonBrightnessUp, exec, ${sysctluser} stop gammastep"
    "Control_L, XF86MonBrightnessDown, exec, ${sysctluser} start gammastep"
  ];
}
