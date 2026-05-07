{
  flake.modules.homeManager.shell = {
    programs.opencode = {
      enable = true;
      tui = {
        theme = "system";
      };
      settings = {
        provider = {
          openrouter = {
            options = {
              apiKey = "{file:/run/secrets/open_router_api_key}";
            };
          };
          opencode-go = {
            options = {
              apiKey = "{file:/run/secrets/open_code_go_api_key}";
            };
          };
        };
      };
    };
  };
}
