{ inputs, ... }:
{
  flake.modules.nixos.core = { pkgs, ... }: {
    imports = [
      inputs.nix-index-database.nixosModules.default
    ];

    programs = {
      nix-index.package = pkgs.nix-index-small;
      nix-index-database.comma.enable = true;
    };
  };
}
