{
  flake.modules.homeManager.desktop = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      systemd.enable = true;

      settings = {
        confirm-close-surface = false;
        gtk-titlebar = false;
        window-padding-x = 10;
        window-padding-y = 10;
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font";
        theme = "poimandres";
        custom-shader = "shaders/cursor_warp.glsl";
        custom-shader-animation = "always";
      };

      themes = {
        poimandres = {
          background = "#0f0f0f";
          foreground = "#a6accd";
          cursor-color = "#f2eacf";
          selection-background = "#1a1a1a";
          selection-foreground = "#f1f1f1";
          palette = [
            "0=#252b37"
            "1=#d0679d"
            "2=#5de4c7"
            "3=#fffac2"
            "4=#89ddff"
            "5=#fae4fc"
            "6=#add7ff"
            "7=#ffffff"
            "8=#a6accd"
            "9=#d0679d"
            "10=#5de4c7"
            "11=#fffac2"
            "12=#add7ff"
            "13=#89ddff"
            "14=#fcc5e9"
            "15=#ffffff"
          ];
        };
      };
    };
  };
}
