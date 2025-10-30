{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      bold_font = "none";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.9";
      confirm_os_window_close = -1;
    };
  };
}
