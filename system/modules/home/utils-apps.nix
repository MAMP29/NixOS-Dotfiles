{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  programs = {
    btop = {
      enable = true;
      package = pkgs.btop.override {
        cudaSupport = true;
      };
    };
    bat.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.packages =
    with pkgs;
    [

      # Navegador
      brave

      libnotify

      gnome-calculator
      obs-studio
      libreoffice-fresh
      gnome-clocks
      upscaler
      switcheroo
      handbrake
      file-roller
      eog
      gnome-disk-utility
      nemo-with-extensions
      pavucontrol
      telegram-desktop
      #tidal-hifi
      evince
      polkit_gnome # Polkit
      zotero

      # Herramientas de Desarrollo y CLI de Usuario
      ripgrep
      tree
      code-cursor
    ]
    ++ (with pkgs-unstable; [
      mission-center
      nvme-cli
      eza
    ]);
}
