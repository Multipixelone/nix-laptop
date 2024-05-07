{...}: {
  services.gammastep = {
    enable = true;
    tray = false;
    temperature = {
      day = 6500;
      night = 4000;
    };
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
      manual = {
        # Brooklyn, NY
        lat = "40.6";
        lon = "-73.9";
      };
    };
  };
}
