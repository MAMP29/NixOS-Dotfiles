{ config, pkgs, ... }:

{
   users.users.mamp = {
   isNormalUser = true;
   extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
    "libvirtd"
    "libvirt-qemu"
    "kvm"
    ]; 
   shell = pkgs.zsh;
   packages = with pkgs; [
     tree
     tidal-hifi
   ];
 };
}