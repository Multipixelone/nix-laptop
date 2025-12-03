{ lib, pkgs, ... }:
{
  programs.looking-glass-client = {
    enable = true;
    settings = {
      app.shmFile = "/dev/kvmfr0";
      app.allowDMA = "yes";
      input.escapeKey = 119;
      input.rawMouse = "yes";
      spice.enable = "yes";
      win.autoScreensaver = "yes";
      win.fullScreen = "yes";
      win.jitRender = "yes";
      win.quickSplash = "yes";
      wayland.fractionScale = "no";
    };
  };
  home.packages = [
    (pkgs.writeScriptBin "win" ''
      #!${lib.getExe pkgs.fish}
      #!/usr/bin/env fish
      set VM_NAME "win11"
      set STATE (virsh --connect qemu:///system domstate $VM_NAME 2>/dev/null)
      if string match -q "running*" $STATE
          echo "$VM_NAME is already running."
      else
          echo "Starting $VM_NAME..."
          virsh --connect qemu:///system start $VM_NAME
          sleep 3
      end

      set -e WAYLAND_DISPLAY
      looking-glass-client &
      exit
    '')
    (pkgs.makeDesktopItem {
      name = "windows";
      desktopName = "Windows VM";
      exec = "win";
      terminal = false;
      type = "Application";
      icon = "windows95";
    })
  ];
}
