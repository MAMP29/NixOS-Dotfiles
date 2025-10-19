{
  description = "Flake de configuración de sistema NixOS";

  # Ya lo puse en un modulo, quitar
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

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
      host = "nixide";
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
            ./configuration.nix # cambiar host

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit pkgs-unstable;
              };
              home-manager.users.${username} = import ./home.nix; # cambiar host
            }
          ];
        };
      };
    };
}
