{ inputs, ... }:
{
  flake.modules.nixos.core = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        joypixels.acceptLicense = true;
      };
      overlays = builtins.attrValues inputs.self.overlays;
    };
  };
}
