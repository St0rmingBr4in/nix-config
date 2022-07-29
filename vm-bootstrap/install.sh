#!/bin/sh -e

packer_http=$(cat .packer_http)

# Initial formatting using Ansible
nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:St0rmingBr4in/nix-config/master#partition-disk

# Setup system
nixos-generate-config --root /mnt

### Install ###
nixos-install 

### Cleanup ###
curl "$packer_http/postinstall.sh" | nixos-enter
