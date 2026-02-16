{
  configurations.nixos.zelda.module =
    { pkgs, ... }:
    {
      hardware = {
        firmware = [ pkgs.sof-firmware ];
        openrazer = {
          enable = true;
          users = [ "tunnel" ];
        };
      };

    };
}
