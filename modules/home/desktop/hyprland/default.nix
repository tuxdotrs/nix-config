{pkgs, ...}: {
  imports = [
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [ags awww];

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
      browser = "brave --new-window";
      spotify = "wezterm start --class wezterm-floating -e spotify_player";
      filemanager = "wezterm -e superfile";
    in {
      # See https://wiki.hyprland.org/Configuring/Multi-GPU
      env = "AQ_DRM_DEVICES,/dev/dri/card2";

      #-- Output
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = [
        "eDP-1,2560x1440@90,0x0,1"
        "HDMI-A-1,preferred,0x-1440,1"
      ];

      #-- Input: Keyboard, Mouse, Touchpad
      input = {
        sensitivity = -0.7;
        scroll_method = "2 fg";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = false;
        };
      };

      device = {
        name = "asue1209:00-04f3:319f-touchpad";
        sensitivity = 0;
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
        vfr = true;
        vrr = 1;
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
          enabled = false;
          size = 4;
          passes = 3;
          new_optimizations = true;
          xray = false;
          special = true;
          brightness = 1;
          noise = 0.02;
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
          "zoom, 0.05, 0.7, 0.1, 1.0"
        ];

        animation = [
          "windows, 1, 1, zoom, slide"
          "windowsIn, 1, 1, zoom, slide"
          "windowsOut, 1, 1, zoom, slidevert"
          "windowsMove, 1, 1, zoom, slide"
          "fade, 1, 2, zoom"
          "workspaces, 1, 1, zoom, slide"
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
        smart_resizing = true;
        drop_at_cursor = true;
      };

      #-- Window Rules
      # See https://wiki.hyprland.org/Configuring/Window-Rules
      windowrule = [
        "float on, center on, size 800 600, match:class org.pulseaudio.pavucontrol"

        # Wezterm and Ghostty floating terminal
        "float on, center on, size 1200 800, match:class (com.ghostty.floating|wezterm-floating)"

        "float on, center on, size 900 700, match:class GalaxyBudsClient"

        # KDE Connect
        "float on, center on, size 900 700, match:class (org.kde.kdeconnect.sms|org.kde.kdeconnect.app)"

        "workspace 7 silent, match:class (discord|org.telegram.desktop)"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "first 1";
          gesture_distance = 300;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      bindm = [
        "SUPER,mouse:273,resizewindow"
        "SUPER,mouse:272,movewindow"
      ];

      bind = [
        # apps
        "SUPER, Return, exec, ${terminal}"
        "SUPER, Space, exec, vicinae toggle"
        "SUPER, F, exec, ${filemanager}"
        "SUPER, E, exec, ${editor}"
        "SUPER, B, exec, ${browser}"
        "SUPER, G, exec, GalaxyBudsClient"
        "SUPER, D, exec, discord"
        "SUPER, T, exec, Telegram"
        "SUPER, S, exec, ${spotify}"
        "SUPER, V, exec, vicinae vicinae://extensions/vicinae/clipboard/history"

        "SUPER_SHIFT, Return, exec, ${floating_terminal}"
        "SUPER_SHIFT, S, exec, hypr-screenshot"
        "SUPER_SHIFT, W, exec, vicinae vicinae://extensions/sovereign/awww-switcher/wpgrid"

        # tpanel
        "SUPER_SHIFT, B, exec, ags toggle bar"
        "SUPER_SHIFT, C, exec, ags toggle control-center"
        "SUPER_SHIFT, R, exec, ags quit; ${pkgs.tpanel}/bin/tpanel"

        # hyprland
        "SUPER, Q, killactive"
        "SUPER, grave, hyprexpo:expo, toggle"
        "SUPER_SHIFT, Q, forcekillactive"
        "SUPER_SHIFT, F, fullscreen, 0"
        "SUPER_SHIFT, Space, exec, hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 1200 800; hyprctl dispatch centerwindow;"

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
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"

        # send to workspaces
        "SUPER_SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER_SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER_SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER_SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER_SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER_SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER_SHIFT, 7, movetoworkspacesilent, 7"
      ];

      workspace = [
        "1, monitor:HDMI-A-1, default:true"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
      ];

      binde = [
        # resize active
        "SUPER_CTRL, left,  resizeactive, -20 0"
        "SUPER_CTRL, right, resizeactive, 20 0"
        "SUPER_CTRL, up,    resizeactive, 0 -20"
        "SUPER_CTRL, down,  resizeactive, 0 20"
        "SUPER_CTRL, equal, exec, hyprctl dispatch layoutmsg mfact exact 0.5;"

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

        "awww-daemon"
        "${pkgs.tpanel}/bin/tpanel"
        "kdeconnectd"
        "kdeconnect-indicator"
      ];
    };
  };
}
