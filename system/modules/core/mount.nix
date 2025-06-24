{ config, lib, pkgs, ... }:

{
 # Para montaje automático de USBs
 services.udisks2.enable = true;
 services.gvfs.enable = true; # Para nemo  
}
