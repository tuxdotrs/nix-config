{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/Wallpapers/mountain.jpg"
      ];

      wallpaper = [
        ", ~/Wallpapers/mountain.jpg"
      ];
    };
  };

  home.packages = with pkgs; [hyprpaper];
}
