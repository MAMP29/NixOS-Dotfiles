{ config, lib,  pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
   "modesetting"
   "nvidia"
  ];
  
  hardware.nvidia.open = false;  # see the note above

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
