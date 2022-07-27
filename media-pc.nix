{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (retroarch.override { cores = with libretro; [ genesis-plus-gx snes9x beetle-psx-hw ]; })
    libretro.genesis-plus-gx
    libretro.snes9x
    libretro.beetle-psx-hw
  ];
}
