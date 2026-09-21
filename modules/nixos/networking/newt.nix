{
  flake.modules.nixos.networking = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.networking.newt;
  in {
    options.tnix.networking.newt = {
      enable = lib.mkEnableOption "Newt";

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file with secrets passed to Newt";
      };
    };

    config = lib.mkIf cfg.enable {
      services.newt = {
        enable = true;
        environmentFile = cfg.environmentFile;
      };
    };
  };
}
