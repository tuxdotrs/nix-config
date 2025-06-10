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
      terminal = "ghostty";
      floating_terminal = "ghostty --class=com.ghostty.floating";
      editor = "ghostty -e nvim";
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
        active_opacity = 1.0;
        inactive_opacity = 1.0;
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

      #-- Window Rules
      # See https://wiki.hyprland.org/Configuring/Window-Rules
      windowrulev2 = [
        "float, class:com.github.hluk.copyq"
        "size 800 600, class:com.github.hluk.copyq"

        "float, class:org.pulseaudio.pavucontrol"
        "size 800 600, class:org.pulseaudio.pavucontrol"

        "float, class:com.ghostty.floating"
        "size 900 700, class:com.ghostty.floating"

        "workspace 3 silent, class:(firefox|Brave-browser)"
        "workspace 5 silent, class:(discord|Spotify|org.telegram.desktop)"
      ];

      bind = [
        # apps
        "SUPER, Return, exec, ${terminal}"
        "SUPER_SHIFT, Return, exec, ${floating_terminal}"
        "SUPER, A, exec, astal -t app-launcher"
        "SUPER, F, exec, ${filemanager}"
        "SUPER, E, exec, ${editor}"
        "SUPER, B, exec, ${browser}"
        "SUPER, G, exec, GalaxyBudsClient"
        "SUPER, D, exec, discord"
        "SUPER, V, exec, copyq show"

        # astal
        "SUPER_SHIFT, R, exec, astal -q; ${pkgs.tpanel}/bin/tpanel"

        # hyprland
        "SUPER, Q, killactive"
        "SUPER_SHIFT, Q, forcekillactive"
        "SUPER_SHIFT, F, fullscreen, 0"
        "SUPER_SHIFT, Space, togglefloating"

        # shutdown
        "SUPER_SHIFT, P, exec, poweroff"

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
        "SUPER_SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER_SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER_SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER_SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER_SHIFT, 5, movetoworkspacesilent, 5"
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

        # speaker and mic volume control
        " , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"
        " , XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%-"
        " , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        " , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # display and keyboard brightness control
        " , XF86MonBrightnessUp, exec, brightnessctl s +20%"
        " , XF86MonBrightnessDown, exec, brightnessctl s 20%-"
        " , XF86KbdBrightnessUp, exec, asusctl -n"
        " , XF86KbdBrightnessDown, exec, asusctl -p"

        # performance
        " , XF86Launch4, exec, asusctl profile -n"
      ];

      "exec-once" = [
        "${pkgs.swaybg}/bin/swaybg -i ~/Wallpapers/island-night.png"
        "${pkgs.tpanel}/bin/tpanel"
        "copyq"
      ];
    };
  };
}
