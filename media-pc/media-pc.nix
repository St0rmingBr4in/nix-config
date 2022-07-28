{ config, pkgs, ... }:

{
  networking = {
    hostName = "media-pc";
  };
  environment.systemPackages = with pkgs; [
    (retroarch.override { cores = with libretro; [ genesis-plus-gx snes9x beetle-psx-hw ]; })
    libretro.genesis-plus-gx
    libretro.snes9x
    libretro.beetle-psx-hw
  ];

  # bigger tty fonts
  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
