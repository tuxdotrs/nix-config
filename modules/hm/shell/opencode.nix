{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode-git;
      cli = {
        model = "zai-coding-plan/glm-5.3-flash";

        theme = {
          mode = "system";
          name = "system";
        };

        provider = {
          google = {
            settings = {
              apiKey = "{file:/run/secrets/gemini-api-key}";
            };
          };
          openrouter = {
            settings = {
              apiKey = "{file:/run/secrets/openrouter-api-key}";
            };
          };
          opencode-go = {
            settings = {
              apiKey = "{file:/run/secrets/opencode-go-api-key}";
            };
          };
          zai-coding-plan = {
            settings = {
              apiKey = "{file:/run/secrets/zai-coding-plan-api-key}";
            };
          };
        };
        plugins = ["@dietrichgebert/ponytail"];
      };
    };
  };
}
