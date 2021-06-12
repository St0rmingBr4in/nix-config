{
  inputs = rec {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-21.05"
    };
    homeManager = {
      url = "github:nix-community/home-manager/release-21.05"
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixosHardware = {
      url = "github:nix-community/nixos-hardware"
    };
  };
  
  outputs = { self, nixpkgs, homeManager, nixosHardware }: {
    nixConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./config.nix ];
      };
    };

    homeManagerConfigurations = {
      st0rmingbr4in = homeManager.lib.homeManagerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [ ./home.nix ];
          nixpkgs = {
            config = { allowUnfree = true; };
          };
        };
        system = "x86_64-linux";
        homeDirectory = "/home/st0rmingbr4in";
        username = "st0rmingbr4in";
      };
    };
  };
}
