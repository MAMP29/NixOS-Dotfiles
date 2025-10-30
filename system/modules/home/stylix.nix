{ config, pkgs, ... }:

{
  stylix.opacity.terminal = 0.9;
  stylix.targets = {
    qt.enable = true;
    vscode.enable = true;
    kitty.enable = true;
    rofi.enable = true;
  };
}