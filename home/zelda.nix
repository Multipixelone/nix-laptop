{ ... }:
{
  imports = [
    ./desktop.nix
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = GDK_SCALE,2
  '';
  programs.looking-glass-client = {
    enable = true;
    settings = {
      app.shmFile = "/dev/kvmfr0";
      input.escapeKey = 119;
      input.rawMouse = "yes";
      spice.enable = "yes";
      win.autoScreensaver = "yes";
      win.fullScreen = "yes";
      win.jitRender = "yes";
      win.quickSplash = "yes";
    };
  };
}
