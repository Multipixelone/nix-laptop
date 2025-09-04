{inputs, ...}: {
  nixpkgs.overlays = let
    pins = import ../../npins;
  in [
    # (self: super: {
    #   # use Furglitch fork
    #   mo2installer = inputs.nix-gaming.packages.${super.system}.mo2installer.overrideAttrs {
    #     version = pins.modorganizer2-linux-installer.version;
    #     src = pins.modorganizer2-linux-installer;
    #   };
    # })
    (self: super: {
      openrgb = super.openrgb.overrideAttrs {
        version = pins.OpenRGB.revision;
        src = pins.OpenRGB;
        postPatch = ''
          patchShebangs scripts/build-udev-rules.sh
          substituteInPlace scripts/build-udev-rules.sh \
            --replace-fail "/usr/bin/env chmod" "${self.coreutils}/bin/chmod"
        '';
      };
    })
    # (self: super: {
    #   # temporary until there's a new release that contains https://github.com/LizardByte/Sunshine/pull/3783
    #   sunshine = super.sunshine.overrideAttrs {
    #     inherit (pins.sunshine) version;
    #     src = pins.sunshine;

    #     # they changed the name of the .desktop file so I just copied both of the sections and hard coded the new .desktop file name
    #     postPatch = ''
    #       # remove upstream dependency on systemd and udev
    #       substituteInPlace cmake/packaging/linux.cmake \
    #         --replace-fail 'find_package(Systemd)' "" \
    #         --replace-fail 'find_package(Udev)' ""

    #       # don't look for npm since we build webui separately
    #       substituteInPlace cmake/targets/common.cmake \
    #         --replace-fail 'find_program(NPM npm REQUIRED)' ""

    #       substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
    #         --subst-var-by PROJECT_NAME 'Sunshine' \
    #         --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
    #         --subst-var-by SUNSHINE_DESKTOP_ICON 'sunshine' \
    #         --subst-var-by CMAKE_INSTALL_FULL_DATAROOTDIR "$out/share" \
    #         --replace-fail '/usr/bin/env systemctl start --u sunshine' 'sunshine'

    #       substituteInPlace packaging/linux/sunshine.service.in \
    #         --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
    #         --subst-var-by SUNSHINE_EXECUTABLE_PATH $out/bin/sunshine \
    #         --replace-fail '/bin/sleep' '${self.lib.getExe' self.coreutils "sleep"}'
    #     '';

    #     postInstall = ''
    #       install -Dm644 ../packaging/linux/dev.lizardbyte.app.Sunshine.desktop $out/share/applications/dev.lizardbyte.app.Sunshine.desktop
    #     '';
    #   };
    # })
  ];
}
