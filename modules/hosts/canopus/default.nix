{
  inputs,
  config,
  ...
}:
let
  hostName = "canopus";
  userName = "tux";
  userEmail = "t@tux.rs";
  system = "x86_64-linux";
  unstable = true;
  nixpkgs = if unstable then inputs.nixpkgs else inputs.nixpkgs-stable;
in
{
  flake.nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit hostName userName userEmail; };
    modules = [
      config.flake.modules.nixos.core
      config.flake.modules.nixos.${hostName}
    ];
  };
}
