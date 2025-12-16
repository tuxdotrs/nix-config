{pkgs, ...}: {
  services.picom = {
    enable = true;
    package = pkgs.picom;

    backend = "glx";
    vSync = true;

    fade = true;
    fadeDelta = 10;
    fadeSteps = [0.05 0.05];
    fadeExclude = [
      "window_type *= 'menu'"
    ];

    activeOpacity = 1;
    inactiveOpacity = 1;
    opacityRules = [
      "90:class_g = 'rofi'"
      "90:class_g = 'thunar'"
      "90:class_g = 'spotify'"
      "90:class_g = 'discord'"
      "90:class_g = 'code'"
      "90:class_g = 'org.wezfurlong.wezterm'"
      "90:class_g = 'wezterm-floating'"
    ];

    settings = {
      glx-no-stencil = true;
      glx-copy-from-font = false;
      use-damage = false;

      frame-opacity = 1;
      blur-background = true;
      blur-method = "dual_kawase";
      blur-strength = 10;

      corner-radius = 8;

      rounded-corners-exclude = [
        "window_type = 'dock'"
      ];

      # pijulius specifics
      animations = true;
      animation-stiffness = 500;
      animation-window-mass = 1.0;
      animation-dampening = 26;
      animation-delta = 10;
      animation-force_steps = false;
      animation-clamping = true;

      animation-for-open-window = "slide-up";
      animation-for-menu-window = "slide-down";
      animation-for-transient-window = "slide-down";
      animation-for-unmap-window = "slide-up";

      animation-for-next-tag = "slide-right";
      animation-for-prev-tag = "slide-left";
      enable-fading-next-tag = true;
      enable-fading-prev-tag = true;
    };
  };
}
