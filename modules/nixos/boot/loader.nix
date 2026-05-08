{
  flake.modules.nixos.boot = {
    boot.loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
  };
}
