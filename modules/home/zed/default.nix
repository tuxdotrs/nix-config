{
  programs.zed-editor = {
    enable = true;
    extensions = ["lua" "nix" "C#" "solidity"];
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          F7 = "workspace::NewTerminal";
        };
      }
    ];
    userSettings = {
      ui_font_size = 8;
      buffer_font_size = 8;
      theme = {
        mode = "dark";
        light = "Ayu Light";
        dark = "Ayu Dark";
      };
      vim_mode = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}
