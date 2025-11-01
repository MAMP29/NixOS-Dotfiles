{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
      };
    };
  };
}
