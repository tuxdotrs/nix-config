{inputs, ...}: {
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.trok;
  in {
    imports = [
      inputs.trok.nixosModules.default
    ];

    options.tnix.services.trok = {
      enable = lib.mkEnableOption "trok";
    };

    config = lib.mkIf cfg.enable {
      services.trok = {
        enable = true;
      };
    };
  };
}
