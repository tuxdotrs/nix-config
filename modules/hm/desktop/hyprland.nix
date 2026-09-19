{
  flake.modules.homeManager.desktop = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.tnix.desktop.hyprland;
    in {
      options.tnix.desktop.hyprland = {
        enable = mkEnableOption "tux's Hyprland";

        monitorConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Hyprland monitor configuration";
        };

        workspaceConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Hyprland workspace configuration";
        };
      };

      config = mkIf cfg.enable {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          xwayland.enable = true;
          configType = "hyprlang";
          systemd.variables = ["--all"];
        };

        home.file = {
          ".config/hypr" = {
            recursive = true;
            source = pkgs.twm.hyprland;
          };
          ".config/hypr/config/monitors.lua".text = cfg.monitorConfig;
          ".config/hypr/config/workspaces.lua".text = cfg.workspaceConfig;
        };

        home.packages = with pkgs; [
          ags
          awww
          grim
          slurp
          hyprshot
          wl-clipboard
          wl-screenrec
          omasnap
          (writeShellScriptBin "hypr-screenshot" ''
            hyprshot -m region -r ppm - | satty --filename -
          '')

          (writeShellScriptBin "hypr-screenrecord" ''
            wl-screenrec -g "$(slurp)"
          '')
        ];
      };
    };
}
