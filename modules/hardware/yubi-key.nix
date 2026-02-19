{
  flake.modules =
    { pkgs, ... }:
    {
      nixos.pc = {
        services.udev.packages = with pkgs; [
          yubikey-personalization
          libu2f-host
        ];
      };
      home.gui = {
        home.packages = with pkgs; [
          yubikey-personalization
          yubikey-manager
          age-plugin-yubikey
        ];
      };
    };
}
