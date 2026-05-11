{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        xwayland.enable = true;
        systemd.variables = [ "--all" ];
      };

      home.packages = with pkgs; [
        ags
        awww
        grim
        slurp
        hyprshot
        wl-clipboard
        wl-screenrec
        (writeShellScriptBin "hypr-screenshot" ''
          hyprshot -m region -r ppm - | satty --filename -
        '')

        (writeShellScriptBin "hypr-screenrecord" ''
          wl-screenrec -g "$(slurp)"
        '')
      ];
    };
}
