{inputs, ...}: {
  imports = [
    inputs.mango.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # Monitors
      monitorrule = name:eDP-1, width:2560, height:1440, refresh:165, x:0, y:10, vrr:1
      monitorrule = name:HDMI-A-1, width:2560, height:1440, refresh:100, x:0, y:-1440, vrr:1

      # Keyboard
      repeat_rate = 25
      repeat_delay = 600
      numlockon = 0
      xkb_rules_layout = us

      # Trackpad
      disable_trackpad = 0
      tap_to_click = 1
      tap_and_drag = 1
      drag_lock = 1
      trackpad_natural_scrolling = 1
      disable_while_typing = 1
      left_handed = 0
      middle_button_emulation = 0
      swipe_min_threshold = 1

      # Mouse
      mouse_natural_scrolling = 0
      accel_profile = 0

      # Theme
      border_radius = 8
      no_radius_when_single = 0
      focused_opacity = 1.0
      unfocused_opacity = 1.0

      # Scroller Layout Setting
      scroller_structs = 0
      scroller_default_proportion = 0.5
      scroller_ignore_proportion_single = 0
      scroller_default_proportion_single = 1.0

      # Master-Stack Layout Setting
      new_is_master = 0
      default_mfact = 0.5
      default_nmaster = 1
      smartgaps = 0

      # Overview Setting
      hotarea_size = 10
      enable_hotarea = 1
      ov_tab_mode = 0
      overviewgappi = 15
      overviewgappo = 15

      # layouts
      tagrule = id:1, layout_name:tile
      tagrule = id:2, layout_name:tile
      tagrule = id:3, layout_name:tile
      tagrule = id:4, layout_name:tile
      tagrule = id:5, layout_name:tile
      tagrule = id:6, layout_name:scroller

      # Keybindings
      mousebind = SUPER, btn_left, moveresize, curmove
      mousebind = SUPER, btn_right, moveresize, curresize
      gesturebind = none, left, 3, viewtoright_have_client
      gesturebind = none, right, 3, viewtoleft_have_client
      gesturebind = none, up, 3, toggleoverview
      gesturebind = none, down, 3, toggleoverview

      # apps
      bind = SUPER, Return, spawn, wezterm
      bind = SUPER, Space, spawn, vicinae toggle
      bind = SUPER, B, spawn, brave
      bind = SUPER, V, spawn, vicinae vicinae://extensions/vicinae/clipboard/history
      bind = SUPER+SHIFT, W, spawn, vicinae vicinae://extensions/sovereign/awww-switcher/wpgrid

      # WM
      bind = SUPER, Q, killclient
      bind = SUPER+SHIFT, R, reload_config
      bind = SUPER+SHIFT, F, togglefullscreen
      bind = SUPER+SHIFT, Space, togglefloating

      bind = ALT, Tab, toggleoverview
      bind = ALT+SHIFT, minus, incgaps, -1
      bind = ALT+SHIFT, equal, incgaps, 1
      bind = ALT+SHIFT, R, togglegaps

      # switch layout
      bind = SUPER+SHIFT, H, setlayout, tile
      bind = SUPER+SHIFT, V, setlayout, vertical_tile
      bind = SUPER+SHIFT, S, setlayout, scroller

      # resize client
      bind = SUPER+CTRL, Up, resizewin, +0, -50
      bind = SUPER+CTRL, Down, resizewin, +0, +50
      bind = SUPER+CTRL, Left, resizewin, -50, +0
      bind = SUPER+CTRL, Right, resizewin, +50, +0

      # swap client
      bind = SUPER+SHIFT, Up, exchange_client, up
      bind = SUPER+SHIFT, Down, exchange_client, down
      bind = SUPER+SHIFT, Left, exchange_client, left
      bind = SUPER+SHIFT, Right, exchange_client, right

      # switch client focus
      bind = SUPER, Tab, focusstack, next
      bind = SUPER, Left, focusdir, left
      bind = SUPER, Right, focusdir, right
      bind = SUPER, Up, focusdir, up
      bind = SUPER, Down, focusdir, down

      # switch view
      bind = SUPER, 1, view, 1, 0
      bind = SUPER, 2, view, 2, 0
      bind = SUPER, 3, view, 3, 0
      bind = SUPER, 4, view, 4, 0
      bind = SUPER, 5, view, 5, 0
      bind = SUPER, 6, view, 6, 0

      # move client to the tag with focus
      bind = SUPER+SHIFT, 1, tagsilent, 1, 0
      bind = SUPER+SHIFT, 2, tagsilent, 2, 0
      bind = SUPER+SHIFT, 3, tagsilent, 3, 0
      bind = SUPER+SHIFT, 4, tagsilent, 4, 0
      bind = SUPER+SHIFT, 5, tagsilent, 5, 0
      bind = SUPER+SHIFT, 6, tagsilent, 6, 0

      # move client to the tag without focus
      bind = SUPER+ALT, 1, tag, 1, 0
      bind = SUPER+ALT, 2, tag, 2, 0
      bind = SUPER+ALT, 3, tag, 3, 0
      bind = SUPER+ALT, 4, tag, 4, 0
      bind = SUPER+ALT, 5, tag, 5, 0
      bind = SUPER+ALT, 6, tag, 6, 0

      # Window effect
      blur = 0
      blur_layer = 0
      blur_optimized = 1
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      shadows = 0
      layer_shadows = 0
      shadow_only_floating = 1
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor = 0x000000ff

      # Animation
      animations = 1
      layer_animations = 1
      animation_type_open = slide
      animation_type_close = fade
      animation_fade_in = 1
      animation_fade_out = 1
      tag_animation_direction = 1
      zoom_initial_ratio = 0.3
      zoom_end_ratio = 0.8
      fadein_begin_opacity = 0.5
      fadeout_begin_opacity = 0.8

      animation_duration_move = 100
      animation_duration_open = 100
      animation_duration_close = 100
      animation_duration_tag = 200
      animation_duration_focus = 0

      animation_curve_open = 0.46, 1.0, 0.29, 1
      animation_curve_move = 0.46, 1.0, 0.29, 1
      animation_curve_tag = 0.46, 1.0, 0.29, 1
      animation_curve_close = 0.08, 0.92, 0, 1
      animation_curve_focus = 0.46, 1.0, 0.29, 1
      animation_curve_opafadeout = 0.5, 0.5, 0.5, 0.5
      animation_curve_opafadein = 0.46, 1.0, 0.29, 1

      # Appearance
      borderpx = 0
      gappih = 10
      gappiv = 10
      gappoh = 10
      gappov = 10

      rootcolor = 0x201b14ff
      bordercolor = 0x444444ff
      focuscolor = 0xc9b890ff
      maximizescreencolor = 0x89aa61ff
      urgentcolor = 0xad401fff
      scratchpadcolor = 0x516c93ff
      globalcolor = 0xb153a7ff
      overlaycolor = 0x14a57cff

      # Misc
      adaptive_sync = 1
      syncobj_enable = 1

      exec-once = awww-daemon
      exec-once = kdeconnectd
      exec-once = kdeconnect-indicator
      exec-once = dbus-update-activation-environment --systemd --all; systemctl --user reset-failed && systemctl --user start mango-session.target
    '';
  };
}
