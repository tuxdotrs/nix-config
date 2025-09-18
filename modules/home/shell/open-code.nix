{
  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      provider = {
        google = {
          options = {
            apiKey = "{file:/run/secrets/gemini_api_key}";
          };
        };
        openrouter = {
          options = {
            apiKey = "{file:/run/secrets/open_router_api_key}";
          };
        };
      };
    };
  };
}
