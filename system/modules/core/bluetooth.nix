{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot = false;
}
