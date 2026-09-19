{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    home.file.".pi/agent/auth.json".text = builtins.toJSON {
      google = {
        type = "api_key";
        key = "!cat /run/secrets/gemini-api-key";
      };
      openrouter = {
        type = "api_key";
        key = "!cat /run/secrets/openrouter-api-key";
      };
      opencode-go = {
        type = "api_key";
        key = "!cat /run/secrets/opencode-go-api-key";
      };
      zai = {
        type = "api_key";
        key = "!cat /run/secrets/zai-coding-plan-api-key";
      };
    };

    programs.pi-coding-agent = {
      enable = true;
      package = pkgs.llm-agents.pi;

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
