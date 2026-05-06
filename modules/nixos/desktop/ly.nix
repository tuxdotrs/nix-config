{
  flake.modules.nixos.desktop = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        # session_log = "null";
      };
    };
  };
}
