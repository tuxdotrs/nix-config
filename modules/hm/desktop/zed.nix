{
  flake.modules.homeManager.desktop = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "lua"
        "nix"
        "C#"
        "solidity"
      ];
      userKeymaps = [
        {
          context = "Workspace";
          bindings = {
            F7 = "workspace::NewTerminal";
          };
        }
      ];
      userSettings = {
        ui_font_size = 18;
        buffer_font_size = 18;
        theme = {
          mode = "dark";
          light = "Ayu Light";
          dark = "Ayu Dark";
        };
        vim_mode = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        agent = {
          dock = "right";
          favorite_models = [];
          model_parameters = [];
        };

        collaboration_panel = {
          button = false;
        };

        agent_servers = {
          opencode = {
            default_config_options = {
              model = "zai-coding-plan/glm-5.3-flash";
            };
            type = "registry";
          };
        };
      };
    };
  };
}
