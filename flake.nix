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
    packages.x86_64-linux.partition-disk =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "partition-disk";
        src = self;
        baseInputs = [ ansible curl ];
        buildPhase = "echo done";
        prePatch = ''export HOME=$NIX_BUILD_TOP'';
        installPhase = "${curl}/bin/curl -vvvv https://galaxy.ansible.com/api/
                        ${ansible}/bin/ansible-galaxy collection install davidban77.gns3";
      };
    apps.x86_64-linux.partition-disk = {
      type = "app";
      program = "${self.packages.x86_64-linux.partition-disk}/bin/install.sh";
    };
  };
}
