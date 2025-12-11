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
        overlays = [ self.overlays.default ];
      };
    in {
      overlays.default = final: prev: {
        # Override gradle para usar zulu21 específicamente
        gradle = prev.gradle_8.override { 
          java = prev.zulu21;
        };
        
      };
      
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          zulu21
          gradle  # Este ahora usa zulu21 gracias al overlay
        ];
        
        shellHook = ''
          export JAVA_HOME=${pkgs.zulu21}
          echo "Entorno de Java preparado con Zulu 21"
        '';
      };
    };
}