{pkgs, ...}: let
  # xdg-utils as a runtime dependency: https://github.com/NixOS/nixpkgs/pull/181171
  # see on postFixup instead of postInstall: https://github.com/NixOS/nixpkgs/pull/285233
  xdg-mimeo = pkgs.xdg-utils.overrideAttrs (_old: {
    postFixup = ''
      cp ${pkgs.mimeo}/bin/mimeo $out/bin/xdg-open
    '';
  });
in {
  home.packages = [
    pkgs.mimeo
    pkgs.nemo
    pkgs.ark
    xdg-mimeo
  ];
}
