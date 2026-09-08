{
  flake.modules.homeManager.desktop = {
    programs.satty = {
      enable = true;
      settings = {
        general = {
          corner-roundness = 12;
          initial-tool = "arrow";
          early-exit = true;
          copy-command = "wl-copy";
        };

        font = {
          family = "JetBrainsMono NerdFont";
        };
      };
    };
  };
}
