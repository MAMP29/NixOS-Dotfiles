{
  description = "Entorno de desarrollo Python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pyproject-nix }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      # Carga la configuración desde pyproject.toml
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      python = pkgs.python313;

      # Construye el entorno de Python con las dependencias
      pythonEnv = python.withPackages (
        project.renderers.withPackages { inherit python; }
      );

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pythonEnv
        ];
      };
    };
}