{ config, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;   # QEMU con KVM
        swtpm.enable = true;       # Soporte TPM 2.0 (para Win11 y más)
        ovmf = {
          enable = true;           
          packages = [ pkgs.OVMFFull.fd ]; # Firmware UEFI completo
        };
      };
    };
    spiceUSBRedirection.enable = true; # Redirección de USB
  };

  programs.virt-manager.enable = true;
}