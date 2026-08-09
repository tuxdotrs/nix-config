{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.networking.newt;
    in
    {
      options.tnix.networking.newt = {
        enable = mkEnableOption "Newt";

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Environment file with secrets passed to Newt";
        };
      };

      config = mkIf cfg.enable {
        services.newt = {
          enable = true;
          environmentFile = cfg.environmentFile;
        };
      };
    };
}
