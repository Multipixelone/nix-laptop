{
  inputs,
  pkgs,
}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      ipafont
      minecraftia

      # windows fonts
      corefonts
      vistafonts

      # macos fonts
      inputs.apple-fonts.packages.${pkgs.system}.ny
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
      inputs.apple-fonts.packages.${pkgs.system}.sf-compact
      inputs.apple-fonts.packages.${pkgs.system}.sf-mono

      # my fonts
      nerd-fonts.iosevka
      (pkgs.callPackage ../pkgs/pragmata/default.nix {})
    ];
    fontconfig = {
      defaultFonts = {
        # ipa gothic required for cjk support
        serif = ["PragmataPro Liga" "IPAGothic"];
        sansSerif = ["PragmataPro Liga" "IPAGothic"];
        monospace = ["PragmataPro Mono Liga" "IPAGothic"];
        emoji = ["Apple Color Emoji"];
      };
    };
  };
}
