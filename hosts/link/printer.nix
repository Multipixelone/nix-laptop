{
  pkgs,
  lib,
  ...
}: {
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_MG3222";
        location = "Office";
        deviceUri = "usb://Canon/MG3200%20series?serial=3131AC&interface=1";
        model = "gutenprint.${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://bjc-PIXMA-MG3222/expert";
        description = "Office Printer";
      }
    ];
    ensureDefaultPrinter = "Canon_MG3222";
  };
  services = {
    printing = {
      enable = true;
      drivers = [
        # add drivers for Canon MG3222
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      listenAddresses = ["*:631"];
      allowFrom = ["all"];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
