{pkgs, ...}: {
  home.packages = with pkgs; [astal];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = let
      # Hyprland
      border_size = 2;
      gaps_in = 5;
      gaps_out = 5;
      gaps_ws = -10;
      rounding = 8;
      active_border_col = "rgba(90ceaaff) rgba(ecd3a0ff) 45deg";
      inactive_border_col = "rgba(86aaeccc) rgba(93cee9cc) 45deg";

      # Apps
      terminal = "wezterm";
      editor = "wezterm -e nvim";
      browser = "firefox";
      filemanager = "thunar";
    in {
      #-- Output
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = ",preferred,auto,1";

      #-- Input: Keyboard, Mouse, Touchpad
      input = {
        sensitivity = 0;
        scroll_method = "2 fg";
        natural_scroll = true;
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = false;
        };
      };

      #-- General
      # See https://wiki.hyprland.org/Configuring/Variables
      general = {
        border_size = border_size;
        gaps_in = gaps_in;
        gaps_out = gaps_out;
        gaps_workspaces = gaps_ws;
        layout = "master";
        resize_on_border = true;

        "col.active_border" = active_border_col;
        "col.inactive_border" = inactive_border_col;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      #-- Decoration
      # See https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = rounding;
        active_opacity = 0.8;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 5;
          passes = 4;
          ignore_opacity = true;
          xray = true;
          special = true;
        };
      };

      #-- Animations
      # See https://wiki.hyprland.org/Configuring/Animations
      animations = {
        enabled = true;
        animation = [
          "windowsIn, 1, 2, default, popin 0%"
          "windowsOut, 1, 2, default, popin"
          "windowsMove, 1, 2, default, slide"
          "workspaces, 1, 2, default"
          "fade, 1, 2, default"
        ];
      };

      #-- Layout : Master
      # See https://wiki.hyprland.org/Configuring/Master-Layout
      master = {
        allow_small_split = false;
        special_scale_factor = 0.8;
        mfact = 0.5;
        new_on_top = false;
        orientation = "left";
        inherit_fullscreen = true;
        smart_resizing = true;
        drop_at_cursor = true;
      };

      bind = [
        # apps
        "SUPER, Return, exec, ${terminal}"
        "SUPER, A, exec, astal -t app-launcher"
        "SUPER, F, exec, ${filemanager}"
        "SUPER, E, exec, ${editor}"
        "SUPER, B, exec, ${browser}"
        "SUPER, G, exec, GalaxyBudsClient"

        # astal
        "SUPER_SHIFT, R, exec, astal -q; ${pkgs.tpanel}/bin/tpanel"

        # hyprland
        "SUPER, Q, killactive,"
        "SUPER_SHIFT, F, fullscreen, 0"
        "SUPER_SHIFT, Space, togglefloating,"

        # change focus
        "SUPER, left,  movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up,    movefocus, u"
        "SUPER, down,  movefocus, d"

        # move active
        "SUPER_SHIFT, left,  movewindow, l"
        "SUPER_SHIFT, right, movewindow, r"
        "SUPER_SHIFT, up,    movewindow, u"
        "SUPER_SHIFT, down,  movewindow, d"

        # workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"

        # send to workspaces
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
      ];

      binde = [
        # resize active
        "SUPER_CTRL, left,  resizeactive, -20 0"
        "SUPER_CTRL, right, resizeactive, 20 0"
        "SUPER_CTRL, up,    resizeactive, 0 -20"
        "SUPER_CTRL, down,  resizeactive, 0 20"

        # move active (Floating Only)
        "SUPER_ALT, left,  moveactive, -20 0"
        "SUPER_ALT, right, moveactive, 20 0"
        "SUPER_ALT, up,    moveactive, 0 -20"
        "SUPER_ALT, down,  moveactive, 0 20"
      ];

      "exec-once" = [
        "${pkgs.swaybg}/bin/swaybg -i ~/Wallpapers/ALLqk82.png"
        "${pkgs.tpanel}/bin/tpanel"
      ];
    };
  };
}
