{...}: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["brave-browser.desktop"];
      "text/html" = ["brave-browser.desktop"];
      "x-scheme-handler/http" = ["brave-browser.desktop"];
      "x-scheme-handler/https" = ["brave-browser.desktop"];
      "x-scheme-handler/about" = ["brave-browser.desktop"];
      "x-scheme-handler/unknown" = ["brave-browser.desktop"];
    };
  };
}
