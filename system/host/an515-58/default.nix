{ config, inputs, pkgs, username, host, pkgs-unstable, ... }: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/core
      ./../../modules/desktop/hyprland # Recuerda deshabilitar a nivel de home al momento de cambiar de escritorio
    ];

  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
  };

  boot = {
    kernelParams = ["acpi_backlight=native"];
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
  ];
}
