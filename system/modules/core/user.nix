{ config, inputs, host, username, pkgs, pkgs-unstable, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs host username pkgs-unstable;
    };
    users.${username} = {
      imports = [ ./../home ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
  };

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
  packages = [ ];
 };
}
