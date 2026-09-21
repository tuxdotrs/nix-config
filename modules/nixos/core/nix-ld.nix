{...}: {
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.programs.nix-ld;
  in {
    options.tnix.programs.nix-ld = {
      enable = lib.mkEnableOption "nix-ld";
    };

    config = lib.mkIf cfg.enable {
      programs.nix-ld.enable = true;
    };
  };
}
