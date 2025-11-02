{ config, pkgs, ... }: 

{
  services = {
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    openssh.enable = true;
    fstrim.enable = true; # Activa TRIM para el nvme
    gvfs.enable = true; # Para nemo, montaje USB y mas
    thermald.enable = true;
    udisks2.enable = true;
    blueman.enable = true; # Bluetooth Support
    xserver.enable = true;

    # Para monitorear los SSD
    smartd = {
      enable = true;
      autodetect = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    gnome.gnome-keyring.enable = true;
  };
}