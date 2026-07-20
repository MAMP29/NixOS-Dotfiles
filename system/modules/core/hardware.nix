{ config, pkgs, ... }:

{
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    enableRedistributableFirmware = true;
    nvidia-container-toolkit.enable = true;
  };
}
