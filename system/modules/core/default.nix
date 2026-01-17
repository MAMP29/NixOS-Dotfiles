{ inputs, ... }:

{
  imports = [
    ./boot.nix
    ./containers.nix
    ./enviromental.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware.nix
    ./network.nix
    ./nvidia.nix
    ./packages.nix
    ./qemu.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
  ];
}
