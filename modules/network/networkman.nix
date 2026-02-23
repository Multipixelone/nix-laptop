{ lib, ... }:
{
  flake.modules.nixos.pc = {
    networking = {
      networkmanager = {
        enable = lib.mkDefault true;
        wifi.powersave = false;
        dns = "none";
      };
    };
    programs = {
      ssh.startAgent = true;
      nm-applet.enable = true;
      dconf.enable = true;
    };
    services = {
      geoclue2 = {
        enable = true;
        geoProviderUrl = "https://beacondb.net/v1/geolocate";
        submissionUrl = "https://beacondb.net/v2/geosubmit";
        submissionNick = "geoclue";

        appConfig.gammastep = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };
  };
}
