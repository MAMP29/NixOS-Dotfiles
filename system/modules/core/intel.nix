{ lib, pkgs, config, ... }:
with lib; let
  cfg = config.drivers.intel;
in
{
  # 1. Definimos la opción para que el usuario la pueda activar o desactivar
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  # 2. Aplicamos la configuración SOLO si la opción está activa
  config = mkIf cfg.enable {
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}