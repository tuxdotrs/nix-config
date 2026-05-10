{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.mango.hmModules.mango
      ];

      wayland.windowManager.mango = {
        enable = true;
        settings = {
          # Monitors
          monitorrule = [
            "name:DP-2, width:1440, height:2560, refresh:144, x:0, y:0, vrr:0, rr:1"
            "name:DP-3, width:2560, height:1440, refresh:144, x:1440, y:0, vrr:0"
            "name:DP-1, width:1080, height:1920, refresh:144, x:4000, y:0, vrr:0, rr:3"
          ];

          focus_cross_monitor = 1;
          exchange_cross_monitor = 1;
          drag_tile_to_tile = 1;

          # Keyboard
          repeat_rate = 25;
          repeat_delay = 600;
          numlockon = 0;
          xkb_rules_layout = "us";

          # Trackpad
          disable_trackpad = 0;
          tap_to_click = 1;
          tap_and_drag = 1;
          drag_lock = 1;
          trackpad_natural_scrolling = 1;
          disable_while_typing = 1;
          left_handed = 0;
          middle_button_emulation = 0;
          swipe_min_threshold = 1;

          # Mouse
          mouse_natural_scrolling = 0;
          mouse_accel_profile = 0;

          # Theme
          border_radius = 8;
          no_radius_when_single = 0;
          focused_opacity = 0.9;
          unfocused_opacity = 0.9;

          # Scroller Layout Setting
          scroller_structs = 0;
          scroller_default_proportion = 0.5;
          scroller_ignore_proportion_single = 0;
          scroller_default_proportion_single = 1.0;

          # Master-Stack Layout Setting
          new_is_master = 0;
          default_mfact = 0.5;
          default_nmaster = 1;
          smartgaps = 0;

          # Overview Setting
          hotarea_size = 10;
          enable_hotarea = 1;
          ov_tab_mode = 0;
          overviewgappi = 15;
          overviewgappo = 15;

          # layouts
          tagrule = [
            "id:1, layout_name:vertical_tile, monitor_name:DP-2, no_hide:1"
            "id:2, layout_name:vertical_tile, monitor_name:DP-2, no_hide:1"
            "id:3, layout_name:vertical_tile, monitor_name:DP-2, no_hide:1"
            "id:4, layout_name:vertical_tile, monitor_name:DP-2, no_hide:1"
            "id:5, layout_name:vertical_tile, monitor_name:DP-2, no_hide:1"

            "id:1, layout_name:tile, monitor_name:DP-3, no_hide:1"
            "id:2, layout_name:tile, monitor_name:DP-3, no_hide:1"
            "id:3, layout_name:tile, monitor_name:DP-3, no_hide:1"
            "id:4, layout_name:tile, monitor_name:DP-3, no_hide:1"
            "id:5, layout_name:tile, monitor_name:DP-3, no_hide:1"

            "id:1, layout_name:vertical_tile, monitor_name:DP-1, no_hide:1"
            "id:2, layout_name:vertical_tile, monitor_name:DP-1, no_hide:1"
            "id:3, layout_name:vertical_tile, monitor_name:DP-1, no_hide:1"
            "id:4, layout_name:vertical_tile, monitor_name:DP-1, no_hide:1"
            "id:5, layout_name:vertical_tile, monitor_name:DP-1, no_hide:1"
          ];

          # Keybindings
          mousebind = [
            "SUPER, btn_left, moveresize, curmove"
            "SUPER, btn_right, moveresize, curresize"
          ];

          gesturebind = [
            "none, right, 3, viewtoleft_have_client"
            "none, up, 3, toggleoverview"
            "none, down, 3, toggleoverview"
          ];

          bind = [
            # apps
            "SUPER, Return, spawn, wezterm"
            "SUPER, Space, spawn, vicinae toggle"
            "SUPER, D, spawn, vesktop"
            "SUPER, T, spawn, Telegram"
            "SUPER, B, spawn, brave"
            "SUPER, V, spawn, vicinae vicinae://extensions/vicinae/clipboard/history"
            "SUPER+SHIFT, W, spawn, vicinae vicinae://extensions/sovereign/awww-switcher/wpgrid"

            # WM
            "SUPER, Q, killclient"
            "SUPER+SHIFT, R, reload_config"
            "SUPER+SHIFT, F, togglefullscreen"
            "SUPER+SHIFT, Space, togglefloating"
            "SUPER+SHIFT, Space, centerwin"

            "ALT, Tab, toggleoverview"
            "ALT+SHIFT, minus, incgaps, -1"
            "ALT+SHIFT, equal, incgaps, 1"
            "ALT+SHIFT, R, togglegaps"

            # switch layout
            "SUPER+SHIFT, H, setlayout, tile"
            "SUPER+SHIFT, V, setlayout, vertical_tile"
            "SUPER+SHIFT, S, setlayout, scroller"

            # resize client
            "SUPER+CTRL, Up, resizewin, +0, -50"
            "SUPER+CTRL, Down, resizewin, +0, +50"
            "SUPER+CTRL, Left, resizewin, -50, +0"
            "SUPER+CTRL, Right, resizewin, +50, +0"

            # swap client
            "SUPER+SHIFT, Up, exchange_client, up"
            "SUPER+SHIFT, Down, exchange_client, down"
            "SUPER+SHIFT, Left, exchange_client, left"
            "SUPER+SHIFT, Right, exchange_client, right"

            # switch client focus
            "SUPER, Tab, focusstack, next"
            "SUPER, Left, focusdir, left"
            "SUPER, Right, focusdir, right"
            "SUPER, Up, focusdir, up"
            "SUPER, Down, focusdir, down"

            # switch view
            "SUPER, 1, view, 1, 1"
            "SUPER, 2, view, 2, 1"
            "SUPER, 3, view, 3, 1"
            "SUPER, 4, view, 4, 1"
            "SUPER, 5, view, 5, 1"

            # move client to the tag with focus
            "SUPER+SHIFT, 1, tagsilent, 1, 1"
            "SUPER+SHIFT, 2, tagsilent, 2, 1"
            "SUPER+SHIFT, 3, tagsilent, 3, 1"
            "SUPER+SHIFT, 4, tagsilent, 4, 1"
            "SUPER+SHIFT, 5, tagsilent, 5, 1"

            # move client to the tag without focus
            "SUPER+ALT, 1, tag, 1, 1"
            "SUPER+ALT, 2, tag, 2, 1"
            "SUPER+ALT, 3, tag, 3, 1"
            "SUPER+ALT, 4, tag, 4, 1"
            "SUPER+ALT, 5, tag, 5, 1"
          ];

          # Window effect
          blur = 1;
          blur_layer = 0;
          blur_optimized = 1;
          blur_params_num_passes = 2;
          blur_params_radius = 5;
          blur_params_noise = 0.02;
          blur_params_brightness = 0.9;
          blur_params_contrast = 0.9;
          blur_params_saturation = 1.2;

          shadows = 1;
          layer_shadows = 0;
          shadow_only_floating = 1;
          shadows_size = 10;
          shadows_blur = 15;
          shadows_position_x = 0;
          shadows_position_y = 0;
          shadowscolor = "0x000000ff";

          # Animation
          animations = 1;
          layer_animations = 1;
          animation_type_open = "slide";
          animation_type_close = "fade";
          animation_fade_in = 1;
          animation_fade_out = 1;
          tag_animation_direction = 0;
          zoom_initial_ratio = 0.3;
          zoom_end_ratio = 0.8;
          fadein_begin_opacity = 0.5;
          fadeout_begin_opacity = 0.8;

          animation_duration_move = 100;
          animation_duration_open = 100;
          animation_duration_close = 100;
          animation_duration_tag = 200;
          animation_duration_focus = 0;

          animation_curve_open = "0.46, 1.0, 0.29, 1";
          animation_curve_move = "0.46, 1.0, 0.29, 1";
          animation_curve_tag = "0.46, 1.0, 0.29, 1";
          animation_curve_close = "0.08, 0.92, 0, 1";
          animation_curve_focus = "0.46, 1.0, 0.29, 1";
          animation_curve_opafadeout = "0.5, 0.5, 0.5, 0.5";
          animation_curve_opafadein = "0.46, 1.0, 0.29, 1";

          # Appearance
          borderpx = 0;
          gappih = 10;
          gappiv = 10;
          gappoh = 10;
          gappov = 10;

          rootcolor = "0x201b14ff";
          bordercolor = "0x444444ff";
          focuscolor = "0xc9b890ff";
          maximizescreencolor = "0x89aa61ff";
          urgentcolor = "0xad401fff";
          scratchpadcolor = "0x516c93ff";
          globalcolor = "0xb153a7ff";
          overlaycolor = "0x14a57cff";

          # Misc
          syncobj_enable = 1;

          exec-once = [
            "dbus-update-activation-environment --systemd --all; systemctl --user reset-failed && systemctl --user start mango-session.target"
            "awww-daemon"
            "dms run"
          ];
        };
      };

      home.packages = with pkgs; [
        quickshell
        dms-shell
        dgop
      ];
    };
}
