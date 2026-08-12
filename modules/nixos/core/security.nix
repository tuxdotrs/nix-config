{
  flake.modules.nixos.core = {
    security = {
      sudo.wheelNeedsPassword = false;
    };
  };
}
