{ config, ... }:
{
  flake.modules.homeManager.sirius = {
    imports = with config.flake.modules.homeManager; [
      desktop
    ];

    tnix = {
      desktop = {
        mangowm = {
          enable = true;
          monitorRule = [
            "name:DP-2, width:1440, height:2560, refresh:144, x:0, y:0, vrr:0, rr:1"
            "name:DP-3, width:2560, height:1440, refresh:144, x:1440, y:0, vrr:0"
            "name:DP-1, width:1080, height:1920, refresh:144, x:4000, y:0, vrr:0, rr:3"
          ];

          tagRule = [
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
        };
      };

      services.lan-mouse = {
        enable = true;
        settings = {
          clients = [
            {
              position = "bottom";
              hostname = "canopus";
              activate_on_startup = true;
              ips = [ "192.168.8.2" ];
            }
          ];
        };
      };
    };

    home.stateVersion = "26.05";
  };
}
