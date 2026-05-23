{
  config,
  inputs,
  pkgs,
  username,
  host,
  pkgs-unstable,
  ...
}:

let
  linuxUwUSense = pkgs.stdenv.mkDerivation {
    name = "modulo-linux-uwu-sense";

    src = pkgs.fetchFromGitHub {
      owner = "0x7375646F";
      repo = "Linuwu-Sense";
      rev = "73a25ec243a44ba2b1703e8d0a76fa2735062506";
      hash = "sha256-4v+xDrJ+lZIyV/wcRsfMbw933u+yS8uP8TEUVXSpdjA=";
    };
    nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

    buildPhase = ''
      make -C ${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build M=$(pwd) modules
    '';

    installPhase = ''
      mkdir -p $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/extra
      cp src/linuwu_sense.ko $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/extra/
    '';
  };
in
{
  imports = [
    # Include the results of the hardware scan.
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
    kernelParams = [ "acpi_backlight=native" ];

    extraModulePackages = [ linuxUwUSense ];
    kernelModules = [ "linuwu_sense" ];
    blacklistedKernelModules = [ "acer_wmi" ];
    extraModprobeConfig = ''
      options linuwu_sense nitro_v4=1
    '';
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
  ];
}
