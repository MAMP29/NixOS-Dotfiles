{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = [
      "hyprland"
      "gtk"
    ];
    extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.hyprlock = {};
}