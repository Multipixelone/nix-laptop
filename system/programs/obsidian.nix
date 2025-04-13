{
  nixpkgs = {
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-28.2.10"
    ];
  };
}
