_: {
  services.calibre-web = {
    enable = true;
    user = "tunnel";
    group = "users";
    openFirewall = true;
    options = {
      calibreLibrary = "/home/tunnel/Calibre Library";
      enableBookUploading = true;
    };
  };
}
