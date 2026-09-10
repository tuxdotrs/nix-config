{...}: {
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.tnix.programs.nix-ld;
    in {
      options.tnix.programs.nix-ld = {
        enable = mkEnableOption "nix-ld";
      };

      config = mkIf cfg.enable {
        programs.nix-ld.enable = true;
      };
    };
}
