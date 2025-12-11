{
  description = "Java development flake with Zulu21";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system;
      };
    in {
      
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          zulu21
          maven
        ];
        
        shellHook = ''
          export JAVA_HOME=${pkgs.zulu21.home or pkgs.zulu21}
          export M2_HOME=${pkgs.maven}
          echo "Entorno de Java preparado con Zulu 21 y Maven"
        '';
      };
    };
}