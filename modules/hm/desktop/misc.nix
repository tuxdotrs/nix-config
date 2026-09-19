{
  flake.modules.homeManager.desktop = {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/discord" = "vesktop.desktop";

        "text/html" = "brave-origin.desktop";
        "x-scheme-handler/http" = "brave-origin.desktop";
        "x-scheme-handler/https" = "brave-origin.desktop";
        "x-scheme-handler/about" = "brave-origin.desktop";
        "x-scheme-handler/unknown" = "brave-origin.desktop";

        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
    };
  };
}
