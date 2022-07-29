{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./default.nix
  ];

  networking = {
    hostName = "media-pc-vm";
  };
}
