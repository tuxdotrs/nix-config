{...}: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["vivaldi.desktop"];
      "text/html" = ["vivaldi.desktop"];
      "x-scheme-handler/http" = ["vivaldi.desktop"];
      "x-scheme-handler/https" = ["vivaldi.desktop"];
      "x-scheme-handler/about" = ["vivaldi.desktop"];
      "x-scheme-handler/unknown" = ["vivaldi.desktop"];
    };
  };
}
