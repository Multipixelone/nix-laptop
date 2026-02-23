{ pkgs, ... }:
{
  users.users.tunnel = {
    name = "tunnel";
    isNormalUser = true;
    home = "/home/tunnel";
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "dialout"
      "gamemode"
      "i2c"
      "input"
      "kvm"
      "libvirt"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
  };
}
