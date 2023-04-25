{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./powerhouse.nix
    ./powerhouse-hardware-configuration.nix
  ];
}
