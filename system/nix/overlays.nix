{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays =
    let
      pins = import ../../npins;
    in
    [
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
          patches = [ ];
          postPatch = ''
            patchShebangs scripts/build-udev-rules.sh
            # substituteInPlace OpenRGB.pro \
              # --replace-fail "/etc/systemd/system" "$out/etc/systemd/system"
            substituteInPlace scripts/build-udev-rules.sh \
              --replace-fail "/usr/bin/env" "${lib.getExe' pkgs.coreutils "env"}" \
              --replace-fail chmod "${lib.getExe' pkgs.coreutils "chmod"}"
          '';
        };
      })
      # (self: super: {
      #   snapcast = super.snapcast.overrideAttrs {
      #     version = pins.snapcast.revision;
      #     src = pins.snapcast;
      #     buildInputs = super.snapcast.buildInputs ++ [
      #       pkgs.pipewire
      #     ];
      #     cmakeFlags = [
      #       (lib.cmakeBool "BUILD_WITH_PIPEWIRE" true)
      #     ];
      #   };
      # })
      (self: super: {
        vintagestory = super.vintagestory.overrideAttrs rec {
          version = "1.21.6";
          src = pkgs.fetchurl {
            url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
            hash = "sha256-LkiL/8W9MKpmJxtK+s5JvqhOza0BLap1SsaDvbLYR0c=";
          };
        };
      })
      (self: super: {
        # temporary until https://github.com/NixOS/nixpkgs/pull/446141 is merged
        sunshine = super.sunshine.overrideAttrs (
          final: prev: {
            inherit (pins.sunshine) version;
            src = pins.sunshine;
            cmakeFlags = prev.cmakeFlags ++ [
              (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
            ];

            ui = pkgs.buildNpmPackage {
              inherit (final) version src;
              pname = "sunshine-ui";
              npmDepsHash = "sha256-KUzJLwdZhs3BFoWTGWhUy1sxQgY8OUrgBtumnHnMjPI=";

              # use generated package-lock.json as upstream does not provide one
              postPatch = ''
                cp ${./package-lock.json} ./package-lock.json
              '';

              installPhase = ''
                runHook preInstall

                mkdir -p "$out"
                cp -a . "$out"/

                runHook postInstall
              '';
            };

          }
        );
      })
    ];
}
