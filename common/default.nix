{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./common-configuration.nix
    ./common-hardware-configuration.nix
  ];
}
