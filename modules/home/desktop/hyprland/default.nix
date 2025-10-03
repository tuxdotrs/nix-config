{pkgs, ...}: {
  imports = [
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [ags];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
    systemd.variables = ["--all"];

    plugins = with pkgs.hyprland-plugins; [
      hyprexpo
    ];

    settings = let
      # Hyprland
      border_size = 0;
      gaps_in = 5;
      gaps_out = 10;
      gaps_ws = -10;
      rounding = 8;
      active_border_col = "rgba(90ceaaff) rgba(ecd3a0ff) 45deg";
      inactive_border_col = "rgba(86aaeccc) rgba(93cee9cc) 45deg";

      # Apps
      terminal = "wezterm";
      floating_terminal = "wezterm start --class wezterm-floating";
      editor = "wezterm -e nvim";
      browser = "brave";
      spotify = "wezterm start --class wezterm-floating -e spotify_player";
      filemanager = "wezterm start --class wezterm-floating -e superfile";
    in {
      #-- Output
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = "eDP-1,2560x1440@90,0x0,1";

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

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 1;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      #-- Decoration
      # See https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = rounding;
        active_opacity = 0.95;
        inactive_opacity = 0.95;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          xray = true;
          special = true;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
        };

        shadow = {
          enabled = false;
        };
      };

      #-- Animations
      # See https://wiki.hyprland.org/Configuring/Animations
      animations = {
        enabled = true;

        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1" # use with .2s duration
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 3, menu_decel"
          "fadeLayersOut, 1, 1.6, menu_accel"
          "workspaces, 1, 3, menu_decel, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
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

        # Wezterm and Ghostty floating terminal
        "float, class:(com.ghostty.floating|wezterm-floating)"
        "size 1400 1000, class:(com.ghostty.floating|wezterm-floating)"

        "float, class:GalaxyBudsClient"
        "size 900 700, class:GalaxyBudsClient"

        # KDE Connect
        "float, class:(org.kde.kdeconnect.sms|org.kde.kdeconnect.app)"
        "size 900 700, class:(org.kde.kdeconnect.sms|org.kde.kdeconnect.app)"

        "workspace 3 silent, class:(firefox|Brave-browser)"
        "workspace 5 silent, class:(discord|org.telegram.desktop)"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current";

          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;
        };
      };

      bind = [
        # apps
        "SUPER, Return, exec, ${terminal}"
        "SUPER, F, exec, ${filemanager}"
        "SUPER, E, exec, ${editor}"
        "SUPER, B, exec, ${browser}"
        "SUPER, G, exec, GalaxyBudsClient"
        "SUPER, D, exec, discord"
        "SUPER, S, exec, ${spotify}"
        "SUPER, V, exec, copyq show"

        "SUPER_SHIFT, Return, exec, ${floating_terminal}"
        "SUPER_SHIFT, S, exec, flameshot gui"

        # ags
        "SUPER, A, exec, ags toggle launcher"
        "SUPER, C, exec, ags toggle control-center"
        "SUPER_SHIFT, R, exec, ags quit; ${pkgs.tpanel}/bin/tpanel"
        "SUPER_SHIFT, B, exec, ags toggle bar"

        # hyprland
        "SUPER, Q, killactive"
        "SUPER, grave, hyprexpo:expo, toggle"
        "SUPER_SHIFT, Q, forcekillactive"
        "SUPER_SHIFT, F, fullscreen, 0"
        "SUPER_SHIFT, Space, exec, hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 1600 1200; hyprctl dispatch centerwindow;"

        # shutdown
        "SUPER_SHIFT, P, exec, poweroff"

        # lock
        "SUPER_SHIFT, L, exec, hyprlock"

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
        "SUPER_ALT, equal, exec, hyprctl dispatch centerwindow;"

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
        # load hyprland plugins
        "hyprctl plugin load '$HYPR_PLUGIN_DIR/lib/libhyprexpo.so'"

        "hyprpaper"
        "${pkgs.tpanel}/bin/tpanel"
        "copyq"
        "kdeconnectd"
        "kdeconnect-indicator"
      ];
    };
  };
}
