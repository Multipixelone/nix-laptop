{
  services = {
    ratbagd.enable = true;
    # don't suspend mouse
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/control", ATTR{power/control}="on"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/autosuspend", ATTR{power/autosuspend}="0"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/autosuspend_delay_ms", ATTR{power/autosuspend_delay_ms}="0"
    '';
  };
}
