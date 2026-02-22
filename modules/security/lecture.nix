{
  flake.modules.nixos.base = {
    security = {
      # bee sudo lecture
      sudo-rs.configFile = ''
        Defaults lecture=always
        Defaults lecture_file = ${
          builtins.fetchurl {
            url = "https://gist.githubusercontent.com/willfindlay/e94cf20a8103caa762313cefa67410b5/raw/f80b4c4a376f18ff0b2475b57c6bf9a925c5fde0/sudoers.lecture";
            sha256 = "sha256:1150vava030sw9adc1fz1558a8s5mm75d2hk7wsph0sfg60mym1v";
          }
        }
      '';
    };
  };
}
