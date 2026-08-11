{
  inputs,
  outputs,
  config,
  ...
}:
let
  mkHost =
    hostName:
    {
      userName ? "tux",
      userEmail ? "t@tux.rs",
      system ? "x86_64-linux",
      unstable ? true,
    }:
    let
      nixpkgs = if unstable then inputs.nixpkgs else inputs.nixpkgs-stable;
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          hostName
          userName
          userEmail
          system
          ;
      };
      modules = [
        config.flake.modules.nixos.core
        config.flake.modules.nixos.${hostName}
      ];
    };

  mkDroidHost =
    hostName:
    {
      userName ? "nix-on-droid",
      userEmail ? "t@tux.rs",
      system ? "aarch64-linux",
      unstable ? true,
    }:
    let
      nixpkgs = if unstable then inputs.nixpkgs else inputs.nixpkgs-stable;
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        inherit system;
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
in
{
  flake.nixosConfigurations = builtins.mapAttrs mkHost {
    alpha = { };
    arcturus = { };
    canopus = { };
    sirius = { };
    vps = { };
  };

  flake.nixOnDroidConfigurations = builtins.mapAttrs mkDroidHost {
    vega = { };
  };
}
