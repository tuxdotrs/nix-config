{...}: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        bold.family = "JetBrainsMono Nerd Font";
        italic.family = "JetBrainsMono Nerd Font";
        bold_italic.family = "JetBrainsMono Nerd Font";
        size = 12;
      };

      window = {
        padding = {
          x = 15;
          y = 15;
        };

        decorations = "none";
        opacity = 1.0;
        dynamic_title = true;
      };

      selection.save_to_clipboard = false;

      general.live_config_reload = true;

      colors = {
        primary = {
          background = "#0f0f0f";
          foreground = "#a5b6cf";
        };
        normal = {
          black = "#1c1e27";
          blue = "#8baff1";
          cyan = "#98d3ee";
          green = "#95d3af";
          magenta = "#c79bf0";
          red = "#e26c7c";
          white = "#d0d3d8";
          yellow = "#f1d8a5";
        };
        bright = {
          black = "#151720";
          blue = "#86aaec";
          cyan = "#93cee9";
          green = "#90ceaa";
          magenta = "#c296eb";
          red = "#dd6777";
          white = "#cbced3";
          yellow = "#ecd3a0";
        };
        cursor = {
          cursor = "#a5b6cf";
          text = "CellForeground";
        };
        selection = {
          text = "CellForeground";
          background = "0x303340";
        };
        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
      };
    };
  };
}
