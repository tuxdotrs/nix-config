{pkgs, ...}: {
  imports = [
    ../../modules/home/desktop/awesome
    ../../modules/home/desktop/hyprland
    ../../modules/home/picom
    ../../modules/home/alacritty
    ../../modules/home/wezterm
    ../../modules/home/ghostty
    ../../modules/home/desktop/rofi
    ../../modules/home/barrier
    ../../modules/home/firefox
    ../../modules/home/brave
    ../../modules/home/vs-code
    ../../modules/home/mopidy
    ../../modules/home/thunderbird
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  home.stateVersion = "24.11";
}
