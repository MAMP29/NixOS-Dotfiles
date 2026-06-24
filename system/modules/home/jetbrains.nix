{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      android-studio
      jetbrains.idea
    ]
    ++ (with pkgs-unstable; [
      jetbrains.pycharm
    ]);
}
