{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      # console readability
      console = {
        earlySetup = true;
        font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        packages = with pkgs; [ terminus_font ];
        keyMap = "us";
      };

    };
}
