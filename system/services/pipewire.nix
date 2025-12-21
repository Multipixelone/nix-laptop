{ inputs, ... }:
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.musnix.nixosModules.musnix
  ];
  musnix.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    lowLatency.enable = false;
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "dualsense" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "*Sony_Interactive_Entertainment_Wireless_Controller*";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "Wireless Controller";
              };
            };
          }
        ];
      };
    };
  };
}
