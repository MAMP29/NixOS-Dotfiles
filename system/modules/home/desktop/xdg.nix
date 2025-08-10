{ config, pkgs, ... }:

{
  # Directorios XDG en inglés
  xdg.userDirs = {
    enable = true;
    createDirectories = true; # Crea los directorios si no existen
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
  };

  # Persistencia para estos directorios

 # home.persistence."/persist/home/${config.home.username}" = {
 #   directories = [
 #     "Desktop"
 #     "Documents"
 #     "Downloads"
 #     "Music"
 #     "Pictures"
 #     "Videos"
 #     "Public"
 #     "Templates"
 #   ];
 #   allowOther = true;
 # };
}
