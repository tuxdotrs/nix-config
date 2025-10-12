{pkgs, ...}: {
  imports = [
    ../../modules/home/desktop/awesome
    ../../modules/home/desktop/hyprland
    ../../modules/home/picom
    ../../modules/home/wezterm
    ../../modules/home/desktop/rofi
    ../../modules/home/firefox
    ../../modules/home/brave
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 28;
  };

  home.stateVersion = "24.11";
}
