{ inputs, ... }:
{
  import = [
    inputs.auto-cpufreq.nixosModules.default
  ];
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };
  services = {
    thermald.enable = true;
    tlp.enable = false;
    # # testing undervolting
    # undervolt = {
    #   enable = true;
    #   # analogioOffset = -10;
    #   coreOffset = -10;
    #   # gpuOffset = -10;
    # };
  };
}
