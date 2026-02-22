{
  inputs,
  ...
}:
{
  flake.modules.homeManager.gui = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      mangohud.enable = false;
      # these need IFD, so I disable
      firefox.enable = false;
      bottom.enable = false;
      starship.enable = false;
      fzf.enable = false;
      anki.enable = false;
    };
  };
}
