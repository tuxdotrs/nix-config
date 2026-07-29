{
  flake.modules.homeManager.shell = {
    programs.opencode = {
      enable = true;
      tui = {
        theme = "system";
      };
      settings = {
        model = "opencode-go/kimi-k3";
        provider = {
          google = {
            options = {
              apiKey = "{file:/run/secrets/gemini-api-key}";
            };
          };
          openrouter = {
            options = {
              apiKey = "{file:/run/secrets/openrouter-api-key}";
            };
          };
          opencode-go = {
            options = {
              apiKey = "{file:/run/secrets/opencode-go-api-key}";
            };
          };
        };
      };
    };
  };
}
