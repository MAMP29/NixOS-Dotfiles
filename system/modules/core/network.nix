{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos-nitro"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
   
    
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };
}