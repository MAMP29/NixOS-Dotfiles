{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["acpi_backlight=native"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl = { "vm.swappiness" = 10; }; # Menos uso de swap
  }
}