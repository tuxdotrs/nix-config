{
  flake.modules.nixos.boot = {
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
