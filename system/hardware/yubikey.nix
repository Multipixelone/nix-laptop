{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    age-plugin-yubikey
  ];
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];
}
