{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
        flyctl
        sysstat
        just
        i2c-tools
        lm_sensors
        ethtool
        pciutils
        usbutils
        devenv
      ];
    };
}
