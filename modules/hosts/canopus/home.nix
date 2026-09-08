{ config, ... }:
{
  flake.modules.homeManager.canopus = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      desktop
    ];

    tnix = {
      desktop = {
        mangowm = {
          enable = true;
          monitorRule = [
            "name:eDP-1, width:2560, height:1440, refresh:165, x:0, y:0, vrr:1"
          ];

          tagRule = [
            "id:1, layout_name:tile"
            "id:2, layout_name:tile"
            "id:3, layout_name:tile"
            "id:4, layout_name:tile"
            "id:5, layout_name:scroller"
          ];
        };
      };

      services.lan-mouse = {
        enable = true;
        settings = {
          authorized_fingerprints = {
            "f4:4b:17:61:f7:01:a4:a2:e1:c7:8c:1c:7a:f3:8b:87:14:3d:05:3d:a0:8b:cc:e7:88:d8:d8:d2:a4:c2:75:8b" =
              "sirius";
          };
        };
      };
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "mirror-display" ''
        hyprctl eval 'hl.monitor({
          output   = "eDP-1",
          mode     = "2560x1440@165",
          position = "0x0",
          scale    = "1",
          disabled = false
        })' && 
        hyprctl eval 'hl.monitor({
          output   = "HDMI-A-1",
          mode     = "preferred",
          position = "auto",
          scale    = "1",
          mirror   = "eDP-1"
        })'
      '')
      (writeShellScriptBin "extend-display" ''
        hyprctl eval 'hl.monitor({
          output   = "eDP-1",
          mode     = "2560x1440@165",
          position = "0x0",
          scale    = "1",
          disabled = false
        })' && 
        hyprctl eval 'hl.monitor({
          output   = "HDMI-A-1",
          mode     = "preferred",
          position = "0x-1440",
          scale    = "1",
          mirror   = ""
        })'
      '')
      (writeShellScriptBin "dock-display" ''
        hyprctl eval 'hl.monitor({
          output   = "eDP-1",
          disabled = true
        })' && 
        hyprctl eval 'hl.monitor({
          output   = "HDMI-A-1",
          mode     = "preferred",
          position = "0x0",
          scale    = "1",
          mirror   = ""
        })'
      '')
    ];

    home.stateVersion = "26.05";
  };
}
