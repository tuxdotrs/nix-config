{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/Wallpapers/new/sunset-pixel.png"
      ];

      wallpaper = [
        ", ~/Wallpapers/new/sunset-pixel.png"
      ];
    };
  };

  home.packages = with pkgs; [hyprpaper];
}
