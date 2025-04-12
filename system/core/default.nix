{inputs, lib, ...}:
# default configuration shared by all hosts
{
  imports = [
    ./security.nix
    ./users.nix
    ../nix
    ../programs/fish.nix
  ];
  hardware.enableRedistributableFirmware = true;

  documentation.dev.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  # don't touch this
  system.stateVersion = lib.mkDefault "23.11";

  time.timeZone = lib.mkDefault "America/New_York";
}
