{
  description = "My NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
  in
  {
    nixosModules = import ./modules;
    nixosConfigurations = {
        shodan = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
                inherit inputs outputs;
            };
            modules = [
              ./hosts/shodan
          ];
      };
    };
  };

}