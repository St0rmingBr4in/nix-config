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
          ./config.nix
          ./media-pc.nix
          ./media-pc-hardware-configuration.nix
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
          ./config.nix
          ./hardware-configuration.nix
          homeManager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.st0rmingbr4in = import ./home.nix;
          }
        ];
      };
    };
  };
}
