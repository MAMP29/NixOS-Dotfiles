{
  description = "Flake de configuración de sistema NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.05";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, niri-flake, stylix, ... } @ inputs: let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      username = "mamp";
      host = "an515-58";
    in { 
      nixosConfigurations = {
        nixos-nitro = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit pkgs-unstable;
          };
          modules = [
            ./host/${host}/default.nix # cambiar host

          ];
        };
      };
    };
}
