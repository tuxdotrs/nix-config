{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        xwayland.enable = true;
        systemd.variables = [ "--all" ];
      };

      # TODO: Hyprland 0.55 switched to Lua-based configuration.
      # Until the Home Manager module is updated, we symlink our config instead.
      home.file = {
        ".config/hypr/config".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/hypr/config";
        ".config/hypr/hyprland.lua".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/hypr/hyprland.lua";
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
