{inputs, ...}: {
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.tnix.services.trok;
    in {
      imports = [
        inputs.trok.nixosModules.default
      ];

      options.tnix.services.trok = {
        enable = mkEnableOption "trok";
      };

      config = mkIf cfg.enable {
        services.trok = {
          enable = true;
        };
      };
    };
}
