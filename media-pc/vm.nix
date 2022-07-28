{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./media-pc.nix
    ./media-pc-hardware-configuration.nix
  ];

  networking = {
    hostName = "media-pc-vm";
  };
}
