# FIXME https://github.com/NixOS/nixpkgs/issues/370185
{
  flake.modules.nixos.pc = {
    fileSystems."/media/alexandria" = {
      device = "192.168.6.9:/volume1/homes/tunnel";
      options = [
        "nfsvers=4.1"
        "x-systemd.automount"
        "noauto"
      ];

      fsType = "nfs";

    };
    boot.supportedFilesystems = [ "nfs" ];
  };
}
