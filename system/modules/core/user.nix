{ config, username, pkgs, ... }:

{
   users.users.${username} = {
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
   ];
 };
}