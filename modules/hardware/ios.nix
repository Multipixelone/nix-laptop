{
  flake.modules =
    { pkgs, ... }:
    {
      nixos.pc = {
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
