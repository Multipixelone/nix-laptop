{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      # taken from https://github.com/Mic92/dotfiles/blob/549d1cf7d985964cf141119943f90d2a85b596b7/nixos/modules/nix-ld.nix
      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            alsa-lib
            at-spi2-atk
            at-spi2-core
            atk
            cairo
            cups
            curl
            dbus
            expat
            fontconfig
            freetype
            fuse3
            fuse
            gdk-pixbuf
            glib
            gtk3
            icu
            libGL
            libappindicator-gtk3
            libdrm
            libglvnd
            libnotify
            libpulseaudio
            libunwind
            libusb1
            libuuid
            libxkbcommon
            libxml2
            e2fsprogs
            mesa
            nspr
            nss
            openssl
            pango
            pipewire
            stdenv.cc.cc
            systemd
            vulkan-loader
            libX11
            libXScrnSaver
            libXcomposite
            libXcursor
            libXdamage
            libXext
            libXfixes
            libXi
            libXrandr
            libXrender
            libXtst
            libxcb
            libxkbfile
            libxshmfence
            zlib
          ];
        };
      };
    };
}
