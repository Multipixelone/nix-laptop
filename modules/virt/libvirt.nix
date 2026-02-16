{ inputs, config, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.quadlet-nix.nixosModules.quadlet ];
      virtualisation = {
        quadlet.enable = true;
        containers.storage.settings.storage = {
          driver = "overlay";
        };
        libvirtd = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "shutdown";
          qemu = {
            package = pkgs.qemu_kvm;
            # runAsRoot = true;
            swtpm.enable = true;
          };
        };
      };
    };
}
