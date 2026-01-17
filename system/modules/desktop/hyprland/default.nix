{ inputs, ... }:

{
  imports = [
    ./system.nix
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
  ];
}