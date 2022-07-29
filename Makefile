BUILDERS ?= "virtualbox-iso.virtualbox"

all: build

build: nixos.pkr.hcl
	packer build -var-file="nixos.auto.pkvars.hcl" -var arch=x86_64 --only=${BUILDERS} $<

.PHONY: all build
