{ config, pkgs, ... }:

{
  stylix.targets = {
    qt.enable = true;
    vscode.enable = true;
    kitty.enable = true;
    rofi.enable = true;
  };
}