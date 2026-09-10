{inputs, ...}: {
  flake.modules.nixos.desktop = {
    imports = [
      inputs.serpantinum.nixosModules.default
    ];

    programs.serpantinum.enable = true;
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = [
      inputs.serpantinum.homeManagerModules.default
    ];

    home.packages = with pkgs; [pulseaudioFull];

    programs.serpantinum = {
      enable = true;
      systemd.enable = true;

      settings = {
        wallpaperDir = "/home/tux/Wallpapers";

        general = {
          language = "en";
          weatherUnit = "metric";
          weatherInterval = 30;
        };

        bar = {
          position = "top";
          style = "modular";
          width = 5;
          workspaceCount = 7;
          modules = {
            left = [
              "left"
              "workspaces"
              "sysmon"
              "wifi"
            ];
            center = ["vis"];
            right = [
              "media"
              "vol"
              "bat"
              "tray"
              "timedate"
            ];
          };
        };

        theme = {
          fontFamily = "JetBrains Mono SemiBold";
          borderRadius = 12;
          matugen = true;
        };

        notifications = {
          dnd = false;
          position = "top right";
          sound = true;
        };

        idle = {
          enabled = true;
          manualInhibit = true;
        };
      };
    };
  };
}
