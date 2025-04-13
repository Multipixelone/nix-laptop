{
  programs = {
    ssh.startAgent = true;
    nm-applet.enable = true;
    dconf.enable = true;
  };
  services = {
    geoclue2.enable = true;
  };
}
