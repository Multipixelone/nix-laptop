{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--disable-gpu-driver-bug-workarounds"
          "--enable-features=WaylandWindowDecorations"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"
          "--ozone-platform=wayland"
          "--ozone-platform-hint=auto"
          "--enable-features=WaylandWindowDecorations,CanvasOopRasterization,Vulkan,UseSkiaRenderer"
          "--disable-domain-reliability"
          "--no-first-run"
          "--enable-features=WebUIDarkMode"
          "--use-system-theme"
        ];
        extensions = [
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # Ublock
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsorblock
          { id = "kchgllkpfcggmdaoopkhlkbcokngahlg"; } # DF Tube
          #      {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";} # Privacy Badger
          #      {id = "likgccmbimhjbgkjambclfkhldnlhbnn";} # Yomitan
          #      {id = "jinjaccalgkegednnccohejagnlnfdag";} # Violentmonkey
          #      {
          #        # ttu-whispersync
          #        id = "odlameecjipmbmbejkplpemijjgpljce"; # placeholder, must be 32 chars
          #        version = "1.0.12";
          #        crxPath = pkgs.fetchurl {
          #          url = "https://github.com/Renji-XD/ttu-whispersync/releases/download/1.0.12/dist.crx";
          #          sha256 = "1fg0l2xf3l4i9vqk2lww88bp8ik8jkwb0gfmclkwr9h6qnw4rk4m";
          #        };
          #      }
        ];
      };
    };
}
