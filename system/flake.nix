{
  description = "Flake de configuración de sistema NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: let
      system = "x86_64-linux";
      username = "mamp"; 
    in { 
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          SpecialArgs = {
            inherit inputs;
            inherit username;
          };
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };
      };
    };
}
