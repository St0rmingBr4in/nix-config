{
  inputs = rec {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-22.05";
    };
    homeManager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixosHardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };
  
  outputs = { self, nixpkgs, homeManager, nixosHardware }: {
    nixosConfigurations = {
      media-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common
          ./media-pc
          homeManager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.st0rmingbr4in = import ./home.nix;
          }
        ];
      };
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common
          homeManager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.st0rmingbr4in = import ./home.nix;
          }
        ];
      };
    };
    devShells.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      let
          ansibleCollectionPath = pkgs.callPackage ./ansible-collections.nix {} pkgs.ansible {
              "containers-podman" = {
                  version = "1.9.3";
                  sha256 = "sha256:1vjsm7696fp9av7708h05zjjdil7gwcqiv6mrz7vzmnnwdnqshp7";
              };
          };
      in
      # we make an fhs to make easier portable playbook execution, which assumes #!/bin/sh for script commands
      (pkgs.buildFHSUserEnv {
        name = "ansiblenv";
        targetPkgs = pkgs: with pkgs; [
            zsh
            (python39.withPackages (p: with p; [ pexpect ansible jmespath ]))
        ];
        runScript = ''
          ${pkgs.zsh}/bin/zsh
        '';
        profile = ''
          export ANSIBLE_COLLECTIONS_PATHS="${ansibleCollectionPath}"
          export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
          export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
          export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
        '';
      }).env;
    packages.x86_64-linux.partition-disk =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "partition-disk";
        src = self;
        baseInputs = [ ansible curl ];
        buildPhase = "echo done";
        prePatch = ''export HOME=$NIX_BUILD_TOP''; # Needed for ansible to work
        installPhase = "${curl}/bin/curl -vvvv https://galaxy.ansible.com/api/
                        ${ansible}/bin/ansible-galaxy collection install davidban77.gns3";
      };
    apps.x86_64-linux.partition-disk = {
      type = "app";
      program = "${self.packages.x86_64-linux.partition-disk}/bin/install.sh";
    };
  };
}
