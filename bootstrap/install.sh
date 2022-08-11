#!/bin/sh -e

packer_http=$(cat .packer_http)

# Initial formatting using Ansible
ansible-playbook

# Setup system
nixos-generate-config --root /mnt

### Install ###
nixos-install 

### Cleanup ###
curl "$packer_http/postinstall.sh" | nixos-enter
