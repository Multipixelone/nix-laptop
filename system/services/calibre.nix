_: {
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    options = {
      calibreLibrary = "/home/tunnel/Calibre Library";
      enableBookUploading = true;
    };
  };
}
