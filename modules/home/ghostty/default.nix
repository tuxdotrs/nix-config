{pkgs, ...}: {
  home.file = {
    ".config/ghostty/config" = {
      text = ''
        confirm-close-surface = false
        gtk-titlebar = false
        window-padding-x = 10
        window-padding-y = 10
        background-opacity = 0.9
        font-size = 12

        palette = 0=#252b37
        palette = 1=#d0679d
        palette = 2=#5de4c7
        palette = 3=#fffac2
        palette = 4=#89ddff
        palette = 5=#fae4fc
        palette = 6=#add7ff
        palette = 7=#ffffff
        palette = 8=#a6accd
        palette = 9=#d0679d
        palette = 10=#5de4c7
        palette = 11=#fffac2
        palette = 12=#add7ff
        palette = 13=#89ddff
        palette = 14=#fcc5e9
        palette = 15=#ffffff
        background = #0f0f0f
        foreground = #a6accd
        cursor-color = #f2eacf
        selection-background = #1a1a1a
        selection-foreground = #f1f1f1
      '';
    };
  };

  home.packages = with pkgs; [
    ghostty
  ];
}
