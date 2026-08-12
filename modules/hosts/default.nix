{
  self,
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
        config.flake.modules.nixOnDroid.core
        config.flake.modules.nixOnDroid.${hostName}
      ];
    };

  mkNixOSNode = hostname: {
    inherit hostname;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
    };
  };

  activateNixOnDroid =
    configuration:
    inputs.deploy-rs.lib.aarch64-linux.activate.custom configuration.activationPackage "${configuration.activationPackage}/activate";

  mkDroidNode = hostname: {
    inherit hostname;
    profiles.system = {
      sshUser = "nix-on-droid";
      user = "nix-on-droid";
      magicRollback = true;
      sshOpts = [
        "-p"
        "8033"
      ];
      path = activateNixOnDroid self.nixOnDroidConfigurations.${hostname};
    };
  };
in
{
  flake = {
    nixosConfigurations = builtins.mapAttrs mkHost {
      sirius = { };
      canopus = { };
      arcturus = { };
      alpha = { };
      vps = { };
    };

    nixOnDroidConfigurations = builtins.mapAttrs mkDroidHost {
      vega = { };
    };

    deploy.nodes = {
      sirius = mkNixOSNode "sirius";
      canopus = mkNixOSNode "canopus";
      arcturus = mkNixOSNode "arcturus";
      alpha = mkNixOSNode "alpha";
      vega = mkDroidNode "vega";
    };
  };

  perSystem = {
    checks = builtins.mapAttrs (
      _: config: config.config.system.build.toplevel
    ) self.nixosConfigurations;
  };
}
