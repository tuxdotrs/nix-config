{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      security = {
        sudo.wheelNeedsPassword = false;
      };
    };
}
