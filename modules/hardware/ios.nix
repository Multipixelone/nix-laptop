{
  flake.modules = {
    nixos.pc =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          libimobiledevice
          ifuse
        ];
        services = {
          usbmuxd = {
            enable = true;
            package = pkgs.usbmuxd2;
          };
        };

      };
    homeManager.gui = {
    };
  };
}
