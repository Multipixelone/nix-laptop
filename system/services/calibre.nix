_: {
  services.calibre-web = {
    enable = true;
    user = "tunnel";
    group = "users";
    listen.ip = "0.0.0.0";
    openFirewall = true;
    options = {
      calibreLibrary = "/home/tunnel/Calibre Library";
      enableBookUploading = true;
    };
  };
}
