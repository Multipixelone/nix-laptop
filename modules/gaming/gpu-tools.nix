{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        amdgpu_top
        vulkan-tools
        vulkan-loader
      ];
    };
}
