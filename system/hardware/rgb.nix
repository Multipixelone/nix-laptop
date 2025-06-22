{pkgs, ...}: {
  programs.coolercontrol.enable = true;
  hardware.i2c.enable = true;
  boot.kernelParams = ["acpi_enforce_resources=lax"];
  # hardware.openrazer.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb.overrideAttrs {
      version = "1.0";
      src = pkgs.fetchFromGitLab {
        owner = "CalcProgrammer1";
        repo = "OpenRGB";
        rev = "ce32b8801001992796dde69ce5a4b0f1f1e1d504";
        hash = "sha256-/DusVAfTYmWR6oiFAVKAENaqx5V2kwjgkGtFAVnGeRA=";
      };
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail "/usr/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
      '';
    };
  };
}
