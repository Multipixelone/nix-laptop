{
  self,
  lib,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "apple-emoji"
    ];
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
      self.packages.${pkgs.system}.pragmata
      self.packages.${pkgs.system}.apple-emoji
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
