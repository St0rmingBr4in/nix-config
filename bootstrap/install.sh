#!/bin/sh -e

# Initial formatting using Ansible
ansible-playbook

# Setup system
nixos-generate-config --root /mnt

### Install ###
nixos-install 
