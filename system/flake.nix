{
  description = "Flake de configuración de sistema NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs: let
      system = "x86_64-linux";
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      username = "mamp";
      host = "an515-58";
    in { 
      nixosConfigurations = {
        nixos-nitro = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit pkgs-unstable;
          };
          modules = [
            ./host/${host}/configuration.nix # cambiar host

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit pkgs-unstable;
              };
              home-manager.users.${username} = import ./host/${host}/home.nix; # cambiar host
            }
          ];
        };
      };
    };
}
