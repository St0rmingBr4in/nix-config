{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./k3s-6.nix
    ./k3s-6-hardware-configuration.nix
  ];
}
