{
  flake.modules = {
    nixos.pc =
      { pkgs, ... }:
      {
        services.udev.packages = with pkgs; [
          yubikey-personalization
          libu2f-host
        ];
      };
    homeManager.gui =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          yubikey-personalization
          yubikey-manager
          age-plugin-yubikey
        ];
      };
  };
}
