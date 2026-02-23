{ config, ... }:
{
  flake.modules.nixos.laptop.imports = with config.flake.modules.nixos; [ pc ];
}
