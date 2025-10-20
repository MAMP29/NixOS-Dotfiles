{ config, pkgs, ... }:

{
  # Necesita el .deb original para funcionar, descargalo y renombralo a: CiscoPacketTracer822_amd64_signed.deb, luego se ejecuta el comando:
  # nix-store --add-fixed sha256 CiscoPacketTracer822_Ubuntu_64bit.deb
  home.packages = with pkgs; [
    ciscoPacketTracer8
  ];
}