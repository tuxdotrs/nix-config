{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm-git;
    enableZshIntegration = false;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      config.check_for_updates = false

      config.window_close_confirmation = 'NeverPrompt'
      config.color_scheme = 'Poimandres'
      config.colors = {
        background = "#0f0f0f"
      }
      config.enable_tab_bar = false
      config.font = wezterm.font_with_fallback {
        'JetBrainsMono Nerd Font',
      }
      config.font_size = 12.0
      config.window_background_opacity = 1
      config.audible_bell = "Disabled"

      return config
    '';
  };
}
