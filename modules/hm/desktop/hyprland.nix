{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        ags
        awww
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        xwayland.enable = true;
        systemd.variables = [ "--all" ];
      };
    };
}
