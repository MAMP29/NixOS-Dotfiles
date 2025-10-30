{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    settings = {
      font_size = 12;
      bold_font = "none";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.9";
      confirm_os_window_close = -1;
    };
  };
}
