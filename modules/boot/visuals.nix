{
  flake.modules.nixos = {
    base = {
      boot.kernelParams = [
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "systemd.show_status=error"
        "boot.shell_on_fail"
      ];
    };
    pc = {
      boot.kernelParams = [ "quiet" ];
      boot.plymouth = {
        enable = true;
        # theme = "nixos-bgrt";
        # themePackages = with pkgs; [
        #   nixos-bgrt-plymouth
        # ];
      };
    };
  };
}
