{ lib, pkgs,  ... }:
with lib;
let
  defaultApps = {
    text = [ "helix.desktop" ];
    image = [ "org.gnome.eog.desktop" ];        # Eye of GNOME
    audio = [ "mpv.desktop" ];
    video = [ "mpv.desktop" ];                  # MPV para videos
    directory = [ "nemo.desktop" ];
    office = [ "libreoffice-writer.desktop" "libreoffice-calc.desktop" "libreoffice-impress.desktop" ];
    pdf = [ "org.gnome.Evince.desktop" ];
    terminal = [ "kitty.desktop" ];             # Kitty
    archive = [ "org.gnome.FileRoller.desktop" ];
    browser = [ "brave-browser.desktop" ];      # Brave
  };

  mimeMap = {
    text = [ "text/plain" ];
    image = [ "image/jpeg" "image/png" "image/gif" "image/webp" "image/svg+xml" ];
    audio = [ "audio/mpeg" "audio/ogg" "audio/wav" "audio/flac" ];
    video = [ "video/mp4" "video/x-matroska" "video/webm" ];
    directory = [ "inode/directory" ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    ];
    pdf = [ "application/pdf" ];
    archive = [ "application/zip" "application/x-rar" "application/x-7z-compressed" "application/x-tar" "application/gzip" ];
    browser = [ "text/html" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (
        mapAttrsToList (
          key: types: map (type: attrsets.nameValuePair type defaultApps."${key}") types
        ) mimeMap
      )
  );
in
{
  # Directorios XDG en inglés
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };

    configFile."mimeapps.list".force = true;

    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };

    userDirs = {
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
