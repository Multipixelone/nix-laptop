{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/media.nix
  ];
  environment.systemPackages = with pkgs; [
    # TODO fix latency flex
    # inputs.chaotic.packages.${pkgs.system}.latencyflex-vulkan
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.nix-gaming.packages.${pkgs.system}.winetricks-git
    xdg-utils
    pyprland
    libsmbios
    papirus-icon-theme
    papirus-folders
    arc-theme
    libsForQt5.kio
    libsForQt5.kio-extras
    libimobiledevice
    ifuse
    inputs.agenix.packages.${pkgs.system}.default
    # inputs.qtscrob.packages.${pkgs.system}.default
    (callPackage ../pkgs/spotify2musicbrainz/default.nix {})
    inputs.khinsider.packages.${pkgs.system}.default
    inputs.humble-key.packages.${pkgs.system}.default
    pulseaudioFull
    (inputs.geospatial.packages.${pkgs.system}.qgis.override {
      extraPythonPackages = ps: [
        ps.protobuf
        ps.pyarrow
        ps.ortools
        ps.absl-py
        ps.immutabledict
      ];
    })
    # (inputs.geospatial.packages.${pkgs.system}.qgis.override {
    #   extraPythonPackages = ps: [ps.pandas ps.numpy ps.scipy ps.pandas ps.charset-normalizer ps.click-plugins ps.click ps.certifi ps.cligj ps.colorama ps.fiona ps.pyproj ps.pytz ps.requests ps.rtree ps.setuptools ps.shapely ps.six ps.tzdata ps.zipp ps.attrs ps.dateutil ps.python-dateutil ps.idna ps.importlib-metadata ps.pyaml ps.urllib3 ps.packaging ps.cython ps.ortools ps.numexpr ps.py-cpuinfo ps.tables ps.fastparquet];
    # })
    # TODO (inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pkgs.callPackage ../pkgs/aequilibrae/default.nix {inherit inputs;})
    # inputs.geospatial.packages.${pkgs.system}.libspatialite
  ];
  # testing different schedulers
  # chaotic.scx = {
  #   enable = true;
  #   scheduler = "scx_lavd";
  #   # scheduler = "scx_rustland";
  # };
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    fwupd.enable = true;
    geoclue2.enable = true;
    psd.enable = true;
    btrfs.autoScrub.enable = true;
    printing.enable = true;
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };
  programs = {
    wireshark.enable = true;
    virt-manager.enable = true;
    _1password-gui.enable = true;
  };
  # Wayland Stuff
  # Audio + Music
  # Required for Obsidian
  nixpkgs = {
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-28.2.10"
    ];
    overlays = [
      inputs.nur.overlay
      (_final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
    ];
  };
  # Fonts
  # Virt
}
