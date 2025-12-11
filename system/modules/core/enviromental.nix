{ ... }:
{
  environment.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
    MOZ_ENABLE_WAYLAND="1";
    CLUTTER_BACKEND = "wayland,x11";
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland,x11";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}