{ inputs, ... }:
{
  flake.modules.homeManager.core =
    {
      lib,
      osConfig ? { },
      ...
    }:
    {
      nixpkgs = lib.mkIf (!(osConfig.home-manager.useGlobalPkgs or false)) {
        config = {
          allowUnfree = true;
          joypixels.acceptLicense = true;
        };
        overlays = builtins.attrValues inputs.self.overlays;
      };
    };
}
