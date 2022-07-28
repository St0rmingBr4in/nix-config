{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./media-pc.nix
    ./media-pc-hardware-configuration.nix
  ];
}
