{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    minikube
    kubectl
  ];
}