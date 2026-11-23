{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs.pi-coding-agent = {
      enable = true;
      package = pkgs.llm-agents.pi;
      mutableSettings = true;

      models.providers = {
        google.apiKey = "!cat /run/secrets/gemini-api-key";
        openrouter.apiKey = "!cat /run/secrets/openrouter-api-key";
        opencode-go.apiKey = "!cat /run/secrets/opencode-go-api-key";
        zai.apiKey = "!cat /run/secrets/zai-coding-plan-api-key";
        ollama = {
          api = "openai-completions";
          apiKey = "ollama";
          baseUrl = "http://localhost:11434/v1";
          models = [{id = "llama3.1:8b";}];
        };
      };

      settings = {
        defaultModel = "glm-5.3-flash";
        defaultProvider = "zai";
        defaultThinkingLevel = "medium";
        theme = "dark";
      };
    };

    home.packages = with pkgs; [llm-agents.omp];
  };
}
