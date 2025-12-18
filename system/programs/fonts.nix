{
  self,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
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
      vista-fonts

      # macos fonts
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-compact
      inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
      inputs.apple-emoji.packages.${pkgs.stdenv.hostPlatform.system}.default

      # my fonts
      nerd-fonts.iosevka
      self.packages.${pkgs.stdenv.hostPlatform.system}.pragmata
    ];
    fontconfig = {
      defaultFonts = {
        # ipa gothic required for cjk support
        serif = [
          "PragmataPro Liga"
          "IPAGothic"
        ];
        sansSerif = [
          "PragmataPro Liga"
          "IPAGothic"
        ];
        monospace = [
          "PragmataPro Mono Liga"
          "IPAGothic"
        ];
        emoji = [ "Apple Color Emoji" ];
      };
    };
  };
}
