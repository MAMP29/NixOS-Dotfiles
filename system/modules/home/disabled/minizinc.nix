{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    minizinc
    minizincide
  ];
}