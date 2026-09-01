{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      # TODO: Hyprland 0.55 switched to Lua-based configuration.
      # HM module is updated but I'm too lazy at this point so we symlink our config instead.
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        xwayland.enable = true;
        configType = "hyprlang";
        systemd.variables = [ "--all" ];
      };

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
