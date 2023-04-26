BUILDERS ?= "virtualbox-iso.virtualbox"

all: build

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

switch:
	$(call check_defined, NIXOS_SYSTEM_CONFIG_NAME)
	sudo nixos-rebuild switch --refresh --flake "github:St0rmingBr4in/nix-config/master#${NIXOS_SYSTEM_CONFIG_NAME}" --no-write-lock-file

boot:
	$(call check_defined, NIXOS_SYSTEM_CONFIG_NAME)
	sudo nixos-rebuild boot --refresh --flake "github:St0rmingBr4in/nix-config/master#${NIXOS_SYSTEM_CONFIG_NAME}" --no-write-lock-file


build: nixos.pkr.hcl
	packer build -var-file="nixos.auto.pkvars.hcl" -var arch=x86_64 --only=${BUILDERS} $<

.PHONY: all build switch boot
