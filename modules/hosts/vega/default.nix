{
  inputs,
  outputs,
  config,
  ...
}:
let
  hostName = "vega";
  userName = "nix-on-droid";
  userEmail = "t@tux.rs";
  system = "aarch64-linux";
  unstable = true;
  nixpkgs = if unstable then inputs.nixpkgs else inputs.nixpkgs-stable;
in
{
  flake.nixOnDroidConfigurations."${hostName}" = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import nixpkgs {
      system = system;
      config = {
        allowUnfree = true;
        joypixels.acceptLicense = true;
      };
      overlays = builtins.attrValues inputs.self.overlays;
    };
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        hostName
        userName
        userEmail
        ;
    };

    modules = [
      config.flake.modules.droid.core
      config.flake.modules.droid.networking
      config.flake.modules.droid.${hostName}
    ];
  };
}
