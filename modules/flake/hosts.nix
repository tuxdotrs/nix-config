{
  self,
  inputs,
  config,
  ...
}:
let
  mkNixOSHost =
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

  mkNixOSNode =
    hostName:
    {
      system ? "x86_64-linux",
    }:
    {
      hostname = hostName;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${hostName};
      };
    };

  activateNixOnDroid =
    system: configuration:
    inputs.deploy-rs.lib.${system}.activate.custom configuration.activationPackage
      "${configuration.activationPackage}/activate";

  mkDroidNode =
    hostName:
    {
      system ? "aarch64-linux",
    }:
    {
      hostname = hostName;
      profiles.system = {
        sshUser = "nix-on-droid";
        user = "nix-on-droid";
        magicRollback = true;
        sshOpts = [
          "-p"
          "8033"
        ];
        path = activateNixOnDroid system self.nixOnDroidConfigurations.${hostName};
      };
    };

in
{
  flake = {
    nixosConfigurations = builtins.mapAttrs mkNixOSHost {
      sirius = { };
      canopus = { };
      arcturus = { };
      alpha = { };
      vps = { };
    };

    nixOnDroidConfigurations = builtins.mapAttrs mkDroidHost {
      vega = { };
    };

    deploy.nodes =
      builtins.mapAttrs (hostName: _: mkNixOSNode hostName { }) self.nixosConfigurations
      // builtins.mapAttrs (hostName: _: mkDroidNode hostName { }) self.nixOnDroidConfigurations;
  };

  perSystem = {
    checks = builtins.mapAttrs (
      _: hostConfig: hostConfig.config.system.build.toplevel
    ) self.nixosConfigurations;
  };
}
