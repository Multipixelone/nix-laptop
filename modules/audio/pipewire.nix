{ inputs, ... }:
{
  flake.modules = {
    nixos.base = {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
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
    };
    nixos.pc = {
      musnix.enable = true;
      security.rtkit.enable = true;
      services.pipewire = {
        pulse.enable = true;
        jack.enable = true;
      };
      imports = [
        inputs.musnix.nixosModules.musnix
      ];
    };
  };
}
