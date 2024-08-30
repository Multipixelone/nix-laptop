{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = true;
    config = {
      width = {fraction = 0.3;};
      hideIcons = false;
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        websearch
      ];
      extraCss = '''';
      extraConfigFiles = {
        "dictionary.ron".text = ''
          Config(
            prefix: "d",
          )
        '';
      };
    };
  };
}
