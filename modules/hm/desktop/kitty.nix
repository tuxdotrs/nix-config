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
      keybindings = {
        "alt+t" = "new_tab";
        "alt+shift+q" = "close_tab";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "alt+]" = "move_tab_forward";
        "alt+[" = "move_tab_backward";

        "alt+enter" = "new_window";
        "alt+q" = "close_window";
        "alt+shift+1" = "first_window";
        "alt+shift+2" = "second_window";
        "alt+shift+3" = "third_window";
        "alt+shift+4" = "fourth_window";
        "alt+shift+5" = "fifth_window";
        "alt+shift+6" = "sixth_window";
        "alt+shift+7" = "seventh_window";
        "alt+shift+8" = "eighth_window";
        "alt+shift+9" = "ninth_window";
        "alt+shift+]" = "next_window";
        "alt+shift+[" = "previous_window";
        "alt+left" = "neighboring_window left";
        "alt+right" = "neighboring_window right";
        "alt+up" = "neighboring_window up";
        "alt+down" = "neighboring_window down";
        "alt+shift+left" = "move_window left";
        "alt+shift+right" = "move_window right";
        "alt+shift+up" = "move_window up";
        "alt+shift+down" = "move_window down";

        "f2" = "set_tab_title";
      };

      settings = {
        background_opacity = "1.0";

        copy_on_select = "yes";

        enable_audio_bell = false;
        confirm_os_window_close = 0;

        cursor_trail = 3;
        enabled_layouts = "grid";

        # Window
        window_padding_width = 10;
        window_margin_width = 3;
        window_border_width = "0.5pt";

        # Tab bar
        tab_bar_edge = "bottom";
        tab_bar_style = "fade";

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
