{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode-git;
      tui = {
        theme = "system";
      };
      settings = {
        model = "opencode-go/deepseek-v4.1-flash";
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
          zai-coding-plan = {
            options = {
              apiKey = "{file:/run/secrets/zai-coding-plan-api-key}";
            };
          };
        };
        plugin = ["@dietrichgebert/ponytail"];
      };
    };
  };
}
