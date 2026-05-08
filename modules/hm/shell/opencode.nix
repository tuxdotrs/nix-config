{
  flake.modules.homeManager.shell =
    {
      osConfig ? { },
      ...
    }:
    {
      programs.opencode = {
        enable = true;
        tui = {
          theme = "system";
        };
        settings = {
          provider = {
            google = {
              options = {
                apiKey = "{file:${osConfig.sops.secrets.gemini-api-key.path}}";
              };
            };
            openrouter = {
              options = {
                apiKey = "{file:${osConfig.sops.secrets.openrouter-api-key.path}}";
              };
            };
            opencode-go = {
              options = {
                apiKey = "{file:${osConfig.sops.secrets.opencode-go-api-key.path}}";
              };
            };
          };
        };
      };
    };
}
