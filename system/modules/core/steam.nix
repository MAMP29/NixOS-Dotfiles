{ config, pkgs, ... }:

let
  # Gracias a Silk por esta build para gamescope: https://codeberg.org/Silk/silkos
  gamescope-git = pkgs.gamescope.overrideAttrs (old: {
    version = "unstable-20251206105151-9416ca";
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or []) ++ [ "-fno-fast-math" ];

    src = pkgs.fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      rev = "1164ac17849b0c50a39d286e8feda877d82bb59a";
      hash = "sha256-hPuAy5ehT8Njd6HY4qa5/ZASZ7jN+AdCiALpK+RUDyM=";
      fetchSubmodules = true;
    };

    # Allows gamescope --version match with this
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/meson.build \
        --replace-fail "'git', 'describe', '--always', '--tags', '--dirty=+'" "'echo', '1164ac17849b0c50a39d286e8feda877d82bb59a'"
    '';
  });
in
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extest.enable = true;
      protontricks.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      gamescopeSession = {
          enable = true;
          steamArgs = [
            "-pipewire-dmabuf"
          ];
      };
    };

    gamescope = {
      enable = true;
      package = gamescope-git;
      capSysNice = false;
      args = [
        "--expose-wayland"
        "--fullscreen"
      ];
    };
  };
}