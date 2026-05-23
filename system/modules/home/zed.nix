{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      alejandra
    ];
    extensions = [
      "nix"
    ];
    userSettings = {
      load_direnv = "shell_hook";

      lsp = {
        nixd = {
          formatting = {
            command = [ "alejandra" ];
          };
        };
      };
    };
  };
}
