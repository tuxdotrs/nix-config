{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;

      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12.0;
      };

      shellIntegration.enableZshIntegration = true;

      settings = {
        background_opacity = "1.0";

        enable_audio_bell = false;
        confirm_os_window_close = 0;

        # Window
        window_padding_width = 10;

        foreground = "#f1f1f1";
        background = "#0f0f0f";

        # Borders
        active_border_color = "#3d59a1";
        inactive_border_color = "#101014";
        bell_border_color = "#fffac2";

        # Colors
        color0 = "#0f0f0f";
        color8 = "#a6accd";

        color1 = "#d0679d";
        color9 = "#d0679d";

        color2 = "#5de4c7";
        color10 = "#5de4c7";

        color3 = "#fffac2";
        color11 = "#fffac2";

        color4 = "#89ddff";
        color12 = "#add7ff";

        color5 = "#fcc5e9";
        color13 = "#fae4fc";

        color6 = "#add7ff";
        color14 = "#89ddff";

        color7 = "#ffffff";
        color15 = "#ffffff";

        # Cursor
        cursor = "#ffffff";
        cursor_text_color = "#0f0f0f";

        # Selection
        selection_foreground = "none";
        selection_background = "#28344a";

        # URLs
        url_color = "#5de4c7";

        # Tab bar
        tab_bar_edge = "bottom";
        tab_bar_style = "fade";
        tab_fade = "1";

        active_tab_foreground = "#3d59a1";
        active_tab_background = "#16161e";
        active_tab_font_style = "bold";

        inactive_tab_foreground = "#787c99";
        inactive_tab_background = "#16161e";
        inactive_tab_font_style = "bold";

        tab_bar_background = "#101014";
      };
    };
  };
}
